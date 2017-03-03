## nuklear - v1.05 - public domain

import
  stb_image as stbi,
  opengl,
  math,
  glfw,
  unicode,
  ../nuklear

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
    font14: ptr Font
    font18: ptr Font
    font20: ptr Font
    font22: ptr Font
    unchecked: Image
    checked: Image
    rocket: Image
    cloud: Image
    pen: Image
    play: Image
    pause: Image
    stop: Image
    prev: Image
    next: Image
    tools: Image
    dir: Image
    copy: Image
    convert: Image
    del: Image
    edit: Image
    images: array[9, Image]
    menu: array[6, Image]


## ===============================================================
##
##                           CUSTOM WIDGET
##
## ===============================================================

proc uiPiemenu*(ctx: ptr Context; pos: Vec2; radius: float; icons: ptr Image; itemCount: int): int =
  var
    ret: int = - 1
    totalSpace: Rect
    popup: Panel
    bounds: Rect
    activeItem: int = 0

  ## pie menu popup
  let
    border: Color = ctx.style.window.borderColor
    background: StyleItem = ctx.style.window.fixedBackground

  ctx.style.window.fixedBackground = styleItemHide()
  ctx.style.window.borderColor = rgba(0, 0, 0, 0)
  totalSpace = getWindowContentRegion(ctx)
  ctx.style.window.spacing = vec2(0, 0)
  ctx.style.window.padding = vec2(0, 0)

  let popupBounds = rect(pos.x - totalSpace.x - radius, pos.y - radius - totalSpace.y, 2 * radius, 2 * radius)

  if popupBegin(ctx, addr(popup), POPUP_STATIC, "piemenu", Flags(WINDOW_NO_SCROLLBAR), popupBounds) != 0:
    let
      output: ptr CommandBuffer = getWindowCanvas(ctx)
      input: ptr Input = addr(ctx.input)

    totalSpace = getWindowContentRegion(ctx)
    ctx.style.window.spacing = vec2(4, 4)
    ctx.style.window.padding = vec2(8, 8)
    layoutRowDynamic(ctx, totalSpace.h, 1)
    discard widget(addr(bounds), ctx)

    ## outer circle
    fillCircle(output, bounds, rgb(50, 50, 50))

    ## circle buttons
    let
      step: float = (2 * math.PI) / float(max(1, itemCount))
      center: Vec2 = vec2(bounds.x + bounds.w / 2.0, bounds.y + bounds.h / 2.0)
      drag: Vec2 = vec2(input.mouse.pos.x - center.x, input.mouse.pos.y - center.y)

    var
      aMin: float = 0
      aMax: float = step
      angle: float = arctan2(drag.y, drag.x)

    if angle < - 0.0: angle += 2.0 * math.PI
    activeItem = int(angle / step)

    for i in 0..itemCount - 1:
      var
        content: Rect
        rx: float
        ry: float
        dx: float
        dy: float
        a: float

      fillArc(output, center.x, center.y, (bounds.w / 2.0), aMin, aMax,
              if (activeItem == i): rgb(45, 100, 255) else: rgb(60, 60, 60))

      ## separator line
      rx = bounds.w / 2.0
      ry = 0
      dx = rx * cos(aMin) - ry * sin(aMin)
      dy = rx * sin(aMin) + ry * cos(aMin)
      strokeLine(output, center.x, center.y, center.x + dx, center.y + dy, 1.0, rgb(50, 50, 50))

      ## button content
      a = aMin + (aMax - aMin) / 2.0
      rx = bounds.w / 2.5
      ry = 0
      content.w = 30
      content.h = 30
      content.x = center.x + ((rx * cos(a) - ry * sin(a)) - content.w / 2.0)
      content.y = center.y + (rx * sin(a) + ry * cos(a) - content.h / 2.0)
      drawImage(output, content, addr(icons[i]), rgb(255, 255, 255))
      aMin = aMax
      aMax += step

    ## inner circle
    var inner: Rect

    inner.x = bounds.x + bounds.w / 2 - bounds.w / 4
    inner.y = bounds.y + bounds.h / 2 - bounds.h / 4
    inner.w = bounds.w / 2
    inner.h = bounds.h / 2
    fillCircle(output, inner, rgb(45, 45, 45))

    ## active icon content
    bounds.w = inner.w / 2.0
    bounds.h = inner.h / 2.0
    bounds.x = inner.x + inner.w / 2 - bounds.w / 2
    bounds.y = inner.y + inner.h / 2 - bounds.h / 2
    drawImage(output, bounds, addr(icons[activeItem]), rgb(255, 255, 255))
    layoutSpaceEnd(ctx)

    if isMouseDown(addr(ctx.input), BUTTON_RIGHT) == 0:
      popupClose(ctx)
      ret = activeItem

  else:
    ret = - 2

  ctx.style.window.spacing = vec2(4, 4)
  ctx.style.window.padding = vec2(8, 8)
  popupEnd(ctx)
  ctx.style.window.fixedBackground = background
  ctx.style.window.borderColor = border
  return ret

