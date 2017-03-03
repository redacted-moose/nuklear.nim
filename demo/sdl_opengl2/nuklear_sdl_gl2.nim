##
##  Nuklear - v1.00 - public domain
##  no warrenty implied; use at your own risk.
##  authored from 2015-2016 by Micha Mettke
##

##
##  ==============================================================
##
##                           IMPLEMENTATION
##
##  ==============================================================
##

import ../../nuklear, sdl2, sdl2/gfx, opengl

type
  Device = object
    cmds: Buffer
    null: DrawNullTexture
    font_tex: GLuint

  Vertex = object
    position: array[2, cfloat]
    uv: array[2, cfloat]
    col: array[4, byte]

  Sdl = object
    win: WindowPtr
    ogl: Device
    ctx: Context
    atlas: FontAtlas


var sdl: Sdl

let
  dev: ptr Device = addr(sdl.ogl)
  ctx: PContext = addr(sdl.ctx)
  atlas: ptr FontAtlas = addr(sdl.atlas)

var
  vertex_layout = [initDrawVertexLayoutElement(nkVertexPosition, FORMAT_FLOAT, offsetof(Vertex, position)),
                   initDrawVertexLayoutElement(nkVertexTexcoord, FORMAT_FLOAT, offsetof(Vertex, uv)),
                   initDrawVertexLayoutElement(nkVertexColor, FORMAT_R8G8B8A8, offsetof(Vertex, col)),
                   VERTEX_LAYOUT_END]
                  #  initDrawVertexLayoutElement(VERTEX_LAYOUT_END[0].DrawVertexLayoutAttribute, VERTEX_LAYOUT_END[1].DrawVertexLayoutFormat, VERTEX_LAYOUT_END[2].csize)]

proc deviceUploadAtlas(image: pointer; width: int; height: int) =
  glGenTextures(1, addr(dev.font_tex))
  glBindTexture(GL_TEXTURE_2D, dev.font_tex)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexImage2D(GL_TEXTURE_2D, 0, GLint(GL_RGBA), GLsizei(width),
               GLsizei(height), 0, GL_RGBA, GL_UNSIGNED_BYTE, image)

proc render*(AA: AntiAliasing; maxVertexBuffer: int; maxElementBuffer: int) =
  ## setup global state
  # let dev: ptr Device = addr(sdl.ogl)

  var
    width: cint
    height: cint
    display_width: cint
    display_height: cint

  var scale: Vec2

  getSize(sdl.win, width, height)
  glGetDrawableSize(sdl.win, display_width, display_height)
  scale.x = display_width.cfloat / width.cfloat
  scale.y = display_height.cfloat / height.cfloat

  glPushAttrib(GL_ENABLE_BIT or GL_COLOR_BUFFER_BIT or GL_TRANSFORM_BIT)

  glDisable(GL_CULL_FACE)
  glDisable(GL_DEPTH_TEST)

  glEnable(GL_SCISSOR_TEST)
  glEnable(GL_BLEND)
  glEnable(GL_TEXTURE_2D)

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

  ## setup viewport/project
  glViewport(0, 0, GLsizei(display_width), GLsizei(display_height))
  glMatrixMode(GL_PROJECTION)
  glPushMatrix()
  glLoadIdentity()

  glOrtho(0.0, GLdouble(width), GLdouble(height), 0.0, - 1.0, 1.0)
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
    offset: ptr DrawIndex = nil
    vbuf: Buffer
    ebuf: Buffer

  let
    vertexBuffer = addr(vbuf)
    elementBuffer = addr(ebuf)

  ## fill converting configuration
  var config: ConvertConfig

  # zeroMem(addr(config), sizeof(config))
  config.vertex_layout = addr(vertex_layout[0])
  config.vertex_size = sizeof(Vertex)
  # TODO: fix ALIGNOF
  # config.vertex_alignment = ALIGNOF(vertex)
  config.null = dev.null
  config.circle_segment_count = 22
  config.curve_segment_count = 22
  config.arc_segment_count = 22
  config.global_alpha = 1.0
  config.shape_AA = AA
  config.line_AA = AA

  ## convert shapes into vertexes
  buffer_init_default(vertexBuffer)
  buffer_init_default(elementBuffer)
  ctx.convert(addr(dev.cmds), vertexBuffer, elementBuffer, addr(config))

  ## setup vertex buffer pointer
  var vertices: ptr cuchar = cast[ptr cuchar](memoryConst(vertexBuffer))
  glVertexPointer(2, cGL_FLOAT, vs, vertices + vp)
  glTexCoordPointer(2, cGL_FLOAT, vs, vertices + vt)
  glColorPointer(4, GL_UNSIGNED_BYTE, vs, vertices + vc)

  ## iterate over and execute each draw command
  offset = cast[ptr DrawIndex](memoryConst(elementBuffer))
  # draw_foreach(cmd, ctx, addr(dev.cmds)):
  for cmd in ctx.drawCommands(addr(dev.cmds)):
    if cmd.elem_count == 0:
      continue

    glBindTexture(GL_TEXTURE_2D, GLuint(cmd.texture.id))

    glScissor(GLint(cmd.clip_rect.x * scale.x),
              GLint((height.cfloat - (cmd.clip_rect.y + cmd.clip_rect.h)) * scale.y),
              GLint(cmd.clip_rect.w * scale.x),
              GLint(cmd.clip_rect.h * scale.y))

    glDrawElements(GL_TRIANGLES, GLsizei(cmd.elem_count), GL_UNSIGNED_SHORT, offset)

    inc(offset, cmd.elem_count.int)

  ctx.clear()
  vertexBuffer.free()
  elementBuffer.free()

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

