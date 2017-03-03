## nuklear - v1.05 - public domain

import
  stb_image as stbi,
  opengl,
  glfw,
  unicode,
  os,
  math,
  algorithm,
  ../nuklear

const
  WINDOW_WIDTH* = 1200
  WINDOW_HEIGHT* = 800
  MAX_VERTEX_MEMORY* = 512 * 1024
  MAX_ELEMENT_MEMORY* = 128 * 1024

when defined(macosx):
  const
    SHADER_VERSION = "#version 150\n"
else:
  const
    SHADER_VERSION* = "#version 300 es\n"

## ===============================================================
##
##                           GUI
##
## ===============================================================

type
  Icons = object
    desktop: Image
    home: Image
    computer: Image
    directory: Image
    defaultFile: Image
    textFile: Image
    musicFile: Image
    fontFile: Image
    imgFile: Image
    movieFile: Image

  FileGroups = enum
    FILE_GROUP_DEFAULT, FILE_GROUP_TEXT, FILE_GROUP_MUSIC, FILE_GROUP_FONT,
    FILE_GROUP_IMAGE, FILE_GROUP_MOVIE, FILE_GROUP_MAX


type
  FileTypes = enum
    FILE_DEFAULT, FILE_TEXT, FILE_C_SOURCE, FILE_CPP_SOURCE, FILE_HEADER,
    FILE_CPP_HEADER, FILE_MP3, FILE_WAV, FILE_OGG, FILE_TTF, FILE_BMP, FILE_PNG,
    FILE_JPEG, FILE_PCX, FILE_TGA, FILE_GIF, FILE_MAX


type
  FileGroup = object
    group: FileGroups
    name: string
    icon: Image

  File = object
    typ: FileTypes
    suffix: string
    group: FileGroups

  Media = object
    font: cint
    iconSheet: cint
    icons: Icons
    group: array[FILE_GROUP_MAX, FileGroup]
    files: array[FILE_MAX, File]


# const
#   MAX_PATH_LEN = 512

type
  FileBrowser = object
    file: string ## path
    home: string
    desktop: string
    directory: string ## directory content
    files: seq[string]
    directories: seq[string]
    # fileCount: csize
    # dirCount: csize
    media: ptr Media


# when defined(unix):
# when not defined(win32):
# proc die(fmt: cstring) {.varargs.} =
#   var ap: VaList
#   vaStart(ap, fmt)
#   vfprintf(stderr, fmt, ap)
#   vaEnd(ap)
#   fputs("\x0A", stderr)
#   exit(exit_Failure)

# proc fileLoad(path: string): string =
  # var buf: string
  # var fd: system.File = open(path, fmRead)
  # if fd == nil:
    # die("Failed to open file: %s\x0A", path)
    # quit -1
  # fseek(fd, 0, seek_End)
  # siz[] = cast[csize](ftell(fd))
  # fseek(fd, 0, seek_Set)
  # var size = fd.getFileSize()
  # buf = cast[string](calloc(siz[], 1))
  # buf = readFile(path)
  # fclose(fd)
  # return buf

# proc strDuplicate(src: cstring): cstring =
#   var ret: cstring
#   var len: csize = strlen(src)
#   if not len: return 0
#   ret = cast[cstring](malloc(len + 1))
#   if not ret: return 0
#   memcpy(ret, src, len)
#   ret[len] = '\0'
#   return ret

# proc dirFreeList(list: cstringArray; size: csize) =
#   var i: csize
#   i = 0
#   while i < size:
#     free(list[i])
#     inc(i)
#   free(list)

proc dirList(dir: string): tuple[dirs: seq[string], files: seq[string]] =
  var dirs: seq[string] = @[]
  var files: seq[string] = @[]

  for kind, path in walkDir(dir):
    case kind:
    of pcFile:
      files.add(extractFilename(path))
      continue
    of pcDir:
      var (_, tail) = splitPath(path)
      dirs.add(tail)
      continue
    else:
      continue

  return (sorted(dirs, cmp[string]), sorted(files, cmp[string]))

proc mediaIconForFile(media: Media; file: string): Image =
  ## extract suffix .xxx from file
  var (_, _, suffix) = splitFile(file)
  suffix = suffix[1..high(suffix)]

  ## check for all file definition of all groups for fitting suffix
  if suffix != "":
    for file in media.files:
      ## found correct file definition so
      if file.suffix == suffix:
        return media.group[file.group].icon

  return media.icons.defaultFile