## ===============================================================
##
##                           GRID
##
## ===============================================================

proc gridDemo*(ctx: ptr Context; media: ptr Media) =
  var
    text {.global.}: array[3, array[64, char]]
    textLen {.global.}: array[3, cint]
    selectedItem {.global.}: int = 0
    check {.global.}: cint = 1
    layout {.global.}: Panel
    combo {.global.}: Panel

  let
    items {.global.}: array[3, string] = ["Item 0", "Item 1", "Item 2"]

  styleSetFont(ctx, addr(media.font20.handle))

  begin(ctx, layout, "Grid Demo", rect(600, 350, 275, 250), WINDOW_TITLE or
      WINDOW_BORDER or WINDOW_MOVABLE or WINDOW_NO_SCROLLBAR):
    styleSetFont(ctx, addr(media.font18.handle))
    layoutRowDynamic(ctx, 30, 2)
    label(ctx, "Floating point:", Flags(TEXT_RIGHT))
    discard editString(ctx, Flags(EDIT_FIELD), text[0], addr(textLen[0]), 64, filterFloat)
    label(ctx, "Hexadecimal:", Flags(TEXT_RIGHT))
    discard editString(ctx, Flags(EDIT_FIELD), text[1], addr(textLen[1]), 64, filterHex)
    label(ctx, "Binary:", Flags(TEXT_RIGHT))
    discard editString(ctx, Flags(EDIT_FIELD), text[2], addr(textLen[2]), 64, filterBinary)
    label(ctx, "Checkbox:", Flags(TEXT_RIGHT))
    discard checkboxLabel(ctx, "Check me", addr(check))
    label(ctx, "Combobox:", Flags(TEXT_RIGHT))

    if comboBeginLabel(ctx, addr(combo), items[selectedItem], 200) != 0:
      layoutRowDynamic(ctx, 25, 1)

      for i, item in items:
        if comboItemLabel(ctx, item, Flags(TEXT_LEFT)) != 0: selectedItem = i

      comboEnd(ctx)

  styleSetFont(ctx, addr(media.font14.handle))

## ===============================================================
##
##                           BUTTON DEMO
##
## ===============================================================

proc uiHeader(ctx: ptr Context; media: ptr Media; title: string) =
  styleSetFont(ctx, addr(media.font18.handle))
  layoutRowDynamic(ctx, 20, 1)
  label(ctx, title, Flags(TEXT_LEFT))

proc uiWidget(ctx: ptr Context; media: ptr Media; height: float) =
  var ratio: array[2, cfloat] = [0.15.cfloat, 0.85]
  styleSetFont(ctx, addr(media.font22.handle))
  layoutRow(ctx, DYNAMIC, height, 2, ratio[0].addr)
  spacing(ctx, 1)

proc uiWidgetCentered(ctx: ptr Context; media: ptr Media; height: float) =
  var ratio: array[3, cfloat] = [0.15.cfloat, 0.5, 0.35]
  styleSetFont(ctx, addr(media.font22.handle))
  layoutRow(ctx, DYNAMIC, height, 3, ratio[0].addr)
  spacing(ctx, 1)

