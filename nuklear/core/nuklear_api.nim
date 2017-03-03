{.pragma: nuklear, header: "src/nuklear.h".}

from strutils import parseFloat

##  ==============================================================
##
##                           CONSTANTS
##
##  ==============================================================

when defined(fixedTypes):
  {.passC: "-DNK_INCLUDE_FIXED_TYPES".}

when defined(defaultAllocator):
  {.passC: "-DNK_INCLUDE_DEFAULT_ALLOCATOR".}

when defined(standardIo):
  {.passC: "-DNK_INCLUDE_STANDARD_IO".}

when defined(standardVarargs):
  {.passC: "-DNK_INCLUDE_STANDARD_VARARGS".}

when defined(vertexBufferOutput):
  {.passC: "-DNK_INCLUDE_VERTEX_BUFFER_OUTPUT".}

when defined(fontBaking):
  {.passC: "-DNK_INCLUDE_FONT_BAKING".}

when defined(defaultFont):
  {.passC: "-DNK_INCLUDE_DEFAULT_FONT".}

when defined(commandUserdata):
  {.passC: "-DNK_INCLUDE_COMMAND_USERDATA".}

when defined(buttonTriggerOnRelease):
  {.passC: "-DNK_BUTTON_TRIGGER_ON_RELEASE".}

when defined(ASSERT):
  {.passC: "-DNK_ASSERT".}


const
  UtfInvalid* = 0x0000FFFD
  UtfSize* = 4
  ScrollbarHidingTimeout* {.strdefine.}: string = "4.0"

when parseFloat(ScrollbarHidingTimeout) != 4.0:
  {.passC: "-DNK_SCROLLBAR_HIDING_TIMEOUT=" & $ScrollbarHidingTimeout.}


##  ===============================================================
##
##                           BASIC
##
##  ===============================================================

type
  Hash* = cuint
  Flags* = cuint
  Rune* = cuint


## ===========================================================================
##
##                                   API
##
## ===========================================================================

const
  UNDEFINED* = - 1.0

template FLAG(x: untyped): untyped = (1 shl (x))

type
  Color* {.nuklear, importc: "struct nk_color".} = object
    r* {.importc: "r".}: byte
    g* {.importc: "g".}: byte
    b* {.importc: "b".}: byte
    a* {.importc: "a".}: byte

  # Left here for completeness, but not exported
  Colorf {.nuklear, importc: "struct nk_colorf".} = object
    r* {.importc: "r".}: cfloat
    g* {.importc: "g".}: cfloat
    b* {.importc: "b".}: cfloat
    a* {.importc: "a".}: cfloat

  Vec2* {.nuklear, importc: "struct nk_vec2".} = object
    x* {.importc: "x".}: cfloat
    y* {.importc: "y".}: cfloat

  Vec2i* {.nuklear, importc: "struct nk_vec2i".} = object
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort

  Rect* {.nuklear, importc: "struct nk_rect".} = object
    x* {.importc: "x".}: cfloat
    y* {.importc: "y".}: cfloat
    w* {.importc: "w".}: cfloat
    h* {.importc: "h".}: cfloat

  Recti* {.nuklear, importc: "struct nk_recti".} = object
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort
    w* {.importc: "w".}: cshort
    h* {.importc: "h".}: cshort

  Glyph* = array[UtfSize, char]

  Handle* {.nuklear, importc: "nk_handle".} = object {.union.}
    `ptr`* {.importc: "ptr".}: pointer
    id* {.importc: "id".}: cint

  Image* {.bycopy, importc: "struct nk_image", header: "src/nuklear.h".} = object
    handle* {.importc: "handle".}: Handle
    w* {.importc: "w".}: cushort
    h* {.importc: "h".}: cushort
    region* {.importc: "region".}: array[4, cushort]

  Cursor* {.importc: "struct nk_cursor", header: "src/nuklear.h".} = object
    img* {.importc: "img".}: Image
    size* {.importc: "size".}: Vec2
    offset* {.importc: "offset".}: Vec2

  Scroll* {.importc: "struct nk_scroll", header: "src/nuklear.h".} = object
    x* {.importc: "x".}: cushort
    y* {.importc: "y".}: cushort

  Heading* {.size: sizeof(cint).} = enum
    UP, RIGHT, DOWN, LEFT


