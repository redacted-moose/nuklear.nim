## nuklear - v1.05 - public domain

import
  stb_image as stbi,
  ../nuklear,
  glfw,
  opengl,
  math,
  unicode,
  os

const
  WINDOW_WIDTH = 1200
  WINDOW_HEIGHT = 800
  MAX_VERTEX_MEMORY = 512 * 1024
  MAX_ELEMENT_MEMORY = 128 * 1024

when defined(macosx):
  const
    SHADER_VERSION = "#version 150\n"
else:
  const
    SHADER_VERSION = "#version 300 es\n"

type
  Media = object
    skin: GLint
    menu: Image
    check: Image
    checkCursor: Image
    option: Image
    optionCursor: Image
    header: Image
    window: Image
    scrollbarIncButton: Image
    scrollbarIncButtonHover: Image
    scrollbarDecButton: Image
    scrollbarDecButtonHover: Image
    button: Image
    buttonHover: Image
    buttonActive: Image
    tabMinimize: Image
    tabMaximize: Image
    slider: Image
    sliderHover: Image
    sliderActive: Image


## ===============================================================
##
##                           DEVICE
##
## ===============================================================

type
  GlfwVertex = object
    position: array[2, cfloat]
    uv: array[2, cfloat]
    col: array[4, byte]

  Device = object
    cmds: Buffer
    null: DrawNullTexture
    vbo: GLuint
    vao: GLuint
    ebo: GLuint
    prog: GLuint
    vertShdr: GLuint
    fragShdr: GLuint
    attribPos: GLint
    attribUv: GLint
    attribCol: GLint
    uniformTex: GLint
    uniformProj: GLint
    fontTex: GLuint


var vertexLayout: array[4, DrawVertexLayoutElement] = [
    initDrawVertexLayoutElement(nkVertexPosition, FORMAT_FLOAT, offsetof(GlfwVertex, position)),
    initDrawVertexLayoutElement(nkVertexTexcoord, FORMAT_FLOAT, offsetof(GlfwVertex, uv)),
    initDrawVertexLayoutElement(nkVertexColor, FORMAT_R8G8B8A8, offsetof(GlfwVertex, col)),
    VERTEX_LAYOUT_END]

proc imageLoad(filename: string): GLuint =
  var
    x: int
    y: int
    n: int

  var tex: GLuint
  var data: seq[uint8] = stbi.load(filename, x, y, n, 0)

  if data == nil:
  #  die("failed to load image: %s", filename)
    quit -1

  glGenTextures(1, addr(tex))
  glBindTexture(GL_TEXTURE_2D, tex)
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GLfloat(GL_LINEAR_MIPMAP_NEAREST))
  # glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GLfloat(GL_LINEAR_MIPMAP_NEAREST))
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GLfloat(GL_CLAMP_TO_EDGE))
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GLfloat(GL_CLAMP_TO_EDGE))
  glTexImage2D(GL_TEXTURE_2D, 0, GLint(GL_RGBA8), GLsizei(x), GLsizei(y), 0, GL_RGBA, GL_UNSIGNED_BYTE, cast[pointer](data))
  glGenerateMipmap(GL_TEXTURE_2D)
  # stbi.imageFree(data)
  return tex

proc logProgram(program: GLuint) =
   var length: GLint = 0
   glGetProgramiv(program, GL_INFO_LOG_LENGTH, length.addr)
   var log: string = newString(length.int)
   glGetProgramInfoLog(program, length, nil, log)
   echo "Log: \n", log

