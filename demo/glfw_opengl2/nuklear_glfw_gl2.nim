##
##  Nuklear - v1.00 - public domain
##  no warrenty implied; use at your own risk.
##  authored from 2015-2016 by Micha Mettke
##
##
##  ===============================================================
##
##                               API
##
##  ===============================================================
##
import ../../nuklear
import glfw
import opengl
import unicode

type
  InitState* = enum
    DEFAULT = 0, INSTALL_CALLBACKS

const TEXT_MAX = 64

##
##  ===============================================================
##
##                           IMPLEMENTATION
##
##  ===============================================================
##

type
  Device = object
    cmds: Buffer
    null: DrawNullTexture
    font_tex: GLuint

  Vertex = object
    position: array[2, float]
    uv: array[2, float]
    col: array[4, byte]

  nk_glfw = object
    win: Win
    width: int
    height: int
    display_width: int
    display_height: int
    ogl: Device
    ctx: Context
    atlas: FontAtlas
    fb_scale: Vec2
    text: array[TEXT_MAX, nuklear.Rune]
    text_len: int
    scroll: float

var glfw_nk: nk_glfw

var vertexLayout = [initDrawVertexLayoutElement(nkVertexPosition, FORMAT_FLOAT, offsetof(Vertex, position)),
                     initDrawVertexLayoutElement(nkVertexTexcoord, FORMAT_FLOAT, offsetof(Vertex, uv)),
                     initDrawVertexLayoutElement(nkVertexColor, FORMAT_R8G8B8A8, offsetof(Vertex, col)),
                     VERTEX_LAYOUT_END]
                      #  initDrawVertexLayoutElement(vertexLayout_END[0].DrawVertexLayoutAttribute, vertexLayout_END[1].DrawVertexLayoutFormat, vertexLayout_END[2].csize)]

proc deviceUploadAtlas(image: pointer; width: int; height: int) =
  let dev: ptr Device = addr(glfw_nk.ogl)

  glGenTextures(1, addr(dev.font_tex))
  glBindTexture(GL_TEXTURE_2D, dev.font_tex)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA.GLint, GLsizei(width),
               GLsizei(height), 0, GL_RGBA, GL_UNSIGNED_BYTE, image)

proc render*(AA: AntiAliasing; maxVertexBuffer: int; maxElementBuffer: int) =
  let dev: ptr Device = addr(glfw_nk.ogl)

  ## setup global state
  glPushAttrib(GL_ENABLE_BIT or GL_COLOR_BUFFER_BIT or GL_TRANSFORM_BIT)

  glDisable(GL_CULL_FACE)
  glDisable(GL_DEPTH_TEST)

  glEnable(GL_SCISSOR_TEST)
  glEnable(GL_BLEND)
  glEnable(GL_TEXTURE_2D)

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

  ## setup viewport/project
  glViewport(0, 0, GLsizei(glfw_nk.display_width), GLsizei(glfw_nk.display_height))
  glMatrixMode(GL_PROJECTION)
  glPushMatrix()
  glLoadIdentity()

  glOrtho(0.0, GLdouble(glfw_nk.width), GLdouble(glfw_nk.height), 0.0, - 1.0, 1.0)
  glMatrixMode(GL_MODELVIEW)
  glPushMatrix()
  glLoadIdentity()

  glEnableClientState(GL_VERTEX_ARRAY)
  glEnableClientState(GL_TEXTURE_COORD_ARRAY)
  glEnableClientState(GL_COLOR_ARRAY)

  var
    vs: GLsizei = GLsizei(sizeof(Vertex))
    vp: csize = offsetof(Vertex, position)
    vt: csize = offsetof(Vertex, uv)
    vc: csize = offsetof(Vertex, col)

  ## convert from command queue into draw list and draw to screen
  var
    vbuf: Buffer
    ebuf: Buffer

  ## fill convert configuration
  var config: ConvertConfig

  #zeroMem(addr(config), sizeof(config))
  config.vertexLayout = addr(vertexLayout[0])
  config.vertex_size = sizeof(Vertex)
  # TODO: fix ALIGNOF
  # config.vertex_alignment = ALIGNOF(Vertex)
  config.null = dev.null
  config.circle_segment_count = 22
  config.curve_segment_count = 22
  config.arc_segment_count = 22
  config.global_alpha = 1.0
  config.shape_AA = AA
  config.line_AA = AA

  ## convert shapes into vertexes
  bufferInitDefault(addr(vbuf))
  bufferInitDefault(addr(ebuf))
  convert(addr(glfw_nk.ctx), addr(dev.cmds), addr(vbuf), addr(ebuf), addr(config))

  ## setup vertex buffer pointer
  var vertices: ptr cuchar = cast[ptr cuchar](memoryConst(addr(vbuf)))
  glVertexPointer(2, cGL_FLOAT, vs, vertices + vp)
  glTexCoordPointer(2, cGL_FLOAT, vs, vertices + vt)
  glColorPointer(4, GL_UNSIGNED_BYTE, vs, vertices + vc)

  ## iterate over and execute each draw command
  var offset: ptr DrawIndex = cast[ptr DrawIndex](memoryConst(addr(ebuf)))
  # draw_foreach(cmd, addr(glfw_nk.ctx), addr(dev.cmds)):
  for cmd in addr(glfw_nk.ctx).drawCommands(addr(dev.cmds)):
    if cmd.elem_count == 0:
      continue

    glBindTexture(GL_TEXTURE_2D, GLuint(cmd.texture.id))

    glScissor(GLint(cmd.clip_rect.x * glfw_nk.fb_scale.x),
              GLint((glfw_nk.height.float - (cmd.clip_rect.y + cmd.clip_rect.h)) * glfw_nk.fb_scale.y),
              GLint(cmd.clip_rect.w * glfw_nk.fb_scale.x),
              GLint(cmd.clip_rect.h * glfw_nk.fb_scale.y))

    glDrawElements(GL_TRIANGLES, GLsizei(cmd.elem_count), GL_UNSIGNED_SHORT, offset)

    inc(offset, cmd.elem_count.int)

  clear(addr(glfw_nk.ctx))
  free(addr(vbuf))
  free(addr(ebuf))

  ## default OpenGL state
  glDisableClientState(GL_VERTEX_ARRAY)
  glDisableClientState(GL_TEXTURE_COORD_ARRAY)
  glDisableClientState(GL_COLOR_ARRAY)

  glDisable(GL_CULL_FACE)
  glDisable(GL_DEPTH_TEST)
  glDisable(GL_SCISSOR_TEST)
  glDisable(GL_BLEND)
  glDisable(GL_TEXTURE_2D)

  glBindTexture(GL_TEXTURE_2D, 0)

  glMatrixMode(GL_MODELVIEW)
  glPopMatrix()

  glMatrixMode(GL_PROJECTION)
  glPopMatrix()

  glPopAttrib()