proc buttonDemo(ctx: ptr Context; media: ptr Media) =
  var
    layout {.global.}: Panel
    menu {.global.}: Panel
    option {.global.}: int = 1
    toggle0 {.global.}: bool = true
    toggle1 {.global.}: bool = false
    toggle2 {.global.}: bool = true

  styleSetFont(ctx, addr(media.font20.handle))
  discard begin(ctx, addr(layout), "Button Demo", rect(50, 50, 255, 610), WINDOW_BORDER or WINDOW_MOVABLE or WINDOW_TITLE)

  ## ------------------------------------------------
  ##                       MENU
  ## ------------------------------------------------

  menubarBegin(ctx)

  ## toolbar
  layoutRowStatic(ctx, 40, 40, 4)
  if menuBeginImage(ctx, addr(menu), "Music", media.play, 120) != 0:
    ## settings
    layoutRowDynamic(ctx, 25, 1)
    discard menuItemImageLabel(ctx, media.play, "Play", Flags(TEXT_RIGHT))
    discard menuItemImageLabel(ctx, media.stop, "Stop", Flags(TEXT_RIGHT))
    discard menuItemImageLabel(ctx, media.pause, "Pause", Flags(TEXT_RIGHT))
    discard menuItemImageLabel(ctx, media.next, "Next", Flags(TEXT_RIGHT))
    discard menuItemImageLabel(ctx, media.prev, "Prev", Flags(TEXT_RIGHT))
    menuEnd(ctx)

  discard buttonImage(ctx, media.tools)
  discard buttonImage(ctx, media.cloud)
  discard buttonImage(ctx, media.pen)
  menubarEnd(ctx)

  ## ------------------------------------------------
  ##                       BUTTON
  ## ------------------------------------------------

  uiHeader(ctx, media, "Push buttons")
  uiWidget(ctx, media, 35)

  if buttonLabel(ctx, "Push me") != 0:
    stdout.write("Pushed!\n")

  uiWidget(ctx, media, 35.0)

  if buttonImageLabel(ctx, media.rocket, "Styled", Flags(TEXT_CENTERED)) != 0:
    stdout.write("Rocket!\n")

  uiHeader(ctx, media, "Repeater")
  uiWidget(ctx, media, 35)

  if buttonLabel(ctx, "Press me") != 0:
    stdout.write("Pressed!\n")

  uiHeader(ctx, media, "Toggle buttons")
  uiWidget(ctx, media, 35)

  if buttonImageLabel(ctx, if toggle0: media.checked else: media.unchecked, "Toggle", Flags(TEXT_LEFT)) != 0:
    toggle0 = not toggle0

  uiWidget(ctx, media, 35)

  if buttonImageLabel(ctx, if toggle1: media.checked else: media.unchecked, "Toggle", Flags(TEXT_LEFT)) != 0:
    toggle1 = not toggle1

  uiWidget(ctx, media, 35)

  if buttonImageLabel(ctx, if toggle2: media.checked else: media.unchecked, "Toggle", Flags(TEXT_LEFT)) != 0:
    toggle2 = not toggle2

  uiHeader(ctx, media, "Radio buttons")
  uiWidget(ctx, media, 35)

  if buttonSymbolLabel(ctx, if option == 0: SYMBOL_CIRCLE_OUTLINE else: SYMBOL_CIRCLE_SOLID, "Select", Flags(TEXT_LEFT)) != 0:
    option = 0

  uiWidget(ctx, media, 35)

  if buttonSymbolLabel(ctx, if option == 1: SYMBOL_CIRCLE_OUTLINE else: SYMBOL_CIRCLE_SOLID, "Select", Flags(TEXT_LEFT)) != 0:
    option = 1

  uiWidget(ctx, media, 35)

  if buttonSymbolLabel(ctx, if option == 2: SYMBOL_CIRCLE_OUTLINE else: SYMBOL_CIRCLE_SOLID, "Select", Flags(TEXT_LEFT)) != 0:
    option = 2

  styleSetFont(ctx, addr(media.font18.handle))

  if contextualBegin(ctx, addr(menu), Flags(WINDOW_NO_SCROLLBAR), vec2(150, 300), getWindowBounds(ctx)) != 0:
    layoutRowDynamic(ctx, 30, 1)
    if contextualItemImageLabel(ctx, media.copy, "Clone", Flags(TEXT_RIGHT)) != 0:
      stdout.write("pressed clone!\n")

    if contextualItemImageLabel(ctx, media.del, "Delete", Flags(TEXT_RIGHT)) != 0:
      stdout.write("pressed delete!\n")

    if contextualItemImageLabel(ctx, media.convert, "Convert", Flags(TEXT_RIGHT)) != 0:
      stdout.write("pressed convert!\n")

    if contextualItemImageLabel(ctx, media.edit, "Edit", Flags(TEXT_RIGHT)) != 0:
      stdout.write("pressed edit!\n")

    contextualEnd(ctx)

  styleSetFont(ctx, addr(media.font14.handle))
  `end`(ctx)

## ===============================================================
##
##                           BASIC DEMO
##
## ===============================================================