proc deviceInit(dev: var Device) =
  var status: GLint
  var
    vertShader: array[12, string] =
      [
        SHADER_VERSION,
        "uniform mat4 ProjMtx;\n",
        "in vec2 Position;\n",
        "in vec2 TexCoord;\n",
        "in vec4 Color;\n",
        "out vec2 Frag_UV;\n",
        "out vec4 Frag_Color;\n",
        "void main() {\n",
        "    Frag_UV = TexCoord;\n",
        "    Frag_Color = Color;\n",
        "    gl_Position = ProjMtx * vec4(Position.xy, 0, 1);\n",
        "}\n"
      ]
    vertexShader = allocCStringArray(vertShader)
    fragShader: array[9, string] =
      [
        SHADER_VERSION,
        "precision mediump float;\n",
        "uniform sampler2D Texture;\n",
        "in vec2 Frag_UV;\n",
        "in vec4 Frag_Color;\n",
        "out vec4 Out_Color;\n",
        "void main() {\n",
        "    Out_Color = Frag_Color * texture(Texture, Frag_UV.st);\n",
        "}\n"
      ]
    fragmentShader: cstringArray = allocCStringArray(fragShader)

  bufferInitDefault(addr(dev.cmds))

  dev.prog = glCreateProgram()
  dev.vertShdr = glCreateShader(GL_VERTEX_SHADER)
  dev.fragShdr = glCreateShader(GL_FRAGMENT_SHADER)

  glShaderSource(dev.vertShdr, GLsizei(len(vertShader)), vertexShader, nil)
  glShaderSource(dev.fragShdr, GLsizei(len(fragShader)), fragmentShader, nil)

  glCompileShader(dev.vertShdr)
  glCompileShader(dev.fragShdr)

  glGetShaderiv(dev.vertShdr, GL_COMPILE_STATUS, addr(status))
  assert(status == GLint(GL_TRUE))

  glGetShaderiv(dev.fragShdr, GL_COMPILE_STATUS, addr(status))
  assert(status == GLint(GL_TRUE))

  glAttachShader(dev.prog, dev.vertShdr)
  glAttachShader(dev.prog, dev.fragShdr)

  glLinkProgram(dev.prog)
  glGetProgramiv(dev.prog, GL_LINK_STATUS, addr(status))
  if status != GLint(GL_TRUE):
    logProgram(dev.prog)
  assert(status == GLint(GL_TRUE))

  dev.uniformTex = glGetUniformLocation(dev.prog, "Texture")
  dev.uniformProj = glGetUniformLocation(dev.prog, "ProjMtx")
  dev.attribPos = glGetAttribLocation(dev.prog, "Position")
  dev.attribUv = glGetAttribLocation(dev.prog, "TexCoord")
  dev.attribCol = glGetAttribLocation(dev.prog, "Color")

  deallocCStringArray(vertexShader)
  deallocCStringArray(fragmentShader)

  ## buffer setup
  var
    vs: GLsizei = GLsizei(sizeof(GlfwVertex))
    vp: csize = offsetof(GlfwVertex, position)
    vt: csize = offsetof(GlfwVertex, uv)
    vc: csize = offsetof(GlfwVertex, col)

  glGenBuffers(1, addr(dev.vbo))
  glGenBuffers(1, addr(dev.ebo))
  glGenVertexArrays(1, addr(dev.vao))
  glBindVertexArray(dev.vao)
  glBindBuffer(GL_ARRAY_BUFFER, dev.vbo)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, dev.ebo)
  glEnableVertexAttribArray(GLuint(dev.attribPos))
  glEnableVertexAttribArray(GLuint(dev.attribUv))
  glEnableVertexAttribArray(GLuint(dev.attribCol))
  glVertexAttribPointer(GLuint(dev.attribPos), 2, cGL_FLOAT, GL_FALSE, vs, cast[pointer](vp))
  glVertexAttribPointer(GLuint(dev.attribUv), 2, cGL_FLOAT, GL_FALSE, vs, cast[pointer](vt))
  glVertexAttribPointer(GLuint(dev.attribCol), 4, GL_UNSIGNED_BYTE, GL_TRUE, vs, cast[pointer](vc))
  glBindTexture(GL_TEXTURE_2D, 0)
  glBindBuffer(GL_ARRAY_BUFFER, 0)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
  glBindVertexArray(0)

proc uploadAtlas(dev: var Device; image: pointer; width: cint; height: cint) =
  glGenTextures(1, addr(dev.fontTex))
  glBindTexture(GL_TEXTURE_2D, dev.fontTex)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexImage2D(GL_TEXTURE_2D, 0, GLint(GL_RGBA), GLsizei(width), GLsizei(height), 0, GL_RGBA, GL_UNSIGNED_BYTE, image)

proc shutdown(dev: var Device) =
  glDetachShader(dev.prog, dev.vertShdr)
  glDetachShader(dev.prog, dev.fragShdr)
  glDeleteShader(dev.vertShdr)
  glDeleteShader(dev.fragShdr)
  glDeleteProgram(dev.prog)
  glDeleteTextures(1, addr(dev.fontTex))
  glDeleteBuffers(1, addr(dev.vbo))
  glDeleteBuffers(1, addr(dev.ebo))
  free(addr(dev.cmds))