type
  ButtonBehavior* {.size: sizeof(cint).} = enum
    BUTTON_DEFAULT, BUTTON_REPEATER


type
  Modify* {.size: sizeof(cint).} = enum
    FIXED = false, MODIFIABLE = true


type
  Orientation* {.size: sizeof(cint).} = enum
    nkVertical, nkHorizontal


type
  CollapseStates* {.size: sizeof(cint).} = enum
    MINIMIZED = false, MAXIMIZED = true


type
  ShowStates* {.size: sizeof(cint).} = enum
    HIDDEN = false, SHOWN = true


type
  ChartType* {.size: sizeof(cint).} = enum
    CHART_LINES, CHART_COLUMN, CHART_MAX


type
  ChartEvent* {.size: sizeof(cint).} = enum
    CHART_HOVERING = 0x00000001, CHART_CLICKED = 0x00000002


type
  ColorFormat* {.size: sizeof(cint).} = enum
    RGB, RGBA


type
  PopupType* {.size: sizeof(cint).} = enum
    POPUP_STATIC, POPUP_DYNAMIC


type
  LayoutFormat* {.size: sizeof(cint).} = enum
    DYNAMIC, STATIC


type
  AntiAliasing* {.size: sizeof(cint).} = enum
    ANTI_ALIASING_OFF, ANTI_ALIASING_ON

# type
#   PluginAlloc* = proc (a2: Handle; old: pointer; a4: csize): pointer {.cdecl.}
#   PluginFree* = proc (a2: Handle; old: pointer) {.cdecl.}
#   Allocator* {.importc: "struct nk_allocator", header: "src/nuklear.h".} = object
#     userdata* {.importc: "userdata".}: Handle
#     alloc* {.importc: "alloc".}: PluginAlloc
#     free* {.importc: "free".}: PluginFree

type
  DrawNullTexture* {.importc: "struct nk_draw_null_texture", header: "src/nuklear.h".} = object
    texture* {.importc: "texture".}: Handle ## texture handle to a texture with a white pixel
    uv* {.importc: "uv".}: Vec2  ## coordinates to a white pixel in the texture

type
  SymbolType* {.size: sizeof(cint).} = enum
    SYMBOL_NONE, SYMBOL_X, SYMBOL_UNDERSCORE, SYMBOL_CIRCLE_SOLID,
    SYMBOL_CIRCLE_OUTLINE, SYMBOL_RECT_SOLID, SYMBOL_RECT_OUTLINE,
    SYMBOL_TRIANGLE_UP, SYMBOL_TRIANGLE_DOWN, SYMBOL_TRIANGLE_LEFT,
    SYMBOL_TRIANGLE_RIGHT, SYMBOL_PLUS, SYMBOL_MINUS, SYMBOL_MAX


type
  Keys* {.size: sizeof(cint).} = enum
    KEY_NONE, KEY_SHIFT, KEY_CTRL, KEY_DEL, KEY_ENTER, KEY_TAB, KEY_BACKSPACE,
    KEY_COPY, KEY_CUT, KEY_PASTE, KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT,
    ## Shortcuts: text field
    KEY_TEXT_INSERT_MODE, KEY_TEXT_REPLACE_MODE, KEY_TEXT_RESET_MODE,
    KEY_TEXT_LINE_START, KEY_TEXT_LINE_END, KEY_TEXT_START, KEY_TEXT_END,
    KEY_TEXT_UNDO, KEY_TEXT_REDO, KEY_TEXT_WORD_LEFT, KEY_TEXT_WORD_RIGHT,
    ## Shortcuts: Scrollbar
    KEY_SCROLL_START, KEY_SCROLL_END, KEY_SCROLL_DOWN, KEY_SCROLL_UP, KEY_MAX