proc basicDemo*(ctx: ptr Context; media: ptr Media) =
  var
    imageActive {.global.}: bool = false
    check0 {.global.}: cint = 1
    check1 {.global.}: cint = 0
    prog {.global.}: csize = 80
    selectedItem {.global.}: int = 0
    selectedImage {.global.}: int = 3
    selectedIcon {.global.}: int = 0
    piemenuActive {.global.}: bool = false
    piemenuPos {.global.}: Vec2
    layout {.global.}: Panel
    combo {.global.}: Panel

  let
    items {.global.}: array[3, string] = ["Item 0", "item 1", "item 2"]

  styleSetFont(ctx, addr(media.font20.handle))
  discard begin(ctx, addr(layout), "Basic Demo", rect(320, 50, 275, 610), WINDOW_BORDER or WINDOW_MOVABLE or WINDOW_TITLE)

  ## ------------------------------------------------
  ##                       POPUP BUTTON
  ## ------------------------------------------------

  uiHeader(ctx, media, "Popup & Scrollbar & Images")
  uiWidget(ctx, media, 35)
  if buttonImageLabel(ctx, media.dir, "Images", Flags(TEXT_CENTERED)) != 0:
    imageActive = not imageActive

  uiHeader(ctx, media, "Selected Image")
  uiWidgetCentered(ctx, media, 100)
  image(ctx, media.images[selectedImage])

  ## ------------------------------------------------
  ##                       IMAGE POPUP
  ## ------------------------------------------------

  if imageActive:
    var popup {.global.}: Panel
    if popupBegin(ctx, addr(popup), POPUP_STATIC, "Image Popup", 0, rect(265, 0, 320, 220)) != 0:
      layoutRowStatic(ctx, 82, 82, 3)

      for i, image in media.images:
        if buttonImage(ctx, image) != 0:
          selectedImage = i
          imageActive = false
          popupClose(ctx)

      popupEnd(ctx)

  uiHeader(ctx, media, "Combo box")
  uiWidget(ctx, media, 40)
  if comboBeginLabel(ctx, addr(combo), items[selectedItem], 200) != 0:
    layoutRowDynamic(ctx, 35, 1)

    for i, item in items:
      if comboItemLabel(ctx, item, Flags(TEXT_LEFT)) != 0: selectedItem = i

    comboEnd(ctx)

  uiWidget(ctx, media, 40)
  if comboBeginImageLabel(ctx, addr(combo), items[selectedIcon], media.images[selectedIcon], 200) != 0:
    layoutRowDynamic(ctx, 35, 1)

    for i, item in items:
      if comboItemImageLabel(ctx, media.images[i], item, Flags(TEXT_RIGHT)) != 0:
        selectedIcon = i

    comboEnd(ctx)

  uiHeader(ctx, media, "Checkbox")
  uiWidget(ctx, media, 30)
  discard checkboxLabel(ctx, "Flag 1", addr(check0))
  uiWidget(ctx, media, 30)
  discard checkboxLabel(ctx, "Flag 2", addr(check1))

  ## ------------------------------------------------
  ##                       PROGRESSBAR
  ## ------------------------------------------------

  uiHeader(ctx, media, "Progressbar")
  uiWidget(ctx, media, 35)
  discard progress(ctx, addr(prog), 100, true.cint)

  ## ------------------------------------------------
  ##                       PIEMENU
  ## ------------------------------------------------

  if isMouseClickDownInRect(addr(ctx.input), BUTTON_RIGHT, layout.bounds, true.cint) != 0:
    piemenuPos = ctx.input.mouse.pos
    piemenuActive = true

  if piemenuActive:
    let ret: int = uiPiemenu(ctx, piemenuPos, 140, addr(media.menu[0]), 6)
    if ret == - 2: piemenuActive = false
    if ret != - 1:
      stdout.write("piemenu selected: " & $ret & "\n")
      piemenuActive = false

  styleSetFont(ctx, addr(media.font14.handle))
  `end`(ctx)

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
    VERTEX_LAYOUT_END
  ]

# proc die*(fmt: cstring) {.varargs.} =
#   var ap: VaList
#   vaStart(ap, fmt)
#   vfprintf(stderr, fmt, ap)
#   vaEnd(ap)
#   fputs("\x0A", stderr)
#   exit(exit_Failure)