proc draw(dev: var Device; ctx: ptr Context; width: int; height: int; scale: Vec2; aa: AntiAliasing) =
  var
    ortho: array[4, array[4, GLfloat]] = [
      [GLfloat(  2.0),   0.0,   0.0,   0.0],
      [GLfloat(  0.0), - 2.0,   0.0,   0.0],
      [GLfloat(  0.0),   0.0, - 1.0,   0.0],
      [GLfloat(- 1.0),   1.0,   0.0,   1.0]
    ]

  ortho[0][0] = ortho[0][0] / GLfloat(width)
  ortho[1][1] = ortho[1][1] / GLfloat(height)

  ## setup global state
  glEnable(GL_BLEND)
  glBlendEquation(GL_FUNC_ADD)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  glDisable(GL_CULL_FACE)
  glDisable(GL_DEPTH_TEST)
  glEnable(GL_SCISSOR_TEST)
  glActiveTexture(GL_TEXTURE0)

  ## setup program
  glUseProgram(dev.prog)
  glUniform1i(dev.uniformTex, 0)
  glUniformMatrix4fv(dev.uniformProj, 1, GL_FALSE, addr(ortho[0][0]))

  ## convert from command queue into draw list and draw to screen
  # var cmd: ptr DrawCommand
  var
    vertices: pointer
    elements: pointer

  var offset: ptr DrawIndex = nil

  ## allocate vertex and element buffer
  glBindVertexArray(dev.vao)
  glBindBuffer(GL_ARRAY_BUFFER, dev.vbo)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, dev.ebo)
  glBufferData(GL_ARRAY_BUFFER, MAX_VERTEX_MEMORY, nil, GL_STREAM_DRAW)
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, MAX_ELEMENT_MEMORY, nil, GL_STREAM_DRAW)

  ## load draw vertices & elements directly into vertex + element buffer
  vertices = glMapBuffer(GL_ARRAY_BUFFER, GL_WRITE_ONLY)
  elements = glMapBuffer(GL_ELEMENT_ARRAY_BUFFER, GL_WRITE_ONLY)

  ## fill convert configuration
  var config: ConvertConfig

  # memset(addr(config), 0, sizeof(config))
  config.vertexLayout = addr(vertexLayout[0])
  config.vertexSize = sizeof(GlfwVertex)
  # config.vertexAlignment = alignof(GlfwVertex)
  config.null = dev.null
  config.circleSegmentCount = 22
  config.curveSegmentCount = 22
  config.arcSegmentCount = 22
  config.globalAlpha = 1.0
  config.shapeAA = aa
  config.lineAA = aa

  ## setup buffers to load vertices and elements
  var
    vbuf: Buffer
    ebuf: Buffer

  bufferInitFixed(addr(vbuf), vertices, MAX_VERTEX_MEMORY)
  bufferInitFixed(addr(ebuf), elements, MAX_ELEMENT_MEMORY)
  ctx.convert(addr(dev.cmds), addr(vbuf), addr(ebuf), addr(config))
  discard glUnmapBuffer(GL_ARRAY_BUFFER)
  discard glUnmapBuffer(GL_ELEMENT_ARRAY_BUFFER)

  ## iterate over and execute each draw command
  for cmd in ctx.drawCommands(addr(dev.cmds)):
    if cmd.elemCount == 0: continue
    glBindTexture(GL_TEXTURE_2D, GLuint(cmd.texture.id))
    glScissor(GLint(cmd.clipRect.x * scale.x), GLint(
        (height - GLint(cmd.clipRect.y + cmd.clipRect.h)).float * scale.y),
              GLint(cmd.clipRect.w * scale.x), GLint(cmd.clipRect.h * scale.y))
    glDrawElements(GL_TRIANGLES, GLsizei(cmd.elemCount), GL_UNSIGNED_SHORT, offset)
    offset = nuklear.offset(offset, cmd.elemCount.int)

  clear(ctx)

  ## default OpenGL state
  glUseProgram(0)
  glBindBuffer(GL_ARRAY_BUFFER, 0)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
  glBindVertexArray(0)
  glDisable(GL_BLEND)
  glDisable(GL_SCISSOR_TEST)

## glfw callbacks (I don't know if there is a easier way to access text and scroll )

proc errorCallback*(e: cint; d: cstring) =
  echo "Error " & $e & ": " & $d

