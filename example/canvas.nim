## nuklear - v1.05 - public domain

import
  stb_image as stbi,
  glfw,
  opengl,
  math,
  os,
  unicode

import
  nuklear,
  nuklear.draw_list,
  nuklear.input,
  nuklear.layout,
  nuklear.window,
  nuklear.widget
  # ../nuklear,
  # ../nuklear/draw_list,
  # ../nuklear/input,
  # ../nuklear/layout,
  # ../nuklear/window,
  # ../nuklear/widget

const
  WINDOW_WIDTH = 1200
  WINDOW_HEIGHT = 800
  MAX_VERTEX_MEMORY = 512 * 1024
  MAX_ELEMENT_MEMORY = 128 * 1024

const
  SHADER_VERSION = "#version 150\n"

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


# proc die*(fmt: cstring) {.varargs.} =
#   var ap: VaList
#   vaStart(ap, fmt)
#   vfprintf(stderr, fmt, ap)
#   vaEnd(ap)
#   fputs("\x0A", stderr)
#   exit(exit_Failure)

proc iconLoad(filename: string): Image =
  var
    x: int
    y: int
    n: int
  var tex: GLuint
  var data: seq[uint8] = stbi.load(filename, x, y, n, 0)

  if data == nil:
    # die("[SDL]: failed to load image: %s", filename)
    quit -1

  glGenTextures(1, addr(tex))
  glBindTexture(GL_TEXTURE_2D, tex)
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GLfloat(GL_LINEAR_MIPMAP_NEAREST))
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GLfloat(GL_LINEAR_MIPMAP_NEAREST))
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GLfloat(GL_CLAMP_TO_EDGE))
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GLfloat(GL_CLAMP_TO_EDGE))
  glTexImage2D(GL_TEXTURE_2D, 0, GLint(GL_RGBA8), GLsizei(x), GLsizei(y), 0, GL_RGBA, GL_UNSIGNED_BYTE, cast[pointer](data))
  glGenerateMipmap(GL_TEXTURE_2D)
  # stbi.imageFree(data)
  return imageId(cast[cint](tex))

