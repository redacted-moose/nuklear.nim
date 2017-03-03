## nuklear - v1.09 - public domain

import
  ../../nuklear, nuklear_glfw_gl2, glfw, opengl

const
  WINDOW_WIDTH = 1200
  WINDOW_HEIGHT = 800
  MAX_VERTEX_BUFFER = 512 * 1024
  MAX_ELEMENT_BUFFER = 128 * 1024

type Difficulty = enum
  EASY, HARD

## ===============================================================
##
##                           EXAMPLE
##
##  ===============================================================
## This are some code examples to provide a small overview of what can be
##  done with this library. To try out an example uncomment the include
##  and the corresponding function.
# import "../style.nim"
# import "../calculator.nim"
# import "../overview.nim"
import "../node_editor.nim"

## ===============================================================
##
##                           DEMO
##
##  ===============================================================

if isMainModule:

  ## Platform
  var
    width: int = 0
    height: int = 0

  ## GLFW
  glfw.init()
  let win = newGlWin((WINDOW_WIDTH, WINDOW_HEIGHT), "Demo")
  win.makeContextCurrent()
  (width, height) = win.size

  ## GUI
  let ctx = initContext(win, INSTALL_CALLBACKS)

  ## Load Fonts: if none of these are loaded a default font will be used
  ## Load Cursor: if you uncomment cursor loading please hide the cursor
  var atlas: ptr FontAtlas
  atlas.fontStashBegin()

  # var
  #   droid: ptr Font = atlas.addFromFile("../../../extra_font/DroidSans.ttf", 14)
  #   roboto: ptr Font = atlas.addFromFile("../../../extra_font/Roboto-Regular.ttf", 14)
  #   future: ptr Font = atlas.addFromFile("../../../extra_font/kenvector_future_thin.ttf", 13)
  #   clean: ptr Font = atlas.addFromFile("../../../extra_font/ProggyClean.ttf", 12)
  #   tiny: ptr Font = atlas.addFromFile("../../../extra_font/ProggyTiny.ttf", 10)
  #   cousine: ptr Font = atlas.addFromFile("../../../extra_font/Cousine-Regular.ttf", 13)

  fontStashEnd()

  # ctx.style_load_all_cursors(addr(atlas.cursors[CURSOR_ARROW]))
  # ctx.style_set_font(addr(tiny.handle))

  ## style.c
  # set_style(ctx, THEME_WHITE)
  # set_style(ctx, THEME_RED)
  # set_style(ctx, THEME_BLUE)
  # set_style(ctx, THEME_DARK)

  var
    background: Color = initColor(28, 48, 62)
    op: Difficulty = EASY
    property: cint = 20

  let windowFlags = WINDOW_BORDER or WINDOW_MOVABLE or WINDOW_SCALABLE or WINDOW_MINIMIZABLE or WINDOW_TITLE

  while not win.shouldClose:
    ## Input
    pollEvents()
    newFrame()

    ## GUI
    var layout: Panel
    begin(ctx, layout, "Demo", newRect(50, 50, 230, 250), windowFlags):

      ctx.layout_row_static(30, 80, 1)
      if ctx.button_label("Button") != 0:
        stdout.write("Button pressed\n")

      ctx.layout_row_dynamic(30, 2)
      if ctx.option_label("Easy", (op == EASY).cint) != 0: op = EASY
      if ctx.option_label("Hard", (op == HARD).cint) != 0: op = HARD

      ctx.layout_row_dynamic(25, 1)
      ctx.propertyInt("Compression:", 0, addr(property), 100, 10, 1)

      var combo: Panel

      ctx.layout_row_dynamic(20, 1)
      ctx.label("Background:", TEXT_LEFT.Flags)

      ctx.layout_row_dynamic(25, 1)
      if ctx.comboBeginColor(addr(combo), background, 400) != 0:
        ctx.layout_row_dynamic(120, 1)
        background = ctx.colorPicker(background, RGBA)

        ctx.layout_row_dynamic(25, 1)
        background.r = propertyi(ctx, "#R:", 0.cint, background.r.cint, 255.cint, 1.cint, 1.cfloat).byte
        background.g = propertyi(ctx, "#G:", 0.cint, background.g.cint, 255.cint, 1.cint, 1.cfloat).byte
        background.b = propertyi(ctx, "#B:", 0.cint, background.b.cint, 255.cint, 1.cint, 1.cfloat).byte
        background.a = propertyi(ctx, "#A:", 0.cint, background.a.cint, 255.cint, 1.cint, 1.cfloat).byte

        ctx.comboEnd()

    ## -------------- EXAMPLES ----------------
    # calculator(ctx)
    # overview(ctx)
    discard ctx.initNodeEditor()
    ## -----------------------------------------

    ## Draw
    var bg: array[4, cfloat]
    color_fv(addr(bg[0]), background)

    (width, height) = win.size
    glViewport(0, 0, GLsizei(width), GLsizei(height))
    glClear(GL_COLOR_BUFFER_BIT)
    glClearColor(bg[0], bg[1], bg[2], bg[3])

    ## IMPORTANT: `render` modifies some global OpenGL state
    ##          with blending, scissor, face culling and depth test and defaults everything
    ##          back into a default state. Make sure to either save and restore or
    ##          reset your own state after drawing rendering the UI.

    render(ANTI_ALIASING_ON, MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER)
    swapBufs(win)

  shutdown()
  terminate()