proc iconLoad*(filename: string): Image =
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
  # glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GLfloat(GL_LINEAR_MIPMAP_NEAREST))
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GLfloat(GL_CLAMP_TO_EDGE))
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GLfloat(GL_CLAMP_TO_EDGE))
  glTexImage2D(GL_TEXTURE_2D, 0, GLint(GL_RGBA8), GLsizei(x), GLsizei(y), 0, GL_RGBA, GL_UNSIGNED_BYTE, cast[pointer](data))
  glGenerateMipmap(GL_TEXTURE_2D)
  # stbi.imageFree(data)
  return imageId(cint(tex))

proc deviceInit*(dev: ptr Device) =
  var status: GLint
  let
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
      "}\n"
    ]
    vertexShader = allocCStringArray(vertShader)
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
    fragmentShader = allocCStringArray(fragShader)

  bufferInitDefault(addr(dev.cmds))

  dev.prog = glCreateProgram()
  dev.vertShdr = glCreateShader(GL_VERTEX_SHADER)
  dev.fragShdr = glCreateShader(GL_FRAGMENT_SHADER)

  glShaderSource(dev.vertShdr, 12, vertexShader, nil)
  glShaderSource(dev.fragShdr, 9, fragmentShader, nil)

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
  assert(status == GLint(GL_TRUE))

  dev.uniformTex = glGetUniformLocation(dev.prog, "Texture")
  dev.uniformProj = glGetUniformLocation(dev.prog, "ProjMtx")
  dev.attribPos = glGetAttribLocation(dev.prog, "Position")
  dev.attribUv = glGetAttribLocation(dev.prog, "TexCoord")
  dev.attribCol = glGetAttribLocation(dev.prog, "Color")

  ## buffer setup
  let
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

proc uploadAtlas*(dev: var Device; image: pointer; width: int; height: int) =
  glGenTextures(1, addr(dev.fontTex))
  glBindTexture(GL_TEXTURE_2D, dev.fontTex)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexImage2D(GL_TEXTURE_2D, 0, GLint(GL_RGBA), GLsizei(width), GLsizei(height), 0, GL_RGBA, GL_UNSIGNED_BYTE, image)

proc shutdown*(dev: var Device) =
  glDetachShader(dev.prog, dev.vertShdr)
  glDetachShader(dev.prog, dev.fragShdr)
  glDeleteShader(dev.vertShdr)
  glDeleteShader(dev.fragShdr)
  glDeleteProgram(dev.prog)
  glDeleteTextures(1, addr(dev.fontTex))
  glDeleteBuffers(1, addr(dev.vbo))
  glDeleteBuffers(1, addr(dev.ebo))
  free(addr(dev.cmds))

proc draw*(dev: var Device; ctx: ptr Context; width: int; height: int; scale: Vec2; aa: AntiAliasing) =
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

  # memset(addr(config), 0, sizeof((config)))
  config.vertexLayout = vertexLayout[0].addr
  config.vertexSize = sizeof(GlfwVertex)
  # config.vertexAlignment = alignof(struct, glfwVertex)
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
  convert(ctx, addr(dev.cmds), addr(vbuf), addr(ebuf), addr(config))
  discard glUnmapBuffer(GL_ARRAY_BUFFER)
  discard glUnmapBuffer(GL_ELEMENT_ARRAY_BUFFER)

  ## iterate over and execute each draw command
  for cmd in ctx.drawCommands(addr(dev.cmds)):
    if cmd.elemCount == 0: continue
    glBindTexture(GL_TEXTURE_2D, GLuint(cmd.texture.id))
    glScissor((GLint)(cmd.clipRect.x * scale.x),
              (GLint)((height - (GLint)(cmd.clipRect.y + cmd.clipRect.h)).float * scale.y),
              (GLint)(cmd.clipRect.w * scale.x),
              (GLint)(cmd.clipRect.h * scale.y))
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