proc clipbardPaste(usr: Handle; edit: ptr TextEdit) =
  let text: cstring = getClipboardText()
  if text != nil:
    discard edit.paste(text, len(text).cint)

proc clipbardCopy(usr: Handle; text: cstring; len: cint) =
  discard setClipboardText(text)
  # var str: ptr cstring = nil
  # if len == 0: return
  # # str = cast[cstring](alloc0(cast[csize](len) + 1))
  # str = alloc[cstring](len + 1)
  # if str == nil: return
  # copyMem(str, text, len)
  # str[len] = '\0'
  # discard setClipboardText(str[])
  # # free(str)

proc initContext*(win: WindowPtr): PContext =
  # let ctx = addr(sdl.ctx)

  sdl.win = win
  discard ctx.init_default(nil)

  sdl.ctx.clip.copy = proc(usr: Handle; text: cstring; len: cint) {.cdecl.} =
    clipbardCopy(usr, text, len)
  sdl.ctx.clip.paste = proc(usr: Handle; edit: ptr TextEdit) {.cdecl.} =
    clipbardPaste(usr, edit)
  sdl.ctx.clip.userdata = handlePtr(nil)

  buffer_init_default(addr(dev.cmds))
  loadExtensions()
  return ctx

proc fontStashBegin*(atlas: var ptr FontAtlas) =
  let fontAtlas = addr(sdl.atlas)

  fontAtlas.initDefault()
  fontAtlas.begin()
  atlas = fontAtlas

proc fontStashEnd*() =
  var
    w: cint
    h: cint

  let
    image: pointer = sdl.atlas.bake(w, h, FONT_ATLAS_RGBA32)
    # ctx = addr(sdl.ctx)
    # atlas = addr(sdl.atlas)

  deviceUploadAtlas(image, w, h)
  atlas.`end`(handle_id(sdl.ogl.font_tex.cint), addr(dev.null))

  if sdl.atlas.default_font != nil:
    ctx.style_set_font(addr(atlas.default_font.handle))