type
  Buttons* {.size: sizeof(cint).} = enum
    BUTTON_LEFT, BUTTON_MIDDLE, BUTTON_RIGHT, BUTTON_MAX


type
  StyleColors* {.size: sizeof(cint).} = enum
    COLOR_TEXT, COLOR_WINDOW, COLOR_HEADER, COLOR_BORDER, COLOR_BUTTON,
    COLOR_BUTTON_HOVER, COLOR_BUTTON_ACTIVE, COLOR_TOGGLE, COLOR_TOGGLE_HOVER,
    COLOR_TOGGLE_CURSOR, COLOR_SELECT, COLOR_SELECT_ACTIVE, COLOR_SLIDER,
    COLOR_SLIDER_CURSOR, COLOR_SLIDER_CURSOR_HOVER, COLOR_SLIDER_CURSOR_ACTIVE,
    COLOR_PROPERTY, COLOR_EDIT, COLOR_EDIT_CURSOR, COLOR_COMBO, COLOR_CHART,
    COLOR_CHART_COLOR, COLOR_CHART_COLOR_HIGHLIGHT, COLOR_SCROLLBAR,
    COLOR_SCROLLBAR_CURSOR, COLOR_SCROLLBAR_CURSOR_HOVER,
    COLOR_SCROLLBAR_CURSOR_ACTIVE, COLOR_TAB_HEADER, COLOR_COUNT


type
  StyleCursor* {.size: sizeof(cint).} = enum
    CURSOR_ARROW, CURSOR_TEXT, CURSOR_MOVE, CURSOR_RESIZE_VERTICAL,
    CURSOR_RESIZE_HORIZONTAL, CURSOR_RESIZE_TOP_LEFT_DOWN_RIGHT,
    CURSOR_RESIZE_TOP_RIGHT_DOWN_LEFT, CURSOR_COUNT


type
  WidgetLayoutStates* {.size: sizeof(cint).} = enum
    WIDGET_INVALID,           ## The widget cannot be seen and is completely out of view
    WIDGET_VALID,             ## The widget is completely inside the window and can be updated and drawn
    WIDGET_ROM                ## The widget is partially visible and cannot be updated


## widget states
type
  WidgetStates* {.size: sizeof(cint).} = enum
    WIDGET_STATE_MODIFIED = FLAG(1),
    WIDGET_STATE_INACTIVE = FLAG(2),           ## widget is neither active nor hovered
    WIDGET_STATE_ENTERED = FLAG(3),            ## widget has been hovered on the current frame
    WIDGET_STATE_HOVER = FLAG(4),              ## widget is being hovered
    # WIDGET_STATE_HOVERED = WIDGET_STATE_HOVER or WIDGET_STATE_MODIFIED, ## widget is being hovered
    WIDGET_STATE_HOVERED = FLAG(4) or FLAG(1), ## widget is being hovered
    WIDGET_STATE_ACTIVED = FLAG(5),            ## widget is currently activated
    WIDGET_STATE_ACTIVE = FLAG(5) or FLAG(1)
    WIDGET_STATE_LEFT = FLAG(6),               ## widget is from this frame on not hovered anymore

## text alignment
type
  TextAlign* {.size: sizeof(cint).} = enum
    TEXT_ALIGN_LEFT = 0x00000001,
    TEXT_ALIGN_CENTERED = 0x00000002,
    TEXT_ALIGN_RIGHT = 0x00000004,
    TEXT_ALIGN_TOP = 0x00000008,
    TEXT_ALIGN_MIDDLE = 0x00000010,
    TEXT_ALIGN_BOTTOM = 0x00000020


type
  TextAlignment* {.size: sizeof(cint).} = enum
    # TEXT_LEFT = TEXT_ALIGN_MIDDLE or TEXT_ALIGN_LEFT,
    TEXT_LEFT = 0x00000010 or 0x00000001,
    # TEXT_CENTERED = TEXT_ALIGN_MIDDLE or TEXT_ALIGN_CENTERED,
    TEXT_CENTERED = 0x00000010 or 0x00000002,
    # TEXT_RIGHT = TEXT_ALIGN_MIDDLE or TEXT_ALIGN_RIGHT
    TEXT_RIGHT = 0x00000010 or 0x00000004