proc mediaInit(media: var Media) =
  ## file groups
  let icons: Icons = media.icons
  media.group[FILE_GROUP_DEFAULT] = FileGroup(group: FILE_GROUP_DEFAULT, name: "default", icon: icons.defaultFile)
  media.group[FILE_GROUP_TEXT] = FileGroup(group: FILE_GROUP_TEXT, name: "textual", icon: icons.textFile)
  media.group[FILE_GROUP_MUSIC] = FileGroup(group: FILE_GROUP_MUSIC, name: "music", icon: icons.musicFile)
  media.group[FILE_GROUP_FONT] = FileGroup(group: FILE_GROUP_FONT, name: "font", icon: icons.fontFile)
  media.group[FILE_GROUP_IMAGE] = FileGroup(group: FILE_GROUP_IMAGE, name: "image", icon: icons.imgFile)
  media.group[FILE_GROUP_MOVIE] = FileGroup(group: FILE_GROUP_MOVIE, name: "movie", icon: icons.movieFile)

  ## files
  media.files[FILE_DEFAULT] = File(typ: FILE_DEFAULT, suffix: nil, group: FILE_GROUP_DEFAULT)
  media.files[FILE_TEXT] = File(typ: FILE_TEXT, suffix: "txt", group: FILE_GROUP_TEXT)
  media.files[FILE_C_SOURCE] = File(typ: FILE_C_SOURCE, suffix: "c", group: FILE_GROUP_TEXT)
  media.files[FILE_CPP_SOURCE] = File(typ: FILE_CPP_SOURCE, suffix: "cpp", group: FILE_GROUP_TEXT)
  media.files[FILE_HEADER] = File(typ: FILE_HEADER, suffix: "h", group: FILE_GROUP_TEXT)
  media.files[FILE_CPP_HEADER] = File(typ: FILE_HEADER, suffix: "hpp", group: FILE_GROUP_TEXT)
  media.files[FILE_MP3] = File(typ: FILE_MP3, suffix: "mp3", group: FILE_GROUP_MUSIC)
  media.files[FILE_WAV] = File(typ: FILE_WAV, suffix: "wav", group: FILE_GROUP_MUSIC)
  media.files[FILE_OGG] = File(typ: FILE_OGG, suffix: "ogg", group: FILE_GROUP_MUSIC)
  media.files[FILE_TTF] = File(typ: FILE_TTF, suffix: "ttf", group: FILE_GROUP_FONT)
  media.files[FILE_BMP] = File(typ: FILE_BMP, suffix: "bmp", group: FILE_GROUP_IMAGE)
  media.files[FILE_PNG] = File(typ: FILE_PNG, suffix: "png", group: FILE_GROUP_IMAGE)
  media.files[FILE_JPEG] = File(typ: FILE_JPEG, suffix: "jpg", group: FILE_GROUP_IMAGE)
  media.files[FILE_PCX] = File(typ: FILE_PCX, suffix: "pcx", group: FILE_GROUP_IMAGE)
  media.files[FILE_TGA] = File(typ: FILE_TGA, suffix: "tga", group: FILE_GROUP_IMAGE)
  media.files[FILE_GIF] = File(typ: FILE_GIF, suffix: "gif", group: FILE_GROUP_IMAGE)

proc fileBrowserReloadDirectoryContent(browser: ptr FileBrowser; path: string) =
  browser.directory = path
  var (dirs, files) = dirList(path)
  browser.files = files
  browser.directories = dirs

proc fileBrowserInit(browser: ptr FileBrowser; media: ptr Media) =
  # zeroMem(browser, sizeof(browser[]))
  browser.media = media

  ## load files and sub-directory list
  var home: string = os.getHomeDir()

  browser.home = home
  browser.directory = browser.home

  browser.desktop = joinPath(browser.home, "desktop/")
  var (dirs, files) = dirList(browser.directory)
  browser.files = files
  browser.directories = dirs