proc handleEvent*(evt: Event) =
  # var ctx: PContext = addr(sdl.ctx)

  ## optional grabbing behavior
  if ctx.input.mouse.grab != 0.cuchar:
    discard setRelativeMouseMode(True32)
    ctx.input.mouse.grab = 0.cuchar
  elif ctx.input.mouse.ungrab != 0.cuchar:
    var
      x: cint = ctx.input.mouse.prev.x.cint
      y: cint = ctx.input.mouse.prev.y.cint
    discard setRelativeMouseMode(False32)
    warpMouseInWindow(sdl.win, x, y)
    ctx.input.mouse.ungrab = 0.cuchar
  if evt.kind == EventType.KeyUp or evt.kind == EventType.KeyDown:

    ## key events
    var down: cint = (evt.kind == EventType.KeyDown).cint
    var state: ptr array[0..SDL_NUM_SCANCODES.int, uint8] = getKeyboardState()
    var sym: cint = evt.key.keysym.sym
    if sym == K_RSHIFT or sym == K_LSHIFT:
      ctx.input_key(KEY_SHIFT, down)
    elif sym == K_DELETE:
      ctx.input_key(KEY_DEL, down)
    elif sym == K_RETURN:
      ctx.input_key(KEY_ENTER, down)
    elif sym == K_TAB:
      ctx.input_key(KEY_TAB, down)
    elif sym == K_BACKSPACE:
      ctx.input_key(KEY_BACKSPACE, down)
    elif sym == K_HOME:
      ctx.input_key(KEY_TEXT_START, down)
      ctx.input_key(KEY_SCROLL_START, down)
    elif sym == K_END:
      ctx.input_key(KEY_TEXT_END, down)
      ctx.input_key(KEY_SCROLL_END, down)
    elif sym == K_PAGEDOWN:
      ctx.input_key(KEY_SCROLL_DOWN, down)
    elif sym == K_PAGEUP:
      ctx.input_key(KEY_SCROLL_UP, down)
    elif sym == K_z:
      ctx.input_key(KEY_TEXT_UNDO, (down.bool and state[SDL_SCANCODE_LCTRL.int] != 0).cint)
    elif sym == K_r:
      ctx.input_key(KEY_TEXT_REDO, (down.bool and state[SDL_SCANCODE_LCTRL.int] != 0).cint)
    elif sym == K_c:
      ctx.input_key(KEY_COPY, (down.bool and state[SDL_SCANCODE_LCTRL.int] != 0).cint)
    elif sym == K_v:
      ctx.input_key(KEY_PASTE, (down.bool and state[SDL_SCANCODE_LCTRL.int] != 0).cint)
    elif sym == K_x:
      ctx.input_key(KEY_CUT, (down.bool and state[SDL_SCANCODE_LCTRL.int] != 0).cint)
    elif sym == K_b:
      ctx.input_key(KEY_TEXT_LINE_START, (down.bool and
          state[SDL_SCANCODE_LCTRL.int] != 0).cint)
    elif sym == K_e:
      ctx.input_key(KEY_TEXT_LINE_END, (down.bool and state[SDL_SCANCODE_LCTRL.int] != 0).cint)
    elif sym == K_LEFT:
      if state[SDL_SCANCODE_LCTRL.int] != 0: ctx.input_key(KEY_TEXT_WORD_LEFT, down)
      else: ctx.input_key(KEY_LEFT, down)
    elif sym == K_RIGHT:
      if state[SDL_SCANCODE_LCTRL.int] != 0:
        ctx.input_key(KEY_TEXT_WORD_RIGHT, down)
      else:
        ctx.input_key(KEY_RIGHT, down)
  elif evt.kind == MouseButtonDown or evt.kind == MouseButtonUp:
    ## mouse button
    var down: cint = (evt.kind == MouseButtonDown).cint
    var
      x: cint = evt.button.x
      y: cint = evt.button.y
    if evt.button.button == sdl2.BUTTON_LEFT:
      ctx.input_button(Buttons.BUTTON_LEFT, x, y, down)
    if evt.button.button == sdl2.BUTTON_MIDDLE:
      ctx.input_button(Buttons.BUTTON_MIDDLE, x, y, down)
    if evt.button.button == sdl2.BUTTON_RIGHT:
      ctx.input_button(Buttons.BUTTON_RIGHT, x, y, down)
  elif evt.kind == MouseMotion:
    if ctx.input.mouse.grabbed != 0.cuchar:
      var
        x: cint = ctx.input.mouse.prev.x.cint
        y: cint = ctx.input.mouse.prev.y.cint
      ctx.input_motion(x + evt.motion.xrel, y + evt.motion.yrel)
    else:
      ctx.input_motion(evt.motion.x, evt.motion.y)
  elif evt.kind == TextInput:
    var glyph: Glyph
    copyMem(addr(glyph), addr(evt.text.text), UTF_SIZE)
    # memcpy(glyph, evt.text.text, UTF_SIZE)
    ctx.input_glyph(glyph)
  elif evt.kind == MouseWheel:
    ctx.input_scroll(evt.wheel.y.cfloat)

proc shutdown*() =
  var dev: ptr Device = addr(sdl.ogl)

  let
    cmds = addr(dev.cmds)
    font_tex = addr(dev.font_tex)

  let
    ctx = addr(sdl.ctx)
    atlas = addr(sdl.atlas)

  atlas.clear()
  ctx.free()
  glDeleteTextures(1, font_tex)
  cmds.free()
  zeroMem(addr(sdl), sizeof(sdl))