type
  EditFlags* {.size: sizeof(cint).} = enum
    EDIT_DEFAULT = 0,
    EDIT_READ_ONLY = FLAG(0),
    EDIT_AUTO_SELECT = FLAG(1),
    EDIT_SIG_ENTER = FLAG(2),
    EDIT_ALLOW_TAB = FLAG(3),
    EDIT_NO_CURSOR = FLAG(4),
    EDIT_SELECTABLE = FLAG(5),
    EDIT_CLIPBOARD = FLAG(6),
    EDIT_CTRL_ENTER_NEWLINE = FLAG(7),
    EDIT_NO_HORIZONTAL_SCROLL = FLAG(8),
    EDIT_ALWAYS_INSERT_MODE = FLAG(9),
    EDIT_MULTILINE = FLAG(11),
    EDIT_GOTO_END_ON_ACTIVATE = FLAG(12)


type
  EditTypes* {.size: sizeof(cint).} = enum
    EDIT_SIMPLE = EDIT_ALWAYS_INSERT_MODE,
    # EDIT_FIELD = EDIT_SIMPLE or EDIT_SELECTABLE or EDIT_CLIPBOARD,
    EDIT_FIELD = FLAG(9) or FLAG(5) or FLAG(6),
    # EDIT_EDITOR = EDIT_SELECTABLE or EDIT_MULTILINE or EDIT_ALLOW_TAB or EDIT_CLIPBOARD
    EDIT_EDITOR = FLAG(5) or FLAG(11) or FLAG(3) or FLAG(6)
    # EDIT_BOX = EDIT_ALWAYS_INSERT_MODE or EDIT_SELECTABLE or EDIT_MULTILINE or EDIT_ALLOW_TAB or EDIT_CLIPBOARD,
    EDIT_BOX = FLAG(9) or FLAG(5) or FLAG(11) or FLAG(3) or FLAG(6),


type
  EditEvents* {.size: sizeof(cint).} = enum
    EDIT_ACTIVE = FLAG(0),      ## edit widget is currently being modified
    EDIT_INACTIVE = FLAG(1),    ## edit widget is not active and is not being modified
    EDIT_ACTIVATED = FLAG(2),   ## edit widget went from state inactive to state active
    EDIT_DEACTIVATED = FLAG(3), ## edit widget went from state active to state inactive
    EDIT_COMMITED = FLAG(4)     ## edit widget has received an enter and lost focus


type
  PanelFlags* {.size: sizeof(cint).} = enum
    WINDOW_BORDER = FLAG(0),           ## Draws a border around the window to visually separate the window * from the background
    WINDOW_MOVABLE = FLAG(1),          ## The movable flag indicates that a window can be moved by user input or * by dragging the window header
    WINDOW_SCALABLE = FLAG(2),         ## The scalable flag indicates that a window can be scaled by user input * by dragging a scaler icon at the button of the window
    WINDOW_CLOSABLE = FLAG(3),         ## adds a closable icon into the header
    WINDOW_MINIMIZABLE = FLAG(4),      ## adds a minimize icon into the header
    WINDOW_NO_SCROLLBAR = FLAG(5),     ## Removes the scrollbar from the window
    WINDOW_TITLE = FLAG(6),            ## Forces a header at the top at the window showing the title
    WINDOW_SCROLL_AUTO_HIDE = FLAG(7), ## Automatically hides the window scrollbar if no user interaction
    WINDOW_BACKGROUND = FLAG(8)        ## Always keep window in the background


