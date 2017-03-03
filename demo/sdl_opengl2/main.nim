## nuklear - v1.09 - public domain

import
  ../../nuklear, nuklear_sdl_gl2, sdl2, sdl2/gfx, opengl


const
  WINDOW_WIDTH = 1200
  WINDOW_HEIGHT = 800
  MAX_VERTEX_MEMORY = 512 * 1024
  MAX_ELEMENT_MEMORY = 128 * 1024

type Difficulty = enum
  EASY, HARD

## ===============================================================
##
##                           EXAMPLE
##
## ===============================================================
## This are some code examples to provide a small overview of what can be
##  done with this library. To try out an example uncomment the import
##  and the corresponding function.
import "../style.nim"
# import "../calculator.nim"
# import "../overview.nim"
import "../node_editor.nim"

## ===============================================================
##
##                           DEMO
##
## ===============================================================

if isMainModule:

  ## Platform
  var
    winWidth: cint
    winHeight: cint
    running: bool = true

  ## SDL setup
  discard setHint("SDL_HINT_VIDEO_HIGHDPI_DISABLED", "0")

  init(INIT_VIDEO)

  discard glSetAttribute(SDL_GL_DOUBLEBUFFER, 1)
  discard glSetAttribute(SDL_GL_DEPTH_SIZE, 24)
  discard glSetAttribute(SDL_GL_STENCIL_SIZE, 8)
  discard glSetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2)
  discard glSetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2)

  let
    win: WindowPtr = createWindow("Demo", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                                     WINDOW_WIDTH, WINDOW_HEIGHT, SDL_WINDOW_OPENGL or
                                      SDL_WINDOW_SHOWN or SDL_WINDOW_ALLOW_HIGHDPI)
    glContext: GLContextPtr = glCreateContext(win)

  getSize(win, winWidth, winHeight)

  ## GUI
  let ctx: PContext = initContext(win)

  ## Load Fonts: if none of these are loaded a default font will be used
  ## Load Cursor: if you uncomment cursor loading please hide the cursor

  var atlas: ptr FontAtlas
  atlas.fontStashBegin()

  # var
  #   droid: ptr Font = atlas.addFromFile("../../extra_font/DroidSans.ttf", 14'f)
  #   roboto: ptr Font = font_atlas_add_from_file(atlas, "../../extra_font/Roboto-Regular.ttf", 16'f, nil)
  #   future: ptr Font = font_atlas_add_from_file(atlas, "../../extra_font/kenvector_future_thin.ttf", 13, nil)
  #   clean: ptr Font = font_atlas_add_from_file(atlas, "../../extra_font/ProggyClean.ttf", 12, nil)
  #   tiny: ptr Font = font_atlas_add_from_file(atlas, "../../extra_font/ProggyTiny.ttf", 10, nil)
  #   cousine: ptr Font = font_atlas_add_from_file(atlas, "../../extra_font/Cousine-Regular.ttf", 13, nil)

  fontStashEnd()

  # style_load_all_cursors(ctx, addr(atlas.cursors[CURSOR_ARROW]))
  # ctx.style_set_font(addr(droid.handle))

  ## style.nim
  ctx.setStyle(THEME_WHITE)
  # ctx.setStyle(THEME_RED)
  # ctx.setStyle(THEME_BLUE)
  # ctx.setStyle(THEME_DARK)

  var
    background: nuklear.Color = rgb(28, 48, 62)
    op: Difficulty = EASY
    property: cint = 20

  var
    evt: Event
    layout: Panel
    combo: Panel
    bg: array[4, cfloat]

  let windowFlags = WINDOW_BORDER or WINDOW_MOVABLE or WINDOW_SCALABLE or WINDOW_MINIMIZABLE or WINDOW_TITLE

  while running:

    ## Input
    ctx.inputBegin()

    while pollEvent(evt):
      if evt.kind == EventType.QuitEvent:
        shutdown()
        glDeleteContext(glContext)
        destroyWindow(win)
        sdl2.quit()
        quit 0

      handleEvent(evt)

    ctx.inputEnd()

    ## GUI
    begin(ctx, layout, "Demo", newRect(50, 50, 210, 250), windowFlags):

      ctx.layoutRowStatic(30, 80, 1)
      if ctx.buttonLabel("Button") != 0: stdout.write("Button pressed\n")

      ctx.layoutRowDynamic(30, 2)
      if ctx.optionLabel("Easy", (op == EASY).cint) != 0: op = EASY
      if ctx.optionLabel("Hard", (op == HARD).cint) != 0: op = HARD

      ctx.layoutRowDynamic(25, 1)
      ctx.propertyInt("Compression:", 0, addr(property), 100, 10, 1)

      ctx.layoutRowDynamic(20, 1)
      ctx.label("Background:", Flags(TextAlignment.TEXT_LEFT))

      ctx.layoutRowDynamic(25, 1)
      if ctx.comboBeginColor(addr(combo), background, 400) != 0:

        ctx.layoutRowDynamic(120, 1)
        background = ctx.colorPicker(background, ColorFormat.RGBA)

        ctx.layoutRowDynamic(25, 1)
        background.r = ctx.propertyi("#R:", 0, background.r.cint, 255, 1, 1).byte
        background.g = ctx.propertyi("#G:", 0, background.g.cint, 255, 1, 1).byte
        background.b = ctx.propertyi("#B:", 0, background.b.cint, 255, 1, 1).byte
        background.a = ctx.propertyi("#A:", 0, background.a.cint, 255, 1, 1).byte

        ctx.comboEnd()

    ## -------------- EXAMPLES ----------------
    # calculator(ctx)
    # discard overview(ctx)
    discard initNodeEditor(ctx)
    # initNodeEditor(ctx, ctx)
    ## ----------------------------------------

    ## Draw
    colorFv(addr(bg[0]), background)

    getSize(win, winWidth, winHeight)
    glViewport(0, 0, winWidth, winHeight)
    glClear(GL_COLOR_BUFFER_BIT)
    glClearColor(bg[0], bg[1], bg[2], bg[3])

    ## IMPORTANT: `render` modifies some global OpenGL state
    ##          with blending, scissor, face culling, depth test and viewport and
    ##          defaults everything back into a default state.
    ##          Make sure to either a.) save and restore or b.) reset your own state after
    ##          rendering the UI.

    render(ANTI_ALIASING_ON, MAX_VERTEX_MEMORY, MAX_ELEMENT_MEMORY)
    glSwapWindow(win)

  shutdown()
  glDeleteContext(glContext)
  destroyWindow(win)
  sdl2.quit()