proc fileBrowserRun(browser: ptr FileBrowser; ctx: ptr Context): int =
  result = 0
  var layout: Panel
  var media: Media = browser.media[]
  var totalSpace: Rect

  let windowFlags = WINDOW_BORDER or WINDOW_NO_SCROLLBAR or WINDOW_MOVABLE

  begin(ctx, layout, "File Browser", rect(50, 50, 800, 600), windowFlags):
    var
      sub: Panel
      ratio {.global.}: array[2, cfloat] = [0.25.cfloat, UNDEFINED]
      spacingX: cfloat = ctx.style.window.spacing.x

    ## output path directory selector in the menubar
    ctx.style.window.spacing.x = 0
    menubarBegin(ctx)

    var d: string = browser.directory
    var dseq: seq[string] = @[]

    layoutRowDynamic(ctx, 25, 6)

    while d != "":
      var tail: string
      (d, tail) = d.splitPath()
      dseq.insert(tail, 0)

    var begin = browser.directory
    var directory = "/"

    for i in 0..<len(dseq):
      begin = dseq[i]
      directory = joinPath(directory, dseq[i])
      if buttonLabel(ctx, begin) != 0:
        fileBrowserReloadDirectoryContent(browser, directory)
        break

    # while inc(d)[]:
    #   if d[] == '/':
    #     d[] = '\0'
    #     if buttonLabel(ctx, begin) != 0:
    #       inc(d)[] = '/'
    #       d[] = '\0'
    #       fileBrowserReloadDirectoryContent(browser, browser.directory)
    #       break
    #     d[] = '/'
    #     begin = d + 1

    menubarEnd(ctx)
    ctx.style.window.spacing.x = spacingX

    ## window layout
    totalSpace = getWindowContentRegion(ctx)
    layoutRow(ctx, DYNAMIC, totalSpace.h, 2, ratio[0].addr)
    discard groupBegin(ctx, addr(sub), "Special", Flags(WINDOW_NO_SCROLLBAR))

    let
      home: Image = media.icons.home
      desktop: Image = media.icons.desktop
      computer: Image = media.icons.computer

    layoutRowDynamic(ctx, 40, 1)
    if buttonImageLabel(ctx, home, "home", Flags(TEXT_CENTERED)) != 0:
      fileBrowserReloadDirectoryContent(browser, browser.home)
    if buttonImageLabel(ctx, desktop, "desktop", Flags(TEXT_CENTERED)) != 0:
      fileBrowserReloadDirectoryContent(browser, browser.desktop)
    if buttonImageLabel(ctx, computer, "computer", Flags(TEXT_CENTERED)) != 0:
      fileBrowserReloadDirectoryContent(browser, "/")
    groupEnd(ctx)

    ## output directory content window
    discard groupBegin(ctx, addr(sub), "Content", 0)

    var
      index: int = - 1
      j: int = 0
      k: int = 0
      cols: int = 4
      count: int = len(browser.directories) + len(browser.files)
      rows: int = count div cols

    for i in 0..rows:
      var n: csize = j + cols
      layoutRowDynamic(ctx, 135, cint(cols))

      while j < min(count, n):
        ## draw one row of icons
        if j < len(browser.directories):
          ## draw and execute directory buttons
          if buttonImage(ctx, media.icons.directory) != 0: index = j
        else:
          ## draw and execute files buttons
          var icon: Image
          var fileIndex: csize = (csize(j) - len(browser.directories))

          icon = mediaIconForFile(media, browser.files[fileIndex])

          if buttonImage(ctx, icon) != 0:
            browser.file = joinPath(browser.directory, browser.files[fileIndex])
            result = 1

        inc(j)

      n = k + cols

      layoutRowDynamic(ctx, 20, cint(cols))
      while k < min(count, n):
        ## draw one row of labels
        if k < len(browser.directories):
          label(ctx, browser.directories[k], Flags(TEXT_CENTERED))
        else:
          var t: csize = k - len(browser.directories)
          label(ctx, browser.files[t], Flags(TEXT_CENTERED))

        inc(k)

    if index != - 1:
      browser.directory = joinPath(browser.directory, browser.directories[index])
      fileBrowserReloadDirectoryContent(browser, browser.directory)
      sub.offset.y = 0

    groupEnd(ctx)

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
  # glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GLfloat(GL_LINEAR_MIPMAP_NEAREST))
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GLfloat(GL_CLAMP_TO_EDGE))
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GLfloat(GL_CLAMP_TO_EDGE))
  glTexImage2D(GL_TEXTURE_2D, 0, GLint(GL_RGBA8), GLsizei(x), GLsizei(y), 0, GL_RGBA, GL_UNSIGNED_BYTE, cast[pointer](data))
  glGenerateMipmap(GL_TEXTURE_2D)
  # stbi.imageFree(data)
  return imageId(cint(tex))

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
      "}\n"
    ]
    vertexShader = allocCStringArray(vertShader)
    fragShader = [
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

  deallocCStringArray(vertexShader)
  deallocCStringArray(fragmentShader)

  dev.uniformTex = glGetUniformLocation(dev.prog, "Texture")
  dev.uniformProj = glGetUniformLocation(dev.prog, "ProjMtx")
  dev.attribPos = glGetAttribLocation(dev.prog, "Position")
  dev.attribUv = glGetAttribLocation(dev.prog, "TexCoord")
  dev.attribCol = glGetAttribLocation(dev.prog, "Color")

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
  glVertexAttribPointer(cast[GLuint](dev.attribUv), 2, cGL_FLOAT, GL_FALSE, vs, cast[pointer](vt))
  glVertexAttribPointer(cast[GLuint](dev.attribCol), 4, GL_UNSIGNED_BYTE, GL_TRUE, vs, cast[pointer](vc))
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

proc draw(dev: var Device; ctx: ptr Context; width: int; height: int; scale: Vec2; aa: AntiAliasing) =
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
  var vertexLayout {.global.}: array[4, DrawVertexLayoutElement] = [
      initDrawVertexLayoutElement(nkVertexPosition, FORMAT_FLOAT, offsetof(GlfwVertex, position)),
      initDrawVertexLayoutElement(nkVertexTexcoord, FORMAT_FLOAT, offsetof(GlfwVertex, uv)),
      initDrawVertexLayoutElement(nkVertexColor, FORMAT_R8G8B8A8, offsetof(GlfwVertex, col)),
      VERTEX_LAYOUT_END
    ]

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
    glScissor(GLint(cmd.clipRect.x * scale.x),
              GLint((height - GLint(cmd.clipRect.y + cmd.clipRect.h)).float * scale.y),
              GLint(cmd.clipRect.w * scale.x),
              GLint(cmd.clipRect.h * scale.y))
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

# proc errorCallback*(e: cint; d: cstring) =
#   printf("Error %d: %s\x0A", e, d)

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
  var ctx: Context
  var font: ptr Font
  var atlas: FontAtlas
  var browser: FileBrowser
  var media: Media

  var textInput = proc(win: Win; codepoint: unicode.Rune) =
    inputUnicode(addr(ctx), nuklear.Rune(codepoint))

  var scrollInput = proc(win: Win; offset: tuple[x: float; y: float]) =
    inputScroll(addr(ctx), offset.y)


  ## GLFW
  glfw.init()

  when defined(macosx):
    win = glfw.newGlWin((WINDOW_WIDTH, WINDOW_HEIGHT), "Demo", version = glv33, compat = true, profile = glpCore)
  else:
    win = glfw.newGlWin((WINDOW_WIDTH, WINDOW_HEIGHT), "Demo", version = glv33, profile = glpCore)

  opengl.loadExtensions()
  glfw.makeContextCurrent(win)
  win.charCb = textInput
  win.scrollCb = scrollInput

  ## OpenGL
  glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  ## GUI
  deviceInit(addr(device))
  var image: pointer
  var
    w: cint
    h: cint
  var fontPath: string = if paramCount() >= 1: paramStr(1) else: nil

  initDefault(addr(atlas))
  begin(addr(atlas))
  if fontPath != nil: font = addFromFile(addr(atlas), fontPath, 13.0, nil)
  else: font = addDefault(addr(atlas), 13.0, nil)
  image = bake(addr(atlas), addr(w), addr(h), FONT_ATLAS_RGBA32)
  device.uploadAtlas(image, w, h)
  `end`(addr(atlas), handleId(cint(device.fontTex)), addr(device.null))
  discard initDefault(addr(ctx), addr(font.handle))

  ## icons
  # glEnable(GL_TEXTURE_2D)
  media.icons.home = iconLoad("example/icon/home.png")
  media.icons.directory = iconLoad("example/icon/directory.png")
  media.icons.computer = iconLoad("example/icon/computer.png")
  media.icons.desktop = iconLoad("example/icon/desktop.png")
  media.icons.defaultFile = iconLoad("example/icon/default.png")
  media.icons.textFile = iconLoad("example/icon/text.png")
  media.icons.musicFile = iconLoad("example/icon/music.png")
  media.icons.fontFile = iconLoad("example/icon/font.png")
  media.icons.imgFile = iconLoad("example/icon/img.png")
  media.icons.movieFile = iconLoad("example/icon/movie.png")
  mediaInit(media)
  fileBrowserInit(addr(browser), addr(media))

  while not win.shouldClose:
    ## High DPI displays
    var scale: Vec2

    (width, height) = win.size
    (displayWidth, displayHeight) = win.framebufSize
    scale.x = displayWidth / width
    scale.y = displayHeight / height

    ## Input
    var
      x: cdouble
      y: cdouble

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
    discard fileBrowserRun(addr(browser), addr(ctx))

    ## Draw
    glViewport(0, 0, GLsizei(displayWidth), GLsizei(displayHeight))
    glClear(GL_COLOR_BUFFER_BIT)
    glClearColor(0.2, 0.2, 0.2, 1.0)
    device.draw(addr(ctx), width, height, scale, ANTI_ALIASING_ON)
    glfw.swapBufs(win)

  glDeleteTextures(1, cast[ptr GLuint](addr(media.icons.home.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.icons.directory.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.icons.computer.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.icons.desktop.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.icons.defaultFile.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.icons.textFile.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.icons.musicFile.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.icons.fontFile.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.icons.imgFile.handle.id)))
  glDeleteTextures(1, cast[ptr GLuint](addr(media.icons.movieFile.handle.id)))
  # fileBrowserFree(addr(browser))
  clear(addr(atlas))
  free(addr(ctx))
  device.shutdown()
  glfw.terminate()
  # return 0