## color (conversion user --> nuklear)
proc rgb*(r: cint; g: cint; b: cint): Color {.nuklear, importc: "nk_rgb".}
proc rgbIv*(rgb: ptr cint): Color {.nuklear, importc: "nk_rgb_iv".}
proc rgbBv*(rgb: ptr byte): Color {.nuklear, importc: "nk_rgb_bv".}
proc rgbF*(r: cfloat; g: cfloat; b: cfloat): Color {.nuklear, importc: "nk_rgb_f".}
proc rgbFv*(rgb: ptr cfloat): Color {.nuklear, importc: "nk_rgb_fv".}
proc rgbHex*(rgb: cstring): Color {.nuklear, importc: "nk_rgb_hex".}
proc rgba*(r: cint; g: cint; b: cint; a: cint): Color {.cdecl, importc: "nk_rgba", header: "src/nuklear.h".}
proc rgbaU32*(a2: uint): Color {.cdecl, importc: "nk_rgba_u32", header: "src/nuklear.h".}
proc rgbaIv*(rgba: ptr cint): Color {.cdecl, importc: "nk_rgba_iv", header: "src/nuklear.h".}
proc rgbaBv*(rgba: ptr byte): Color {.cdecl, importc: "nk_rgba_bv", header: "src/nuklear.h".}
proc rgbaF*(r: cfloat; g: cfloat; b: cfloat; a: cfloat): Color {.cdecl,importc: "nk_rgba_f", header: "src/nuklear.h".}
proc rgbaFv*(rgba: ptr cfloat): Color {.cdecl, importc: "nk_rgba_fv", header: "src/nuklear.h".}
proc rgbaHex*(rgb: cstring): Color {.cdecl, importc: "nk_rgba_hex", header: "src/nuklear.h".}
proc hsv*(h: cint; s: cint; v: cint): Color {.cdecl, importc: "nk_hsv", header: "src/nuklear.h".}
proc hsvFv*(hsv: ptr cint): Color {.cdecl, importc: "nk_hsv_iv", header: "src/nuklear.h".}
proc hsvBv*(hsv: ptr byte): Color {.cdecl, importc: "nk_hsv_bv", header: "src/nuklear.h".}
proc hsvF*(h: cfloat; s: cfloat; v: cfloat): Color {.cdecl, importc: "nk_hsv_f", header: "src/nuklear.h".}
proc hsvFv*(hsv: ptr cfloat): Color {.cdecl, importc: "nk_hsv_fv", header: "src/nuklear.h".}
proc hsva*(h: cint; s: cint; v: cint; a: cint): Color {.cdecl, importc: "nk_hsva", header: "src/nuklear.h".}
proc hsvaFv*(hsva: ptr cint): Color {.cdecl, importc: "nk_hsva_iv", header: "src/nuklear.h".}
proc hsvaBv*(hsva: ptr byte): Color {.cdecl, importc: "nk_hsva_bv", header: "src/nuklear.h".}
proc hsvaF*(h: cfloat; s: cfloat; v: cfloat; a: cfloat): Color {.cdecl, importc: "nk_hsva_f", header: "src/nuklear.h".}
proc hsvaFv*(hsva: ptr cfloat): Color {.cdecl, importc: "nk_hsva_fv", header: "src/nuklear.h".}

## color (conversion nuklear --> user)
proc colorF*(r: ptr cfloat; g: ptr cfloat; b: ptr cfloat; a: ptr cfloat; a6: Color)
  {.cdecl, importc: "nk_color_f", header: "src/nuklear.h".}
proc colorFv*(rgba_out: ptr cfloat; a3: Color) {.nuklear, importc: "nk_color_fv".}
proc colorU32*(a2: Color): cuint {.nuklear, importc: "nk_color_u32".}
proc colorHexRgba*(output: cstring; a3: Color) {.cdecl,
    importc: "nk_color_hex_rgba", header: "src/nuklear.h".}
proc colorHexRgb*(output: cstring; a3: Color) {.cdecl, importc: "nk_color_hex_rgb",
    header: "src/nuklear.h".}
proc colorHsvI*(out_h: ptr cint; out_s: ptr cint; out_v: ptr cint; a5: Color) {.cdecl,
    importc: "nk_color_hsv_i", header: "src/nuklear.h".}