when isMainModule:
  ## Platform
  var win: Win

  var
    width: int = 0
    height: int = 0

  var
    displayWidth: int = 0
    displayHeight: int = 0

  ## GUI
  var
    device: Device
    atlas: FontAtlas
    media: Media
    ctx: Context
    font: ptr Font

  var textInput = proc(win: Win; codepoint: unicode.Rune) =
    inputUnicode(addr(ctx), nuklear.Rune(codepoint))

  var scrollInput = proc(win: Win; offset: tuple[x: float; y: float]) =
    inputScroll(addr(ctx), offset.y)

  ## GLFW
  glfw.init()

  when defined(macosx):
    win = glfw.newGlWin((WINDOW_WIDTH, WINDOW_HEIGHT), "Demo", version = glv33, forwardCompat = true, profile = glpCore)
  else:
    win = glfw.newGlWin((WINDOW_WIDTH, WINDOW_HEIGHT), "Demo", version = glv33, profile = glpCore)

  opengl.loadExtensions()
  glfw.makeContextCurrent(win)
  win.charCb = textInput
  win.scrollCb = scrollInput
  (width, height) = win.size
  (displayWidth, displayHeight) = win.framebufSize

  ## OpenGL
  glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  # glewExperimental = 1
  # if glewInit() != glew_Ok:
  #   stderr.write("Failed to setup GLEW\n")
  #   quit(1)

  deviceInit(device)

  var
    image: pointer
    w: cint
    h: cint

  var fontPath: string = if paramCount() >= 1: paramStr(1) else: nil

  initDefault(addr(atlas))

  begin(addr(atlas))
  font = if fontPath != nil: addFromFile(addr(atlas), fontPath, 13.0, nil) else: addDefault(addr(atlas), 13.0, nil)
  image = bake(addr(atlas), addr(w), addr(h), FONT_ATLAS_RGBA32)
  device.uploadAtlas(image, w, h)
  `end`(addr(atlas), handleId(cint(device.fontTex)), addr(device.null))

  discard initDefault(addr(ctx), addr(font.handle))

  ## skin
  # glEnable(GL_TEXTURE_2D)
  media.skin = GLint(imageLoad("example/skins/gwen.png"))
  media.check = subimageId(media.skin, 512, 512, rect(464, 32, 15, 15))
  media.checkCursor = subimageId(media.skin, 512, 512, rect(450, 34, 11, 11))
  media.option = subimageId(media.skin, 512, 512, rect(464, 64, 15, 15))
  media.optionCursor = subimageId(media.skin, 512, 512, rect(451, 67, 9, 9))
  media.header = subimageId(media.skin, 512, 512, rect(128, 0, 127, 24))
  media.window = subimageId(media.skin, 512, 512, rect(128, 23, 127, 104))
  media.scrollbarIncButton = subimageId(media.skin, 512, 512, rect(464, 256, 15, 15))
  media.scrollbarIncButtonHover = subimageId(media.skin, 512, 512, rect(464, 320, 15, 15))
  media.scrollbarDecButton = subimageId(media.skin, 512, 512, rect(464, 224, 15, 15))
  media.scrollbarDecButtonHover = subimageId(media.skin, 512, 512, rect(464, 288, 15, 15))
  media.button = subimageId(media.skin, 512, 512, rect(384, 336, 127, 31))
  media.buttonHover = subimageId(media.skin, 512, 512, rect(384, 368, 127, 31))
  media.buttonActive = subimageId(media.skin, 512, 512, rect(384, 400, 127, 31))
  media.tabMinimize = subimageId(media.skin, 512, 512, rect(451, 99, 9, 9))
  media.tabMaximize = subimageId(media.skin, 512, 512, rect(467, 99, 9, 9))
  media.slider = subimageId(media.skin, 512, 512, rect(418, 33, 11, 14))
  media.sliderHover = subimageId(media.skin, 512, 512, rect(418, 49, 11, 14))
  media.sliderActive = subimageId(media.skin, 512, 512, rect(418, 64, 11, 14))

  ## window
  ctx.style.window.background = rgb(204, 204, 204)
  ctx.style.window.fixedBackground = styleItemImage(media.window)
  ctx.style.window.borderColor = rgb(67, 67, 67)
  ctx.style.window.comboBorderColor = rgb(67, 67, 67)
  ctx.style.window.contextualBorderColor = rgb(67, 67, 67)
  ctx.style.window.menuBorderColor = rgb(67, 67, 67)
  ctx.style.window.groupBorderColor = rgb(67, 67, 67)
  ctx.style.window.tooltipBorderColor = rgb(67, 67, 67)
  ctx.style.window.scrollbarSize = vec2(16, 16)
  ctx.style.window.borderColor = rgba(0, 0, 0, 0)
  ctx.style.window.padding = vec2(8, 4)
  ctx.style.window.border = 3

  ## window header
  # ctx.style.window.header
  ctx.style.window.header.normal = styleItemImage(media.header)
  ctx.style.window.header.hover = styleItemImage(media.header)
  ctx.style.window.header.active = styleItemImage(media.header)
  ctx.style.window.header.labelNormal = rgb(95, 95, 95)
  ctx.style.window.header.labelHover = rgb(95, 95, 95)
  ctx.style.window.header.labelActive = rgb(95, 95, 95)

  ## scrollbar
  ctx.style.scrollv.normal = styleItemColor(rgb(184, 184, 184))
  ctx.style.scrollv.hover = styleItemColor(rgb(184, 184, 184))
  ctx.style.scrollv.active = styleItemColor(rgb(184, 184, 184))
  ctx.style.scrollv.cursorNormal = styleItemColor(rgb(220, 220, 220))
  ctx.style.scrollv.cursorHover = styleItemColor(rgb(235, 235, 235))
  ctx.style.scrollv.cursorActive = styleItemColor(rgb(99, 202, 255))
  ctx.style.scrollv.decSymbol = SYMBOL_NONE
  ctx.style.scrollv.incSymbol = SYMBOL_NONE
  ctx.style.scrollv.showButtons = true.cint
  ctx.style.scrollv.borderColor = rgb(81, 81, 81)
  ctx.style.scrollv.cursorBorderColor = rgb(81, 81, 81)
  ctx.style.scrollv.border = 1
  ctx.style.scrollv.rounding = 0
  ctx.style.scrollv.borderCursor = 1
  ctx.style.scrollv.roundingCursor = 2

  ## scrollbar buttons
  ctx.style.scrollv.incButton.normal = styleItemImage(media.scrollbarIncButton)
  ctx.style.scrollv.incButton.hover = styleItemImage(media.scrollbarIncButtonHover)
  ctx.style.scrollv.incButton.active = styleItemImage(media.scrollbarIncButtonHover)
  ctx.style.scrollv.incButton.borderColor = rgba(0, 0, 0, 0)
  ctx.style.scrollv.incButton.textBackground = rgba(0, 0, 0, 0)
  ctx.style.scrollv.incButton.textNormal = rgba(0, 0, 0, 0)
  ctx.style.scrollv.incButton.textHover = rgba(0, 0, 0, 0)
  ctx.style.scrollv.incButton.textActive = rgba(0, 0, 0, 0)
  ctx.style.scrollv.incButton.border = 0.0
  ctx.style.scrollv.decButton.normal = styleItemImage(media.scrollbarDecButton)
  ctx.style.scrollv.decButton.hover = styleItemImage(media.scrollbarDecButtonHover)
  ctx.style.scrollv.decButton.active = styleItemImage(media.scrollbarDecButtonHover)
  ctx.style.scrollv.decButton.borderColor = rgba(0, 0, 0, 0)
  ctx.style.scrollv.decButton.textBackground = rgba(0, 0, 0, 0)
  ctx.style.scrollv.decButton.textNormal = rgba(0, 0, 0, 0)
  ctx.style.scrollv.decButton.textHover = rgba(0, 0, 0, 0)
  ctx.style.scrollv.decButton.textActive = rgba(0, 0, 0, 0)
  ctx.style.scrollv.decButton.border = 0.0

  ## checkbox toggle
  block checkbox:
    var toggle: ptr StyleToggle
    toggle = addr(ctx.style.checkbox)
    toggle.normal = styleItemImage(media.check)
    toggle.hover = styleItemImage(media.check)
    toggle.active = styleItemImage(media.check)
    toggle.cursorNormal = styleItemImage(media.checkCursor)
    toggle.cursorHover = styleItemImage(media.checkCursor)
    toggle.textNormal = rgb(95, 95, 95)
    toggle.textHover = rgb(95, 95, 95)
    toggle.textActive = rgb(95, 95, 95)

  ## option toggle
  block option:
    var toggle: ptr StyleToggle
    toggle = addr(ctx.style.option)
    toggle.normal = styleItemImage(media.option)
    toggle.hover = styleItemImage(media.option)
    toggle.active = styleItemImage(media.option)
    toggle.cursorNormal = styleItemImage(media.optionCursor)
    toggle.cursorHover = styleItemImage(media.optionCursor)
    toggle.textNormal = rgb(95, 95, 95)
    toggle.textHover = rgb(95, 95, 95)
    toggle.textActive = rgb(95, 95, 95)

  ## default button
  ctx.style.button.normal = styleItemImage(media.button)
  ctx.style.button.hover = styleItemImage(media.buttonHover)
  ctx.style.button.active = styleItemImage(media.buttonActive)
  ctx.style.button.borderColor = rgba(0, 0, 0, 0)
  ctx.style.button.textBackground = rgba(0, 0, 0, 0)
  ctx.style.button.textNormal = rgb(95, 95, 95)
  ctx.style.button.textHover = rgb(95, 95, 95)
  ctx.style.button.textActive = rgb(95, 95, 95)

  ## default text
  ctx.style.text.color = rgb(95, 95, 95)

  ## contextual button
  ctx.style.contextualButton.normal = styleItemColor(rgb(206, 206, 206))
  ctx.style.contextualButton.hover = styleItemColor(rgb(229, 229, 229))
  ctx.style.contextualButton.active = styleItemColor(rgb(99, 202, 255))
  ctx.style.contextualButton.borderColor = rgba(0, 0, 0, 0)
  ctx.style.contextualButton.textBackground = rgba(0, 0, 0, 0)
  ctx.style.contextualButton.textNormal = rgb(95, 95, 95)
  ctx.style.contextualButton.textHover = rgb(95, 95, 95)
  ctx.style.contextualButton.textActive = rgb(95, 95, 95)

  ## menu button
  ctx.style.menuButton.normal = styleItemColor(rgb(206, 206, 206))
  ctx.style.menuButton.hover = styleItemColor(rgb(229, 229, 229))
  ctx.style.menuButton.active = styleItemColor(rgb(99, 202, 255))
  ctx.style.menuButton.borderColor = rgba(0, 0, 0, 0)
  ctx.style.menuButton.textBackground = rgba(0, 0, 0, 0)
  ctx.style.menuButton.textNormal = rgb(95, 95, 95)
  ctx.style.menuButton.textHover = rgb(95, 95, 95)
  ctx.style.menuButton.textActive = rgb(95, 95, 95)

  ## tree
  ctx.style.tab.text = rgb(95, 95, 95)
  ctx.style.tab.tabMinimizeButton.normal = styleItemImage(media.tabMinimize)
  ctx.style.tab.tabMinimizeButton.hover = styleItemImage(media.tabMinimize)
  ctx.style.tab.tabMinimizeButton.active = styleItemImage(media.tabMinimize)
  ctx.style.tab.tabMinimizeButton.textBackground = rgba(0, 0, 0, 0)
  ctx.style.tab.tabMinimizeButton.textNormal = rgba(0, 0, 0, 0)
  ctx.style.tab.tabMinimizeButton.textHover = rgba(0, 0, 0, 0)
  ctx.style.tab.tabMinimizeButton.textActive = rgba(0, 0, 0, 0)
  ctx.style.tab.tabMaximizeButton.normal = styleItemImage(media.tabMaximize)
  ctx.style.tab.tabMaximizeButton.hover = styleItemImage(media.tabMaximize)
  ctx.style.tab.tabMaximizeButton.active = styleItemImage(media.tabMaximize)
  ctx.style.tab.tabMaximizeButton.textBackground = rgba(0, 0, 0, 0)
  ctx.style.tab.tabMaximizeButton.textNormal = rgba(0, 0, 0, 0)
  ctx.style.tab.tabMaximizeButton.textHover = rgba(0, 0, 0, 0)
  ctx.style.tab.tabMaximizeButton.textActive = rgba(0, 0, 0, 0)
  ctx.style.tab.nodeMinimizeButton.normal = styleItemImage(media.tabMinimize)
  ctx.style.tab.nodeMinimizeButton.hover = styleItemImage(media.tabMinimize)
  ctx.style.tab.nodeMinimizeButton.active = styleItemImage(media.tabMinimize)
  ctx.style.tab.nodeMinimizeButton.textBackground = rgba(0, 0, 0, 0)
  ctx.style.tab.nodeMinimizeButton.textNormal = rgba(0, 0, 0, 0)
  ctx.style.tab.nodeMinimizeButton.textHover = rgba(0, 0, 0, 0)
  ctx.style.tab.nodeMinimizeButton.textActive = rgba(0, 0, 0, 0)
  ctx.style.tab.nodeMaximizeButton.normal = styleItemImage(media.tabMaximize)
  ctx.style.tab.nodeMaximizeButton.hover = styleItemImage(media.tabMaximize)
  ctx.style.tab.nodeMaximizeButton.active = styleItemImage(media.tabMaximize)
  ctx.style.tab.nodeMaximizeButton.textBackground = rgba(0, 0, 0, 0)
  ctx.style.tab.nodeMaximizeButton.textNormal = rgba(0, 0, 0, 0)
  ctx.style.tab.nodeMaximizeButton.textHover = rgba(0, 0, 0, 0)
  ctx.style.tab.nodeMaximizeButton.textActive = rgba(0, 0, 0, 0)

  ## selectable
  ctx.style.selectable.normal = styleItemColor(rgb(206, 206, 206))
  ctx.style.selectable.hover = styleItemColor(rgb(206, 206, 206))
  ctx.style.selectable.pressed = styleItemColor(rgb(206, 206, 206))
  ctx.style.selectable.normalActive = styleItemColor(rgb(185, 205, 248))
  ctx.style.selectable.hoverActive = styleItemColor(rgb(185, 205, 248))
  ctx.style.selectable.pressedActive = styleItemColor(rgb(185, 205, 248))
  ctx.style.selectable.textNormal = rgb(95, 95, 95)
  ctx.style.selectable.textHover = rgb(95, 95, 95)
  ctx.style.selectable.textPressed = rgb(95, 95, 95)
  ctx.style.selectable.textNormalActive = rgb(95, 95, 95)
  ctx.style.selectable.textHoverActive = rgb(95, 95, 95)
  ctx.style.selectable.textPressedActive = rgb(95, 95, 95)

  ## slider
  ctx.style.slider.normal = styleItemHide()
  ctx.style.slider.hover = styleItemHide()
  ctx.style.slider.active = styleItemHide()
  ctx.style.slider.barNormal = rgb(156, 156, 156)
  ctx.style.slider.barHover = rgb(156, 156, 156)
  ctx.style.slider.barActive = rgb(156, 156, 156)
  ctx.style.slider.barFilled = rgb(156, 156, 156)
  ctx.style.slider.cursorNormal = styleItemImage(media.slider)
  ctx.style.slider.cursorHover = styleItemImage(media.sliderHover)
  ctx.style.slider.cursorActive = styleItemImage(media.sliderActive)
  ctx.style.slider.cursorSize = vec2(16.5, 21)
  ctx.style.slider.barHeight = 1

  ## progressbar
  ctx.style.progress.normal = styleItemColor(rgb(231, 231, 231))
  ctx.style.progress.hover = styleItemColor(rgb(231, 231, 231))
  ctx.style.progress.active = styleItemColor(rgb(231, 231, 231))
  ctx.style.progress.cursorNormal = styleItemColor(rgb(63, 242, 93))
  ctx.style.progress.cursorHover = styleItemColor(rgb(63, 242, 93))
  ctx.style.progress.cursorActive = styleItemColor(rgb(63, 242, 93))
  ctx.style.progress.borderColor = rgb(114, 116, 115)
  ctx.style.progress.padding = vec2(0, 0)
  ctx.style.progress.border = 2
  ctx.style.progress.rounding = 1

  ## combo
  ctx.style.combo.normal = styleItemColor(rgb(216, 216, 216))
  ctx.style.combo.hover = styleItemColor(rgb(216, 216, 216))
  ctx.style.combo.active = styleItemColor(rgb(216, 216, 216))
  ctx.style.combo.borderColor = rgb(95, 95, 95)
  ctx.style.combo.labelNormal = rgb(95, 95, 95)
  ctx.style.combo.labelHover = rgb(95, 95, 95)
  ctx.style.combo.labelActive = rgb(95, 95, 95)
  ctx.style.combo.border = 1
  ctx.style.combo.rounding = 1

  ## combo button
  ctx.style.combo.button.normal = styleItemColor(rgb(216, 216, 216))
  ctx.style.combo.button.hover = styleItemColor(rgb(216, 216, 216))
  ctx.style.combo.button.active = styleItemColor(rgb(216, 216, 216))
  ctx.style.combo.button.textBackground = rgb(216, 216, 216)
  ctx.style.combo.button.textNormal = rgb(95, 95, 95)
  ctx.style.combo.button.textHover = rgb(95, 95, 95)
  ctx.style.combo.button.textActive = rgb(95, 95, 95)

  ## property
  ctx.style.property.normal = styleItemColor(rgb(216, 216, 216))
  ctx.style.property.hover = styleItemColor(rgb(216, 216, 216))
  ctx.style.property.active = styleItemColor(rgb(216, 216, 216))
  ctx.style.property.borderColor = rgb(81, 81, 81)
  ctx.style.property.labelNormal = rgb(95, 95, 95)
  ctx.style.property.labelHover = rgb(95, 95, 95)
  ctx.style.property.labelActive = rgb(95, 95, 95)
  ctx.style.property.symLeft = SYMBOL_TRIANGLE_LEFT
  ctx.style.property.symRight = SYMBOL_TRIANGLE_RIGHT
  ctx.style.property.rounding = 10
  ctx.style.property.border = 1

  ## edit
  ctx.style.edit.normal = styleItemColor(rgb(240, 240, 240))
  ctx.style.edit.hover = styleItemColor(rgb(240, 240, 240))
  ctx.style.edit.active = styleItemColor(rgb(240, 240, 240))
  ctx.style.edit.borderColor = rgb(62, 62, 62)
  ctx.style.edit.cursorNormal = rgb(99, 202, 255)
  ctx.style.edit.cursorHover = rgb(99, 202, 255)
  ctx.style.edit.cursorTextNormal = rgb(95, 95, 95)
  ctx.style.edit.cursorTextHover = rgb(95, 95, 95)
  ctx.style.edit.textNormal = rgb(95, 95, 95)
  ctx.style.edit.textHover = rgb(95, 95, 95)
  ctx.style.edit.textActive = rgb(95, 95, 95)
  ctx.style.edit.selectedNormal = rgb(99, 202, 255)
  ctx.style.edit.selectedHover = rgb(99, 202, 255)
  ctx.style.edit.selectedTextNormal = rgb(95, 95, 95)
  ctx.style.edit.selectedTextHover = rgb(95, 95, 95)
  ctx.style.edit.border = 1
  ctx.style.edit.rounding = 2

  ## property buttons
  ctx.style.property.decButton.normal = styleItemColor(rgb(216, 216, 216))
  ctx.style.property.decButton.hover = styleItemColor(rgb(216, 216, 216))
  ctx.style.property.decButton.active = styleItemColor(rgb(216, 216, 216))
  ctx.style.property.decButton.textBackground = rgba(0, 0, 0, 0)
  ctx.style.property.decButton.textNormal = rgb(95, 95, 95)
  ctx.style.property.decButton.textHover = rgb(95, 95, 95)
  ctx.style.property.decButton.textActive = rgb(95, 95, 95)
  ctx.style.property.incButton = ctx.style.property.decButton

  ## property edit
  ctx.style.property.edit.normal = styleItemColor(rgb(216, 216, 216))
  ctx.style.property.edit.hover = styleItemColor(rgb(216, 216, 216))
  ctx.style.property.edit.active = styleItemColor(rgb(216, 216, 216))
  ctx.style.property.edit.borderColor = rgba(0, 0, 0, 0)
  ctx.style.property.edit.cursorNormal = rgb(95, 95, 95)
  ctx.style.property.edit.cursorHover = rgb(95, 95, 95)
  ctx.style.property.edit.cursorTextNormal = rgb(216, 216, 216)
  ctx.style.property.edit.cursorTextHover = rgb(216, 216, 216)
  ctx.style.property.edit.textNormal = rgb(95, 95, 95)
  ctx.style.property.edit.textHover = rgb(95, 95, 95)
  ctx.style.property.edit.textActive = rgb(95, 95, 95)
  ctx.style.property.edit.selectedNormal = rgb(95, 95, 95)
  ctx.style.property.edit.selectedHover = rgb(95, 95, 95)
  ctx.style.property.edit.selectedTextNormal = rgb(216, 216, 216)
  ctx.style.property.edit.selectedTextHover = rgb(216, 216, 216)

  ## chart
  ctx.style.chart.background = styleItemColor(rgb(216, 216, 216))
  ctx.style.chart.borderColor = rgb(81, 81, 81)
  ctx.style.chart.color = rgb(95, 95, 95)
  ctx.style.chart.selectedColor = rgb(255, 0, 0)
  ctx.style.chart.border = 1

  var
    slider: cint = 10
    fieldLen: cint
    progValue: csize = 60
    currentWeapon: cint = 0
    fieldBuffer: array[64, char]
    pos: cfloat
    weaponsStrings: array[5, string] = ["Fist", "Pistol", "Shotgun", "Plasma", "BFG"]
    weapons: cstringArray = allocCStringArray(weaponsStrings)

  while not win.shouldClose:
    ## High DPI displays
    var scale: Vec2

    (width, height) = win.size
    (displayWidth, displayHeight) = win.framebufSize
    scale.x = displayWidth / width
    scale.y = displayHeight / height

    ## Input
    var
      x: float
      y: float

    inputBegin(addr(ctx))
    glfw.pollEvents()

    inputKey(addr(ctx), KEY_DEL, glfw.isKeyDown(win, keyDelete).cint)
    inputKey(addr(ctx), KEY_ENTER, glfw.isKeyDown(win, keyEnter).cint)
    inputKey(addr(ctx), KEY_TAB, glfw.isKeyDown(win, keyTab).cint)
    inputKey(addr(ctx), KEY_BACKSPACE, glfw.isKeyDown(win, keyBackspace).cint)
    inputKey(addr(ctx), KEY_LEFT, glfw.isKeyDown(win, keyLeft).cint)
    inputKey(addr(ctx), KEY_RIGHT, glfw.isKeyDown(win, keyRight).cint)
    inputKey(addr(ctx), KEY_UP, glfw.isKeyDown(win, keyUp).cint)
    inputKey(addr(ctx), KEY_DOWN, glfw.isKeyDown(win, keyDown).cint)

    if glfw.isKeyDown(win, keyLeftControl) or glfw.isKeyDown(win, keyRightControl):
      inputKey(addr(ctx), KEY_COPY, glfw.isKeyDown(win, keyC).cint)
      inputKey(addr(ctx), KEY_PASTE, glfw.isKeyDown(win, keyP).cint)
      inputKey(addr(ctx), KEY_CUT, glfw.isKeyDown(win, keyX).cint)
      inputKey(addr(ctx), KEY_CUT, glfw.isKeyDown(win, keyE).cint)
      inputKey(addr(ctx), KEY_SHIFT, 1)

    else:
      inputKey(addr(ctx), KEY_COPY, 0)
      inputKey(addr(ctx), KEY_PASTE, 0)
      inputKey(addr(ctx), KEY_CUT, 0)
      inputKey(addr(ctx), KEY_SHIFT, 0)

    (x, y) = win.cursorPos

    inputMotion(addr(ctx), cint(x), cint(y))
    inputButton(addr(ctx), BUTTON_LEFT, cint(x), cint(y), win.mouseBtnDown(mbLeft).cint)
    inputButton(addr(ctx), BUTTON_MIDDLE, cint(x), cint(y), win.mouseBtnDown(mbMiddle).cint)
    inputButton(addr(ctx), BUTTON_RIGHT, cint(x), cint(y), win.mouseBtnDown(mbRight).cint)

    inputEnd(addr(ctx))

    ## GUI
    var
      layout: Panel
      tab: Panel

    begin(addr(ctx), layout, "Demo", rect(50, 50, 300, 400), WINDOW_BORDER or WINDOW_MOVABLE or WINDOW_TITLE):
      var id: float

      const step: float = (2 * math.PI) / 32

      layoutRowStatic(addr(ctx), 30, 120, 1)
      if buttonLabel(addr(ctx), "button") != 0: stdout.write("button pressed\n")

      layoutRowDynamic(addr(ctx), 20, 1)
      label(addr(ctx), "Label", Flags(TEXT_LEFT))

      layoutRowDynamic(addr(ctx), 30, 2)
      discard checkLabel(addr(ctx), "inactive", 0)
      discard checkLabel(addr(ctx), "active", 1)
      discard optionLabel(addr(ctx), "active", 1)
      discard optionLabel(addr(ctx), "inactive", 0)

      layoutRowDynamic(addr(ctx), 30, 1)
      discard sliderInt(addr(ctx), 0, addr(slider), 16, 1)

      layoutRowDynamic(addr(ctx), 20, 1)
      discard progress(addr(ctx), addr(progValue), 100, MODIFIABLE.cint)

      layoutRowDynamic(addr(ctx), 25, 1)
      discard editString(addr(ctx), Flags(EDIT_FIELD), fieldBuffer, addr(fieldLen), 64, filterDefault)
      propertyFloat(addr(ctx), "#X:", - 1024.0, addr(pos), 1024.0, 1, 1)
      currentWeapon = combo(addr(ctx), weapons, len(weaponsStrings).cint, currentWeapon, 25, 200)

      layoutRowDynamic(addr(ctx), 100, 1)
      if chartBeginColored(addr(ctx), CHART_LINES, rgb(255, 0, 0), rgb(150, 0, 0), 32, 0.0, 1.0) != 0:
        chartAddSlotColored(addr(ctx), CHART_LINES, rgb(0, 0, 255), rgb(0, 0, 150), 32, - 1.0, 1.0)
        chartAddSlotColored(addr(ctx), CHART_LINES, rgb(0, 255, 0), rgb(0, 150, 0), 32, - 1.0, 1.0)

        id = 0
        for i in 0..31:
          discard chartPushSlot(addr(ctx), cfloat(abs(sin(id))), 0)
          discard chartPushSlot(addr(ctx), cfloat(cos(id)), 1)
          discard chartPushSlot(addr(ctx), cfloat(sin(id)), 2)
          id += step

      chartEnd(addr(ctx))

      layoutRowDynamic(addr(ctx), 250, 1)
      if groupBegin(addr(ctx), addr(tab), "Standard", WINDOW_BORDER or WINDOW_BORDER) != 0:
        if treePush(addr(ctx), TREE_NODE, "Window", MAXIMIZED) != 0:
          var selected: array[8, cint]

          if treePush(addr(ctx), TREE_NODE, "Next", MAXIMIZED) != 0:
            layoutRowDynamic(addr(ctx), 20, 1)

            for i in 0..3:
              discard selectableLabel(addr(ctx),
                              if selected[i] != 0: "Selected" else: "Unselected",
                              Flags(TEXT_LEFT), addr(selected[i]))

            treePop(addr(ctx))

          if treePush(addr(ctx), TREE_NODE, "Previous", MAXIMIZED) != 0:
            layoutRowDynamic(addr(ctx), 20, 1)

            for i in 4..7:
              discard selectableLabel(addr(ctx),
                              if selected[i] != 0: "Selected" else: "Unselected",
                              Flags(TEXT_LEFT), addr(selected[i]))

            treePop(addr(ctx))

          treePop(addr(ctx))

        groupEnd(addr(ctx))

    ## Draw
    glViewport(0, 0, GLsizei(displayWidth), GLsizei(displayHeight))
    glClear(GL_COLOR_BUFFER_BIT)
    glClearColor(0.5881999999999999, 0.6666, 0.6666, 1.0)
    device.draw(addr(ctx), width.cint, height.cint, scale, ANTI_ALIASING_ON)
    glfw.swapBufs(win)

  deallocCStringArray(weapons)
  glDeleteTextures(1, cast[ptr GLuint](addr(media.skin)))
  clear(addr(atlas))
  free(addr(ctx))
  device.shutdown()
  glfw.terminate()
  # return 0