# proc main*(argc: cint; argv: ptr cstring): cint =
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
  var device: Device
  var atlas: FontAtlas
  var media: Media
  var ctx: Context

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
  #   fprintf(stderr, "Failed to setup GLEW\x0A")
  #   exit(1)

  ## GUI
  deviceInit(addr(device))
  var image: pointer
  var
    w: cint
    h: cint
  var cfg: FontConfig = fontConfig(0)

  cfg.oversampleH = 3.cuchar
  cfg.oversampleV = 2.cuchar

  ## Loading one font with different heights is only required if you want higher
  ##      quality text otherwise you can just set the font height directly
  ##      e.g.: ctx.style.font.height = 20.

  initDefault(addr(atlas))
  begin(addr(atlas))
  media.font14 = addFromFile(addr(atlas), "extra_font/Roboto-Regular.ttf", 14.0, addr(cfg))
  media.font18 = addFromFile(addr(atlas), "extra_font/Roboto-Regular.ttf", 18.0, addr(cfg))
  media.font20 = addFromFile(addr(atlas), "extra_font/Roboto-Regular.ttf", 20.0, addr(cfg))
  media.font22 = addFromFile(addr(atlas), "extra_font/Roboto-Regular.ttf", 22.0, addr(cfg))
  image = bake(addr(atlas), addr(w), addr(h), FONT_ATLAS_RGBA32)
  device.uploadAtlas(image, w, h)
  `end`(addr(atlas), handleId(cint(device.fontTex)), addr(device.null))
  discard initDefault(addr(ctx), addr(media.font14.handle))

  ## icons
  # glEnable(GL_TEXTURE_2D)
  media.unchecked = iconLoad("example/icon/unchecked.png")
  media.checked = iconLoad("example/icon/checked.png")
  media.rocket = iconLoad("example/icon/rocket.png")
  media.cloud = iconLoad("example/icon/cloud.png")
  media.pen = iconLoad("example/icon/pen.png")
  media.play = iconLoad("example/icon/play.png")
  media.pause = iconLoad("example/icon/pause.png")
  media.stop = iconLoad("example/icon/stop.png")
  media.next = iconLoad("example/icon/next.png")
  media.prev = iconLoad("example/icon/prev.png")
  media.tools = iconLoad("example/icon/tools.png")
  media.dir = iconLoad("example/icon/directory.png")
  media.copy = iconLoad("example/icon/copy.png")
  media.convert = iconLoad("example/icon/export.png")
  media.del = iconLoad("example/icon/delete.png")
  media.edit = iconLoad("example/icon/edit.png")
  media.menu[0] = iconLoad("example/icon/home.png")
  media.menu[1] = iconLoad("example/icon/phone.png")
  media.menu[2] = iconLoad("example/icon/plane.png")
  media.menu[3] = iconLoad("example/icon/wifi.png")
  media.menu[4] = iconLoad("example/icon/settings.png")
  media.menu[5] = iconLoad("example/icon/volume.png")

  for i in 0..8:
    let buffer: string = "example/images/image" & $(i + 1) & ".png"
    media.images[i] = iconLoad(buffer)

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

    inputKey(addr(ctx), KEY_DEL, win.isKeyDown(keyDelete).cint)
    inputKey(addr(ctx), KEY_ENTER, win.isKeyDown(keyEnter).cint)
    inputKey(addr(ctx), KEY_TAB, win.isKeyDown(keyTab).cint)
    inputKey(addr(ctx), KEY_BACKSPACE, win.isKeyDown(keyBackspace).cint)
    inputKey(addr(ctx), KEY_LEFT, win.isKeyDown(keyLeft).cint)
    inputKey(addr(ctx), KEY_RIGHT, win.isKeyDown(keyRight).cint)
    inputKey(addr(ctx), KEY_UP, win.isKeyDown(keyUp).cint)
    inputKey(addr(ctx), KEY_DOWN, win.isKeyDown(keyDown).cint)

    if win.isKeyDown(keyLeftControl) or win.isKeyDown(keyRightControl):
      inputKey(addr(ctx), KEY_COPY, win.isKeyDown(keyC).cint)
      inputKey(addr(ctx), KEY_PASTE, win.isKeyDown(keyP).cint)
      inputKey(addr(ctx), KEY_CUT, win.isKeyDown(keyX).cint)
      inputKey(addr(ctx), KEY_CUT, win.isKeyDown(keyE).cint)
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
    basicDemo(addr(ctx), addr(media))
    buttonDemo(addr(ctx), addr(media))
    gridDemo(addr(ctx), addr(media))

    ## Draw
    glViewport(0, 0, GLsizei(displayWidth), GLsizei(displayHeight))
    glClear(GL_COLOR_BUFFER_BIT)
    glClearColor(0.3, 0.3, 0.3, 1.0)
    device.draw(addr(ctx), width.cint, height.cint, scale, ANTI_ALIASING_ON)
    glfw.swapBufs(win)

  glDeleteTextures(1, cast[ptr GLuint](addr(media.unchecked.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.checked.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.rocket.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.cloud.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.pen.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.play.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.pause.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.stop.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.next.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.prev.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.tools.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.dir.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.del.handle.id)))

  clear(addr(atlas))
  free(addr(ctx))
  device.shutdown()
  glfw.terminate()
  # return 0