proc colorHsvB*(out_h: ptr byte; out_s: ptr byte; out_v: ptr byte; a5: Color) {.cdecl,
    importc: "nk_color_hsv_b", header: "src/nuklear.h".}
proc colorHsvIv*(hsv_out: ptr cint; a3: Color) {.cdecl, importc: "nk_color_hsv_iv",
    header: "src/nuklear.h".}
proc colorHsvBv*(hsv_out: ptr byte; a3: Color) {.cdecl, importc: "nk_color_hsv_bv",
    header: "src/nuklear.h".}
proc colorHsvF*(out_h: ptr cfloat; out_s: ptr cfloat; out_v: ptr cfloat; a5: Color) {.
    cdecl, importc: "nk_color_hsv_f", header: "src/nuklear.h".}
proc colorHsvFv*(hsv_out: ptr cfloat; a3: Color) {.cdecl, importc: "nk_color_hsv_fv",
    header: "src/nuklear.h".}
proc colorHsvaI*(h: ptr cint; s: ptr cint; v: ptr cint; a: ptr cint; a6: Color) {.cdecl,
    importc: "nk_color_hsva_i", header: "src/nuklear.h".}
proc colorHsvaB*(h: ptr byte; s: ptr byte; v: ptr byte; a: ptr byte; a6: Color)
  {.cdecl, importc: "nk_color_hsva_b", header: "src/nuklear.h".}
proc colorHsvaIv*(hsva_out: ptr cint; a3: Color) {.cdecl,
    importc: "nk_color_hsva_iv", header: "src/nuklear.h".}
proc colorHsvaBv*(hsva_out: ptr byte; a3: Color) {.cdecl,
    importc: "nk_color_hsva_bv", header: "src/nuklear.h".}
proc colorHsvaF*(out_h: ptr cfloat; out_s: ptr cfloat; out_v: ptr cfloat;
                  out_a: ptr cfloat; a6: Color) {.cdecl, importc: "nk_color_hsva_f",
    header: "src/nuklear.h".}
proc colorHsvaFv*(hsva_out: ptr cfloat; a3: Color) {.cdecl,
    importc: "nk_color_hsva_fv", header: "src/nuklear.h".}

## image
proc handlePtr*(a2: pointer): Handle {.cdecl, importc: "nk_handle_ptr",
                                    header: "src/nuklear.h".}
proc handleId*(a2: cint): Handle {.cdecl, importc: "nk_handle_id", header: "src/nuklear.h".}
proc imageHandle*(a2: Handle): Image {.cdecl, importc: "nk_image_handle",
                                    header: "src/nuklear.h".}
proc imagePtr*(a2: pointer): Image {.cdecl, importc: "nk_image_ptr",
                                  header: "src/nuklear.h".}
proc imageId*(a2: cint): Image {.cdecl, importc: "nk_image_id", header: "src/nuklear.h".}
proc isSubimage*(img: ptr Image): cint {.cdecl,
    importc: "nk_image_is_subimage", header: "src/nuklear.h".}
proc subimagePtr*(a2: pointer; w: cushort; h: cushort; sub_region: Rect): Image {.cdecl,
    importc: "nk_subimage_ptr", header: "src/nuklear.h".}
proc subimageId*(a2: cint; w: cushort; h: cushort; sub_region: Rect): Image {.cdecl,
    importc: "nk_subimage_id", header: "src/nuklear.h".}
proc subimageHandle*(a2: Handle; w: cushort; h: cushort; sub_region: Rect): Image {.
    cdecl, importc: "nk_subimage_handle", header: "src/nuklear.h".}

## math
proc murmurHash*(key: pointer; len: cint; seed: Hash): Hash {.cdecl,
    importc: "nk_murmur_hash", header: "src/nuklear.h".}
proc triangleFromDirection*(result: ptr Vec2; r: Rect; pad_x: cfloat; pad_y: cfloat;
                             a6: Heading) {.cdecl,
    importc: "nk_triangle_from_direction", header: "src/nuklear.h".}