proc deviceInit(dev: ptr Device) =
  var status: GLint
  var
    vertShader: array[12, string] = [
      SHADER_VERSION,
      "uniform mat4 ProjMtx;\n",
      "in vec2 Position;\n",
      "in vec2 TexCoord;\n",
      "in vec4 Color;\n",
      "out vec2 Frag_UV;\n",
      "out vec4 Frag_Color;\n",
      "void main() {\n",
      "   Frag_UV = TexCoord;\n",
      "   Frag_Color = Color;\n",
      "   gl_Position = ProjMtx * vec4(Position.xy, 0, 1);\n",
      "}\n",
    ]
    vertexShader: cstringArray = allocCStringArray(vertShader)
    fragShader: array[9, string] = [
      SHADER_VERSION,
      "precision mediump float;\n",
      "uniform sampler2D Texture;\n",
      "in vec2 Frag_UV;\n",
      "in vec4 Frag_Color;\n",
      "out vec4 Out_Color;\n",
      "void main(){\n",
      "   Out_Color = Frag_Color * texture(Texture, Frag_UV.st);\n",
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
  assert(GLboolean(status) == GL_TRUE)

  glGetShaderiv(dev.fragShdr, GL_COMPILE_STATUS, addr(status))
  assert(GLboolean(status) == GL_TRUE)

  glAttachShader(dev.prog, dev.vertShdr)
  glAttachShader(dev.prog, dev.fragShdr)

  glLinkProgram(dev.prog)
  glGetProgramiv(dev.prog, GL_LINK_STATUS, addr(status))
  assert(GLboolean(status) == GL_TRUE)

  deallocCStringArray(vertexShader)
  deallocCStringArray(fragmentShader)

  dev.uniformTex = glGetUniformLocation(dev.prog, "Texture")
  dev.uniformProj = glGetUniformLocation(dev.prog, "ProjMtx")
  dev.attribPos = glGetAttribLocation(dev.prog, "Position")
  dev.attribUv = glGetAttribLocation(dev.prog, "TexCoord")
  dev.attribCol = glGetAttribLocation(dev.prog, "Color")

  ## buffer setup
  var vs: GLsizei = GLsizei(sizeof(GlfwVertex))
  var vp: csize = offsetof(GlfwVertex, position)
  var vt: csize = offsetof(GlfwVertex, uv)
  var vc: csize = offsetof(GlfwVertex, col)

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

proc uploadAtlas(dev: var Device; image: pointer; width: int; height: int) =
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

proc draw(dev: var Device; ctx: ptr Context; width: int; height: int; aa: AntiAliasing) =
  var ortho: array[4, array[4, GLfloat]] = [
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
  var vertexLayout {.global.}: array[4, DrawVertexLayoutElement] = [
      initDrawVertexLayoutElement(nkVertexPosition, FORMAT_FLOAT, offsetof(GlfwVertex, position)),
      initDrawVertexLayoutElement(nkVertexTexcoord, FORMAT_FLOAT, offsetof(GlfwVertex, uv)),
      initDrawVertexLayoutElement(nkVertexColor, FORMAT_R8G8B8A8, offsetof(GlfwVertex, col)),
      VERTEX_LAYOUT_END
    ]

  # memset(addr(config), 0, sizeof((config)))
  config.vertexLayout = vertexLayout[0].addr
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
  draw_list.convert(ctx, addr(dev.cmds), addr(vbuf), addr(ebuf), addr(config))
  # ctx.convert(addr(dev.cmds), addr(vbuf), addr(ebuf), addr(config))
  discard glUnmapBuffer(GL_ARRAY_BUFFER)
  discard glUnmapBuffer(GL_ELEMENT_ARRAY_BUFFER)

  ## iterate over and execute each draw command
  for cmd in ctx.drawCommands(addr(dev.cmds)):
    if cmd.elemCount == 0: continue
    glBindTexture(GL_TEXTURE_2D, GLuint(cmd.texture.id))
    glScissor(GLint(cmd.clipRect.x),
              GLint((height - GLint(cmd.clipRect.y + cmd.clipRect.h))),
              GLint(cmd.clipRect.w),
              GLint(cmd.clipRect.h))
    glDrawElements(GL_TRIANGLES, GLsizei(cmd.elemCount), GL_UNSIGNED_SHORT, offset)
    offset = nuklear.offset(offset, cmd.elemCount.int)

  ctx.clear()

  ## default OpenGL state
  glUseProgram(0)
  glBindBuffer(GL_ARRAY_BUFFER, 0)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
  glBindVertexArray(0)
  glDisable(GL_BLEND)
  glDisable(GL_SCISSOR_TEST)

## glfw callbacks (I don't know if there is a easier way to access text and scroll )

proc pumpInput(ctx: ptr Context; win: Win) =
  var
    x: float
    y: float

  input.begin(ctx)
  # inputBegin(ctx)
  glfw.pollEvents()

  input.key(ctx, KEY_DEL, win.isKeyDown(keyDelete).cint)
  input.key(ctx, KEY_ENTER, win.isKeyDown(keyEnter).cint)
  input.key(ctx, KEY_TAB, win.isKeyDown(keyTab).cint)
  input.key(ctx, KEY_BACKSPACE, win.isKeyDown(keyBackspace).cint)
  input.key(ctx, KEY_LEFT, win.isKeyDown(keyLeft).cint)
  input.key(ctx, KEY_RIGHT, win.isKeyDown(keyRight).cint)
  input.key(ctx, KEY_UP, win.isKeyDown(keyUp).cint)
  input.key(ctx, KEY_DOWN, win.isKeyDown(keyDown).cint)

  if win.isKeyDown(keyLeftControl) or win.isKeyDown(keyRightControl):
    input.key(ctx, KEY_COPY, win.isKeyDown(keyC).cint)
    input.key(ctx, KEY_PASTE, win.isKeyDown(keyP).cint)
    input.key(ctx, KEY_CUT, win.isKeyDown(keyX).cint)
    input.key(ctx, KEY_CUT, win.isKeyDown(keyE).cint)
    input.key(ctx, KEY_SHIFT, 1)

  else:
    input.key(ctx, KEY_COPY, 0)
    input.key(ctx, KEY_PASTE, 0)
    input.key(ctx, KEY_CUT, 0)
    input.key(ctx, KEY_SHIFT, 0)

  (x, y) = win.cursorPos

  input.motion(ctx, cint(x), cint(y))

  input.button(ctx, BUTTON_LEFT, cint(x), cint(y), win.mouseBtnDown(mbLeft).cint)
  input.button(ctx, BUTTON_MIDDLE, cint(x), cint(y), win.mouseBtnDown(mbMiddle).cint)
  input.button(ctx, BUTTON_RIGHT, cint(x), cint(y), win.mouseBtnDown(mbRight).cint)

  input.`end`(ctx)

type
  Canvas = object
    layout: Panel
    painter: ptr CommandBuffer
    itemSpacing: Vec2
    panelPadding: Vec2
    windowBackground: StyleItem


proc canvasBegin(ctx: ptr Context; canvas: ptr Canvas; flags: Flags; x: int; y: int; width: int; height: int; backgroundColor: Color) =
  ## save style properties which will be overwritten
  canvas.panelPadding = ctx.style.window.padding
  canvas.itemSpacing = ctx.style.window.spacing
  canvas.windowBackground = ctx.style.window.fixedBackground

  ## use the complete window space and set background
  ctx.style.window.spacing = vec2(0, 0)
  ctx.style.window.padding = vec2(0, 0)
  ctx.style.window.fixedBackground = styleItemColor(backgroundColor)

  ## create/update window and set position + size
  let newFlags = flags # and not WINDOW_DYNAMIC

  discard begin(ctx, addr(canvas.layout), "Window", rect(x.float, y.float, width.float, height.float), WINDOW_NO_SCROLLBAR or newFlags)
  window.setBounds(ctx, rect(x.float, y.float, width.float, height.float))
  # windowSetBounds(ctx, rect(x.float, y.float, width.float, height.float))

  ## allocate the complete window space for drawing
  var totalSpace: Rect = window.getContentRegion(ctx)
  # var totalSpace: Rect = getWindowContentRegion(ctx)

  layout.rowDynamic(ctx, totalSpace.h, 1)
  # layoutRowDynamic(ctx, totalSpace.h, 1)
  discard widget(addr(totalSpace), ctx)
  canvas.painter = window.getCanvas(ctx)
  # canvas.painter = getWindowCanvas(ctx)

proc canvasEnd(ctx: ptr Context; canvas: ptr Canvas) =
  window.`end`(ctx)
  # `end`(ctx)
  ctx.style.window.spacing = canvas.panelPadding
  ctx.style.window.padding = canvas.itemSpacing
  ctx.style.window.fixedBackground = canvas.windowBackground

when isMainModule:
  ## Platform
  var win: Win
  var
    width: int = 0
    height: int = 0

  ## GUI
  var device: Device
  var atlas: FontAtlas
  var ctx: Context

  var textInput = proc(win: Win; codepoint: unicode.Rune) =
    input.unicode(addr(ctx), nuklear.Rune(codepoint))
    # inputUnicode(addr(ctx), nuklear.Rune(codepoint))

  var scrollInput = proc(win: Win; offset: tuple[x: float; y: float]) =
    input.scroll(addr(ctx), offset.y)
    # inputScroll(addr(ctx), offset.y)

  ## GLFW
  glfw.init()

  win = glfw.newGlWin((WINDOW_WIDTH, WINDOW_HEIGHT), "Demo", version = glv33, profile = glpCore)
  opengl.loadExtensions()

  glfw.makeContextCurrent(win)

  win.charCb = textInput
  win.scrollCb = scrollInput
  (width, height) = win.size

  ## OpenGL
  glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  deviceInit(addr(device))

  var image: pointer
  var
    w: cint
    h: cint
  var font: ptr Font

  initDefault(addr(atlas))
  begin(addr(atlas))
  font = addDefault(addr(atlas), 13)
  image = atlas.bake(w, h, FONT_ATLAS_RGBA32)
  device.uploadAtlas(image, w, h)
  `end`(addr(atlas), handleId(cint(device.fontTex)), addr(device.null))
  discard initDefault(addr(ctx), addr(font.handle))

  # glEnable(GL_TEXTURE_2D)

  while not win.shouldClose:
    ## input
    pumpInput(addr(ctx), win)

    ## draw
    var canvas: Canvas

    canvasBegin(addr(ctx), addr(canvas), 0, 0, 0, width, height, rgb(250, 250, 250))
    fillRect(canvas.painter, rect(15, 15, 210, 210), 5, rgb(247, 230, 154))
    fillRect(canvas.painter, rect(20, 20, 200, 200), 5, rgb(188, 174, 118))
    drawText(canvas.painter, rect(30, 30, 150, 20), "Text to draw", 12, addr(font.handle), rgb(188, 174, 118), rgb(0, 0, 0))
    fillRect(canvas.painter, rect(250, 20, 100, 100), 0, rgb(0, 0, 255))
    fillCircle(canvas.painter, rect(20, 250, 100, 100), rgb(255, 0, 0))
    fillTriangle(canvas.painter, 250, 250, 350, 250, 300, 350, rgb(0, 255, 0))
    fillArc(canvas.painter, 300, 180, 50, 0, math.PI * 3.0 / 4.0, rgb(255, 255, 0))

    var points: array[12, cfloat]
    points[0] = 200
    points[1] = 250
    points[2] = 250
    points[3] = 350
    points[4] = 225
    points[5] = 350
    points[6] = 200
    points[7] = 300
    points[8] = 175
    points[9] = 350
    points[10] = 150
    points[11] = 350

    fillPolygon(canvas.painter, points[0].addr, 6, rgb(0, 0, 0))
    strokeLine(canvas.painter, 15, 10, 200, 10, 2.0, rgb(189, 45, 75))
    strokeRect(canvas.painter, rect(370, 20, 100, 100), 10, 3, rgb(0, 0, 255))
    strokeCurve(canvas.painter, 380, 200, 405, 270, 455, 120, 480, 200, 2, rgb(0, 150, 220))
    strokeCircle(canvas.painter, rect(20, 370, 100, 100), 5, rgb(0, 255, 120))
    strokeTriangle(canvas.painter, 370, 250, 470, 250, 420, 350, 6, rgb(255, 0, 143))
    canvasEnd(addr(ctx), addr(canvas))

    ## Draw
    (width, height) = win.size
    glViewport(0, 0, GLsizei(width), GLsizei(height))
    glClear(GL_COLOR_BUFFER_BIT)
    glClearColor(0.2, 0.2, 0.2, 1.0)
    device.draw(addr(ctx), width, height, ANTI_ALIASING_ON)
    glfw.swapBufs(win)

  clear(addr(atlas))
  free(addr(ctx))
  device.shutdown()
  glfw.terminate()