proc charCallback(win: Win; codepoint: unicode.Rune) =
  if glfw_nk.text_len < TEXT_MAX: glfw_nk.text[glfw_nk.text_len] = nuklear.Rune(codepoint)
  inc(glfw_nk.text_len)

proc scrollCallback(win: Win; offset: tuple[x: float; y: float]) =
  glfw_nk.scroll += offset.y

proc clipbardPaste(usr: Handle; edit: ptr TextEdit) =
  let text: string = glfw_nk.win.clipboardStr
  discard edit.paste(text, len(text).cint)

proc clipbardCopy(usr: Handle; text: cstring; len: cint) =
  glfw_nk.win.clipboardStr = $text
  # var str: ptr string = nil
  # if len == 0: return
  # str = alloc[string](len + 1)
  # if str == nil: return
  # copyMem(str, addr(text), len)
  # str[len] = '\0'
  # glfw_nk.win.clipboardStr = str[]
  # dealloc(str)

proc initContext*(win: Win; initState: InitState): PContext =
  glfw_nk.win = win

  let ctx = addr(glfw_nk.ctx)

  if initState == INSTALL_CALLBACKS:
    win.scrollCb = scrollCallback
    win.charCb = charCallback

  discard initDefault(ctx, nil)

  ctx.clip.copy = proc(usr: Handle; text: cstring; len: cint) {.cdecl.} =
    clipbardCopy(usr, text, len)
  ctx.clip.paste = proc(usr: Handle; edit: ptr TextEdit) {.cdecl.} =
    clipbardPaste(usr, edit)
  ctx.clip.userdata = handlePtr(nil)

  bufferInitDefault(addr(glfw_nk.ogl.cmds))
  loadExtensions()
  return ctx

proc fontStashBegin*(atlas: var ptr FontAtlas) =
  let fontAtlas: ptr FontAtlas = addr(glfw_nk.atlas)

  fontAtlas.initDefault()
  fontAtlas.begin()
  atlas = fontAtlas

proc fontStashEnd*() =
  var
    image: pointer
    w: cint
    h: cint

  let atlas = addr(glfw_nk.atlas)

  image = atlas[].bake(w, h, FONT_ATLAS_RGBA32)
  deviceUploadAtlas(image, w, h)
  atlas.`end`(handle_id(glfw_nk.ogl.font_tex.cint), addr(glfw_nk.ogl.null))

  if glfw_nk.atlas.default_font != nil:
    styleSetFont(addr(glfw_nk.ctx), addr(glfw_nk.atlas.default_font.handle))