proc vec2*(x: cfloat; y: cfloat): Vec2 {.cdecl, importc: "nk_vec2", header: "src/nuklear.h".}
proc vec2i*(x: cint; y: cint): Vec2 {.cdecl, importc: "nk_vec2i", header: "src/nuklear.h".}
proc vec2v*(xy: ptr cfloat): Vec2 {.cdecl, importc: "nk_vec2v", header: "src/nuklear.h".}
proc vec2iv*(xy: ptr cint): Vec2 {.cdecl, importc: "nk_vec2iv", header: "src/nuklear.h".}
proc getNullRect*(): Rect {.cdecl, importc: "nk_get_null_rect", header: "src/nuklear.h".}
proc rect*(x: cfloat; y: cfloat; w: cfloat; h: cfloat): Rect {.cdecl, importc: "nk_rect",
    header: "src/nuklear.h".}
proc recti*(x: cint; y: cint; w: cint; h: cint): Rect {.cdecl, importc: "nk_recti",
    header: "src/nuklear.h".}
proc recta*(pos: Vec2; size: Vec2): Rect {.cdecl, importc: "nk_recta",
                                     header: "src/nuklear.h".}
proc rectv*(xywh: ptr cfloat): Rect {.cdecl, importc: "nk_rectv", header: "src/nuklear.h".}
proc rectiv*(xywh: ptr cint): Rect {.cdecl, importc: "nk_rectiv", header: "src/nuklear.h".}
proc pos*(a2: Rect): Vec2 {.cdecl, importc: "nk_rect_pos", header: "src/nuklear.h".}
proc size*(a2: Rect): Vec2 {.cdecl, importc: "nk_rect_size", header: "src/nuklear.h".}

## string
proc strlen*(str: cstring): cint {.cdecl, importc: "nk_strlen", header: "src/nuklear.h".}
proc stricmp*(s1: cstring; s2: cstring): cint {.cdecl, importc: "nk_stricmp",
    header: "src/nuklear.h".}
proc stricmpn*(s1: cstring; s2: cstring; n: cint): cint {.cdecl, importc: "nk_stricmpn",
    header: "src/nuklear.h".}
proc strtoi*(str: cstring; endptr: cstringArray): cint {.cdecl, importc: "nk_strtoi",
    header: "src/nuklear.h".}
proc strtof*(str: cstring; endptr: cstringArray): cfloat {.cdecl, importc: "nk_strtof",
    header: "src/nuklear.h".}
proc strtod*(str: cstring; endptr: cstringArray): cdouble {.cdecl,
    importc: "nk_strtod", header: "src/nuklear.h".}
proc strfilter*(text: cstring; regexp: cstring): cint {.cdecl, importc: "nk_strfilter",
    header: "src/nuklear.h".}
proc strmatchFuzzyString*(str: cstring; pattern: cstring; out_score: ptr cint): cint {.
    cdecl, importc: "nk_strmatch_fuzzy_string", header: "src/nuklear.h".}
proc strmatchFuzzyText*(txt: cstring; txt_len: cint; pattern: cstring;
                         out_score: ptr cint): cint {.cdecl,
    importc: "nk_strmatch_fuzzy_text", header: "src/nuklear.h".}
when defined(standardVarargs):
  proc strfmt*(buf: cstring; len: cint; fmt: cstring): cint {.varargs, cdecl,
      importc: "nk_strfmt", header: "src/nuklear.h".}

## UTF-8
proc utfDecode*(a2: cstring; a3: ptr Rune; a4: cint): cint {.cdecl,
    importc: "nk_utf_decode", header: "src/nuklear.h".}
proc utfEncode*(a2: Rune; a3: cstring; a4: cint): cint {.cdecl,
    importc: "nk_utf_encode", header: "src/nuklear.h".}
proc utfLen*(a2: cstring; byte_len: cint): cint {.cdecl, importc: "nk_utf_len",
    header: "src/nuklear.h".}
proc utfAt*(buffer: cstring; length: cint; index: cint; unicode: ptr Rune; len: ptr cint): cstring {.
    cdecl, importc: "nk_utf_at", header: "src/nuklear.h".}