proc newFrame*() =
  # var i: cint
  var
    x: cdouble
    y: cdouble
  var ctx: PContext = addr(glfw_nk.ctx)
  var win: Win = glfw_nk.win
  var
    width: int
    height: int
    display_width: int
    display_height: int

  (width, height) = win.size
  (display_width, display_height) = win.framebufSize
  glfw_nk.width = width.cint
  glfw_nk.height = height.cint
  glfw_nk.display_width = display_width.cint
  glfw_nk.display_height = display_height.cint
  glfw_nk.fb_scale.x = glfw_nk.display_width.cfloat / glfw_nk.width.cfloat
  glfw_nk.fb_scale.y = glfw_nk.display_height.cfloat / glfw_nk.height.cfloat

  input_begin(ctx)
  # i = 0
  # while i < glfw_nk.text_len:
  for i in 0..glfw_nk.text_len - 1:
    ctx.inputUnicode(glfw_nk.text[i])
    # inc(i)

  ## optional grabbing behavior
  if ctx.input.mouse.grab != 0.cuchar:
    win.cursorMode = cmHidden
  elif ctx.input.mouse.ungrab != 0.cuchar:
    win.cursorMode = cmNormal

  ctx.input_key(KEY_DEL, isKeyDown(win, keyDelete).cint)
  ctx.input_key(KEY_ENTER, isKeyDown(win, keyEnter).cint)
  ctx.input_key(KEY_TAB, isKeyDown(win, keyTab).cint)
  ctx.input_key(KEY_BACKSPACE, isKeyDown(win, keyBackspace).cint)
  ctx.input_key(KEY_UP, isKeyDown(win, keyUp).cint)
  ctx.input_key(KEY_DOWN, isKeyDown(win, keyDown).cint)
  ctx.input_key(KEY_TEXT_START, isKeyDown(win, keyHome).cint)
  ctx.input_key(KEY_TEXT_END, isKeyDown(win, keyEnd).cint)
  ctx.input_key(KEY_SCROLL_START, isKeyDown(win, keyHome).cint)
  ctx.input_key(KEY_SCROLL_END, isKeyDown(win, keyEnd).cint)
  ctx.input_key(KEY_SCROLL_DOWN, isKeyDown(win, keyPageDown).cint)
  ctx.input_key(KEY_SCROLL_UP, isKeyDown(win, keyPageUp).cint)
  ctx.input_key(KEY_SHIFT, (isKeyDown(win, keyLeftShift) or isKeyDown(win, keyRightShift)).cint)

  if isKeyDown(win, keyLeftControl) or isKeyDown(win, keyRightControl):
    ctx.input_key(KEY_COPY, isKeyDown(win, keyC).cint)
    ctx.input_key(KEY_PASTE, isKeyDown(win, keyP).cint)
    ctx.input_key(KEY_CUT, isKeyDown(win, keyX).cint)
    ctx.input_key(KEY_TEXT_UNDO, isKeyDown(win, keyZ).cint)
    ctx.input_key(KEY_TEXT_REDO, isKeyDown(win, keyR).cint)
    ctx.input_key(KEY_TEXT_WORD_LEFT, isKeyDown(win, keyLeft).cint)
    ctx.input_key(KEY_TEXT_WORD_RIGHT, isKeyDown(win, keyRight).cint)
    ctx.input_key(KEY_TEXT_LINE_START, isKeyDown(win, keyB).cint)
    ctx.input_key(KEY_TEXT_LINE_END, isKeyDown(win, keyE).cint)
  else:
    ctx.input_key(KEY_LEFT, isKeyDown(win, keyLeft).cint)
    ctx.input_key(KEY_RIGHT, isKeyDown(win, keyRight).cint)
    ctx.input_key(KEY_COPY, 0)
    ctx.input_key(KEY_PASTE, 0)
    ctx.input_key(KEY_CUT, 0)
    ctx.input_key(KEY_SHIFT, 0)

  (x, y) = win.cursorPos
  ctx.input_motion(x.cint, y.cint)

  if ctx.input.mouse.grabbed != 0.cuchar:
    win.cursorPos = (ctx.input.mouse.prev.x.float64, ctx.input.mouse.prev.y.float64)
    ctx.input.mouse.pos.x = ctx.input.mouse.prev.x
    ctx.input.mouse.pos.y = ctx.input.mouse.prev.y

  ctx.input_button(BUTTON_LEFT, x.cint, y.cint, win.mouseBtnDown(mbLeft).cint)
  ctx.input_button(BUTTON_MIDDLE, x.cint, y.cint, win.mouseBtnDown(mbMiddle).cint)
  ctx.input_button(BUTTON_RIGHT, x.cint, y.cint, win.mouseBtnDown(mbRight).cint)
  ctx.input_scroll(glfw_nk.scroll)
  input_end(addr(glfw_nk.ctx))

  glfw_nk.text_len = 0
  glfw_nk.scroll = 0

proc shutdown*() =
  let dev: ptr Device = addr(glfw_nk.ogl)

  clear(addr(glfw_nk.atlas))
  free(addr(glfw_nk.ctx))
  glDeleteTextures(1, addr(dev.font_tex))
  free(addr(dev.cmds))
  zeroMem(addr(glfw_nk), sizeof(glfw_nk))
