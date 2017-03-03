{.deadCodeElim: on, passC: "-Inuklear/", compile: "nuklear.c".}

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

##  ==============================================================
##
##                           CONSTANTS
##
##  ==============================================================

from strutils import parseFloat

const
  UTF_INVALID* = 0x0000FFFD
  UTF_SIZE* = 4
  maxNumberBuffer* {.intdefine.}: int = 64
  inputMax {.intdefine.}: int = 16
  scrollbarHidingTimeout {.strdefine.}: string = "4.0"
  texteditUndostatecount {.intdefine.}: int = 99
  texteditUndocharcount {.intdefine.}: int = 999
  chartMaxSlot {.intdefine.}: int = 4
  windowMaxName {.intdefine.}: int = 64
  buttonBehaviorStackSize {.intdefine.}: int = 8
  fontStackSize {.intdefine.}: int = 8
  styleItemStackSize {.intdefine.}: int = 16
  floatStackSize {.intdefine.}: int = 32
  vectorStackSize {.intdefine.}: int = 16
  flagsStackSize {.intdefine.}: int = 32
  colorStackSize {.intdefine.}: int = 32

when (maxNumberBuffer != 64):
  {.passC: "-DNK_MAX_NUMBER_BUFFER=" & $maxNumberBuffer.}

when (inputMax != 16):
  {.passC: "-DNK_INPUT_MAX=" & $inputMax.}

when (parseFloat(scrollbarHidingTimeout) != 4.0):
  {.passC: "-DNK_SCROLLBAR_HIDING_TIMEOUT=" & $scrollbarHidingTimeout.}

when (texteditUndostatecount != 99):
  {.passC: "-DNK_TEXTEDIT_UNDOSTATECOUNT=" & $texteditUndostatecount.}

when (texteditUndocharcount != 999):
  {.passC: "-DNK_TEXTEDIT_UNDOCHARCOUNT=" & $texteditUndocharcount.}

when (chartMaxSlot != 4):
  {.passC: "-DNK_CHART_MAX_SLOT=" & $chartMaxSlot.}

when (windowMaxName != 64):
  {.passC: "-DNK_WINDOW_MAX_NAME=" & $windowMaxName.}

when (buttonBehaviorStackSize != 8):
  {.passC: "-DNK_BUTTON_BEHAVIOR_STACK_SIZE=" & $buttonBehaviorStackSize.}

when (fontStackSize != 8):
  {.passC: "-DNK_FONT_STACK_SIZE=" & $fontStackSize.}

when (styleItemStackSize != 16):
  {.passC: "-DNK_STYLE_ITEM_STACK_SIZE=" & $styleItemStackSize.}

when (floatStackSize != 32):
  {.passC: "-DNK_FLOAT_STACK_SIZE=" & $floatStackSize.}

when (vectorStackSize != 16):
  {.passC: "-DNK_VECTOR_STACK_SIZE=" & $vectorStackSize.}

when (flagsStackSize != 32):
  {.passC: "-DNK_FLAGS_STACK_SIZE=" & $flagsStackSize.}

when (colorStackSize != 32):
  {.passC: "-DNK_COLOR_STACK_SIZE=" & $colorStackSize.}


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
  UNDEFINED* = (- 1.0)

template FLAG*(x: untyped): untyped = (1 shl (x))

type
  Color* {.importc: "struct nk_color", header: "src/nuklear.h".} = object
    r* {.importc: "r".}: byte
    g* {.importc: "g".}: byte
    b* {.importc: "b".}: byte
    a* {.importc: "a".}: byte

  # Colorf* {.importc: "struct nk_colorf", header: "src/nuklear.h".} = object
  #   r* {.importc: "r".}: cfloat
  #   g* {.importc: "g".}: cfloat
  #   b* {.importc: "b".}: cfloat
  #   a* {.importc: "a".}: cfloat

  Vec2* {.importc: "struct nk_vec2", header: "src/nuklear.h".} = object
    x* {.importc: "x".}: cfloat
    y* {.importc: "y".}: cfloat

  Vec2i* {.importc: "struct nk_vec2i", header: "src/nuklear.h".} = object
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort

  Rect* {.importc: "struct nk_rect", header: "src/nuklear.h".} = object
    x* {.importc: "x".}: cfloat
    y* {.importc: "y".}: cfloat
    w* {.importc: "w".}: cfloat
    h* {.importc: "h".}: cfloat

  Recti* {.importc: "struct nk_recti", header: "src/nuklear.h".} = object
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort
    w* {.importc: "w".}: cshort
    h* {.importc: "h".}: cshort

  Glyph* = array[UTF_SIZE, char]

  Handle* {.importc: "nk_handle", header: "src/nuklear.h".} = object {.union.}
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


when defined(vertexBufferOutput):
  ##  The optional vertex buffer draw list provides a 2D drawing context
  ##    with antialiasing functionality which takes basic filled or outlined shapes
  ##    or a path and outputs vertexes, elements and draw commands.
  ##    The actual draw list API is not required to be used directly while using this
  ##    library since converting the default library draw command output is done by
  ##    just calling `nk_convert` but I decided to still make this library accessible
  ##    since it can be useful.
  ##
  ##    The draw list is based on a path buffering and polygon and polyline
  ##    rendering API which allows a lot of ways to draw 2D content to screen.
  ##    In fact it is probably more powerful than needed but allows even more crazy
  ##    things than this library provides by default.
  ##

  type
    DrawIndex* = uint16


  type
    DrawListStroke* {.size: sizeof(cint).} = enum
      STROKE_OPEN = false,      ## build up path has no connection back to the beginning
      STROKE_CLOSED = true


  type
    DrawVertexLayoutAttribute* {.size: sizeof(cint).} = enum
      nkVertexPosition, nkVertexColor, nkVertexTexcoord, nkVertexAttributeCount


  type
    DrawVertexLayoutFormat* {.size: sizeof(cint).} = enum
      FORMAT_SCHAR, FORMAT_SSHORT, FORMAT_SINT, FORMAT_UCHAR, FORMAT_USHORT,
      FORMAT_UINT, FORMAT_FLOAT, FORMAT_DOUBLE, FORMAT_COLOR_BEGIN,
      FORMAT_R16G15B16, FORMAT_R32G32B32, FORMAT_R8G8B8A8, FORMAT_R16G15B16A16,
      FORMAT_R32G32B32A32, FORMAT_R32G32B32A32_FLOAT, FORMAT_R32G32B32A32_DOUBLE,
      FORMAT_RGB32, FORMAT_RGBA32, FORMAT_COUNT


  const
    FORMAT_R8G8B8* = FORMAT_COLOR_BEGIN
    FORMAT_COLOR_END* = FORMAT_RGBA32


  type
    DrawVertexLayoutElement* {.importc: "struct nk_draw_vertex_layout_element",
                                 header: "src/nuklear.h".} = object
      attribute* {.importc: "attribute".}: DrawVertexLayoutAttribute
      format* {.importc: "format".}: DrawVertexLayoutFormat
      offset* {.importc: "offset".}: csize

  when defined(commandUserdata):
    type
      DrawCommand* {.importc: "struct nk_draw_command", header: "src/nuklear.h".} = object
        elem_count* {.importc: "elem_count".}: cuint ## number of elements in the current draw batch
        clip_rect* {.importc: "clip_rect".}: Rect ## current screen clipping rectangle
        texture* {.importc: "texture".}: Handle ## current texture to set
        userdata* {.importc: "userdata".}: Handle

  else:
    type
      DrawCommand* {.importc: "struct nk_draw_command", header: "src/nuklear.h".} = object
        elem_count* {.importc: "elem_count".}: cuint ## number of elements in the current draw batch
        clip_rect* {.importc: "clip_rect".}: Rect ## current screen clipping rectangle
        texture* {.importc: "texture".}: Handle ## current texture to set
else:
  type
    DrawCommand* {.importc: "struct nk_DrawCommand", header: "src/nuklear.h".} = object
    DrawVertexLayoutElement* {.importc: "struct nk_draw_vertex_layout_element", header: "src/nuklear.h".} = object



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
  TreeType* {.size: sizeof(cint).} = enum
    TREE_NODE, TREE_TAB


type
  AntiAliasing* {.size: sizeof(cint).} = enum
    ANTI_ALIASING_OFF, ANTI_ALIASING_ON


type
  PluginAlloc* = proc (a2: Handle; old: pointer; a4: csize): pointer {.cdecl.}
  PluginFree* = proc (a2: Handle; old: pointer) {.cdecl.}
  Allocator* {.importc: "struct nk_allocator", header: "src/nuklear.h".} = object
    userdata* {.importc: "userdata".}: Handle
    alloc* {.importc: "alloc".}: PluginAlloc
    free* {.importc: "free".}: PluginFree


type
  MemoryStatus* {.importc: "struct nk_memory_status", header: "src/nuklear.h".} = object
    memory* {.importc: "memory".}: pointer
    `type`* {.importc: "type".}: cuint
    size* {.importc: "size".}: csize
    allocated* {.importc: "allocated".}: csize
    needed* {.importc: "needed".}: csize
    calls* {.importc: "calls".}: csize

  AllocationType* {.size: sizeof(cint).} = enum
    BUFFER_FIXED, BUFFER_DYNAMIC


type
  BufferAllocationType* {.size: sizeof(cint).} = enum
    BUFFER_FRONT, BUFFER_BACK, BUFFER_MAX


type
  BufferMarker* {.importc: "struct nk_buffer_marker", header: "src/nuklear.h".} = object
    active* {.importc: "active".}: cint
    offset* {.importc: "offset".}: csize

  Memory* {.importc: "struct nk_memory", header: "src/nuklear.h".} = object
    `ptr`* {.importc: "ptr".}: pointer
    size* {.importc: "size".}: csize

  Buffer* {.importc: "struct nk_buffer", header: "src/nuklear.h".} = object
    marker* {.importc: "marker".}: array[BUFFER_MAX, BufferMarker] ## buffer marker to free a buffer to a certain offset
    pool* {.importc: "pool".}: Allocator           ## allocator callback for dynamic buffers
    `type`* {.importc: "type".}: AllocationType   ## memory management type
    memory* {.importc: "memory".}: Memory            ## memory and size of the current memory block
    grow_factor* {.importc: "grow_factor".}: cfloat       ## growing factor for dynamic memory management
    allocated* {.importc: "allocated".}: csize           ## total amount of memory allocated
    needed* {.importc: "needed".}: csize              ## totally consumed memory given that enough memory is present
    calls* {.importc: "calls".}: csize               ## number of allocation calls
    size* {.importc: "size".}: csize                ## current size of the buffer

##  ==============================================================
##
##                           STRING
##
##  ===============================================================
##  Basic string buffer which is only used in context with the text editor
##   to manage and manipulate dynamic or fixed size string content. This is _NOT_
##   the default string handling method.

type
  Str* {.importc: "struct nk_str", header: "src/nuklear.h".} = object
    buffer* {.importc: "buffer".}: Buffer
    len* {.importc: "len".}: cint                 ## in codepoints/runes/glyphs


when defined(defaultAllocator):
  proc initDefault*(a2: ptr Str) {.cdecl, importc: "nk_str_init_default", header: "src/nuklear.h".}
proc init*(a2: ptr Str; a3: ptr Allocator; size: csize) {.cdecl, importc: "nk_str_init", header: "src/nuklear.h".}
proc initFixed*(a2: ptr Str; memory: pointer; size: csize) {.cdecl, importc: "nk_str_init_fixed", header: "src/nuklear.h".}
proc clear*(a2: ptr Str) {.cdecl, importc: "nk_str_clear", header: "src/nuklear.h".}
proc free*(a2: ptr Str) {.cdecl, importc: "nk_str_free", header: "src/nuklear.h".}
proc appendTextChar*(a2: ptr Str; a3: cstring; a4: cint): cint {.cdecl, importc: "nk_str_append_text_char", header: "src/nuklear.h".}
proc appendStrChar*(a2: ptr Str; a3: cstring): cint {.cdecl,
    importc: "nk_str_append_str_char", header: "src/nuklear.h".}
proc appendTextUtf8*(a2: ptr Str; a3: cstring; a4: cint): cint {.cdecl,
    importc: "nk_str_append_text_utf8", header: "src/nuklear.h".}
proc appendStrUtf8*(a2: ptr Str; a3: cstring): cint {.cdecl,
    importc: "nk_str_append_str_utf8", header: "src/nuklear.h".}
proc appendTextRunes*(a2: ptr Str; a3: ptr Rune; a4: cint): cint {.cdecl,
    importc: "nk_str_append_text_runes", header: "src/nuklear.h".}
proc appendStrRunes*(a2: ptr Str; a3: ptr Rune): cint {.cdecl,
    importc: "nk_str_append_str_runes", header: "src/nuklear.h".}
proc insertAtChar*(a2: ptr Str; pos: cint; a4: cstring; a5: cint): cint {.cdecl,
    importc: "nk_str_insert_at_char", header: "src/nuklear.h".}
proc insertAtRune*(a2: ptr Str; pos: cint; a4: cstring; a5: cint): cint {.cdecl,
    importc: "nk_str_insert_at_rune", header: "src/nuklear.h".}
proc insertTextChar*(a2: ptr Str; pos: cint; a4: cstring; a5: cint): cint {.cdecl,
    importc: "nk_str_insert_text_char", header: "src/nuklear.h".}
proc insertStrChar*(a2: ptr Str; pos: cint; a4: cstring): cint {.cdecl,
    importc: "nk_str_insert_str_char", header: "src/nuklear.h".}
proc insertTextUtf8*(a2: ptr Str; pos: cint; a4: cstring; a5: cint): cint {.cdecl,
    importc: "nk_str_insert_text_utf8", header: "src/nuklear.h".}
proc insertStrUtf8*(a2: ptr Str; pos: cint; a4: cstring): cint {.cdecl,
    importc: "nk_str_insert_str_utf8", header: "src/nuklear.h".}
proc insertTextRunes*(a2: ptr Str; pos: cint; a4: ptr Rune; a5: cint): cint {.cdecl,
    importc: "nk_str_insert_text_runes", header: "src/nuklear.h".}
proc insertStrRunes*(a2: ptr Str; pos: cint; a4: ptr Rune): cint {.cdecl,
    importc: "nk_str_insert_str_runes", header: "src/nuklear.h".}
proc removeChars*(a2: ptr Str; len: cint) {.cdecl, importc: "nk_str_remove_chars",
    header: "src/nuklear.h".}
proc removeRunes*(str: ptr Str; len: cint) {.cdecl,
    importc: "nk_str_remove_runes", header: "src/nuklear.h".}
proc deleteChars*(a2: ptr Str; pos: cint; len: cint) {.cdecl,
    importc: "nk_str_delete_chars", header: "src/nuklear.h".}
proc deleteRunes*(a2: ptr Str; pos: cint; len: cint) {.cdecl,
    importc: "nk_str_delete_runes", header: "src/nuklear.h".}
proc atChar*(a2: ptr Str; pos: cint): cstring {.cdecl, importc: "nk_str_at_char",
    header: "src/nuklear.h".}
proc atRune*(a2: ptr Str; pos: cint; unicode: ptr Rune; len: ptr cint): cstring {.cdecl,
    importc: "nk_str_at_rune", header: "src/nuklear.h".}
proc runeAt*(a2: ptr Str; pos: cint): Rune {.cdecl, importc: "nk_str_rune_at",
    header: "src/nuklear.h".}
proc atCharConst*(a2: ptr Str; pos: cint): cstring {.cdecl,
    importc: "nk_str_at_char_const", header: "src/nuklear.h".}
proc atconst*(a2: ptr Str; pos: cint; unicode: ptr Rune; len: ptr cint): cstring {.
    cdecl, importc: "nk_str_at_const", header: "src/nuklear.h".}
proc get*(a2: ptr Str): cstring {.cdecl, importc: "nk_str_get", header: "src/nuklear.h".}
proc getConst*(a2: ptr Str): cstring {.cdecl, importc: "nk_str_get_const",
                                       header: "src/nuklear.h".}
proc len*(a2: ptr Str): cint {.cdecl, importc: "nk_str_len", header: "src/nuklear.h".}
proc lenChar*(a2: ptr Str): cint {.cdecl, importc: "nk_str_len_char",
                                   header: "src/nuklear.h".}


type
  Clipboard* {.importc: "struct nk_clipboard", header: "src/nuklear.h".} = object
    userdata* {.importc: "userdata".}: Handle
    paste* {.importc: "paste".}: PluginPaste
    copy* {.importc: "copy".}: PluginCopy

  TextUndoRecord* {.importc: "struct nk_text_undo_record", header: "src/nuklear.h".} = object
    where* {.importc: "where".}: cint
    insert_length* {.importc: "insert_length".}: cshort
    delete_length* {.importc: "delete_length".}: cshort
    char_storage* {.importc: "char_storage".}: cshort

  TextUndoState* {.importc: "struct nk_text_undo_state", header: "src/nuklear.h".} = object
    undo_rec* {.importc: "undo_rec".}: array[texteditUndostatecount, TextUndoRecord]
    undo_char* {.importc: "undo_char".}: array[texteditUndocharcount, Rune]
    undo_point* {.importc: "undo_point".}: cshort
    redo_point* {.importc: "redo_point".}: cshort
    undo_char_point* {.importc: "undo_char_point".}: cshort
    redo_char_point* {.importc: "redo_char_point".}: cshort

  TextEdit* {.importc: "struct nk_text_edit", header: "src/nuklear.h".} = object
    clip* {.importc: "clip".}: Clipboard
    string* {.importc: "string".}: Str
    filter* {.importc: "filter".}: PluginFilter
    scrollbar* {.importc: "scrollbar".}: Vec2
    cursor* {.importc: "cursor".}: cint
    select_start* {.importc: "select_start".}: cint
    select_end* {.importc: "select_end".}: cint
    mode* {.importc: "mode".}: cuchar
    cursor_at_end_of_line* {.importc: "cursor_at_end_of_line".}: cuchar
    initialized* {.importc: "initialized".}: cuchar
    has_preferred_x* {.importc: "has_preferred_x".}: cuchar
    single_line* {.importc: "single_line".}: cuchar
    active* {.importc: "active".}: cuchar
    padding1* {.importc: "padding1".}: cuchar
    preferred_x* {.importc: "preferred_x".}: cfloat
    undo* {.importc: "undo".}: TextUndoState

  PluginFilter* = proc (a2: ptr TextEdit; unicode: Rune): cint {.cdecl.}
  PluginPaste* = proc (a2: Handle; a3: ptr TextEdit) {.cdecl.}
  PluginCopy* = proc (a2: Handle; a3: cstring; len: cint) {.cdecl.}


type
  DrawNullTexture* {.importc: "struct nk_draw_null_texture", header: "src/nuklear.h".} = object
    texture* {.importc: "texture".}: Handle ## texture handle to a texture with a white pixel
    uv* {.importc: "uv".}: Vec2  ## coordinates to a white pixel in the texture

when defined(vertexBufferOutput):
  type
    ConvertConfig* {.importc: "struct nk_convert_config", header: "src/nuklear.h".} = object
      global_alpha* {.importc: "global_alpha".}: cfloat ## global alpha value
      line_AA* {.importc: "line_AA".}: AntiAliasing ## line anti-aliasing flag can be turned off if you are tight on memory
      shape_AA* {.importc: "shape_AA".}: AntiAliasing ## shape anti-aliasing flag can be turned off if you are tight on memory
      circle_segment_count* {.importc: "circle_segment_count".}: cuint ## number of segments used for circles: default to 22
      arc_segment_count* {.importc: "arc_segment_count".}: cuint ## number of segments used for arcs: default to 22
      curve_segment_count* {.importc: "curve_segment_count".}: cuint ## number of segments used for curves: default to 22
      null* {.importc: "null".}: DrawNullTexture ## handle to texture with a white pixel for shape drawing
      vertex_layout* {.importc: "vertex_layout".}: ptr DrawVertexLayoutElement ## describes the vertex output format and packing
      vertex_size* {.importc: "vertex_size".}: csize ## sizeof one vertex for vertex packing
      vertex_alignment* {.importc: "vertex_alignment".}: csize ## vertex alignment: Can be obtained by NK_ALIGNOF
else:
  type
    ConvertConfig* {.importc: "struct nk_convert_config", header: "src/nuklear.h".} = object
      global_alpha* {.importc: "global_alpha".}: cfloat ## global alpha value
      line_AA* {.importc: "line_AA".}: AntiAliasing ## line anti-aliasing flag can be turned off if you are tight on memory
      shape_AA* {.importc: "shape_AA".}: AntiAliasing ## shape anti-aliasing flag can be turned off if you are tight on memory
      circle_segment_count* {.importc: "circle_segment_count".}: cuint ## number of segments used for circles: default to 22
      arc_segment_count* {.importc: "arc_segment_count".}: cuint ## number of segments used for arcs: default to 22
      curve_segment_count* {.importc: "curve_segment_count".}: cuint ## number of segments used for curves: default to 22
      null* {.importc: "null".}: DrawNullTexture ## handle to texture with a white pixel for shape drawing
      vertex_size* {.importc: "vertex_size".}: csize ## sizeof one vertex for vertex packing
      vertex_alignment* {.importc: "vertex_alignment".}: csize ## vertex alignment: Can be optained by NK_ALIGNOF

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
    WIDGET_STATE_MODIFIED = FLAG(1), WIDGET_STATE_INACTIVE = FLAG(2), ## widget is neither active nor hovered
    WIDGET_STATE_ENTERED = FLAG(3), ## widget has been hovered on the current frame
    WIDGET_STATE_HOVER = FLAG(4), ## widget is being hovered
    # WIDGET_STATE_HOVERED = WIDGET_STATE_HOVER or WIDGET_STATE_MODIFIED, ## widget is being hovered
    WIDGET_STATE_HOVERED = FLAG(4) or FLAG(1), ## widget is being hovered
    WIDGET_STATE_ACTIVED = FLAG(5), ## widget is currently activated
    WIDGET_STATE_ACTIVE = FLAG(5) or FLAG(1)
    WIDGET_STATE_LEFT = FLAG(6), ## widget is from this frame on not hovered anymore

## text alignment
type
  TextAlign* {.size: sizeof(cint).} = enum
    TEXT_ALIGN_LEFT = 0x00000001, TEXT_ALIGN_CENTERED = 0x00000002,
    TEXT_ALIGN_RIGHT = 0x00000004, TEXT_ALIGN_TOP = 0x00000008,
    TEXT_ALIGN_MIDDLE = 0x00000010, TEXT_ALIGN_BOTTOM = 0x00000020


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
    EDIT_DEFAULT = 0, EDIT_READ_ONLY = FLAG(0), EDIT_AUTO_SELECT = FLAG(1),
    EDIT_SIG_ENTER = FLAG(2), EDIT_ALLOW_TAB = FLAG(3), EDIT_NO_CURSOR = FLAG(4),
    EDIT_SELECTABLE = FLAG(5), EDIT_CLIPBOARD = FLAG(6),
    EDIT_CTRL_ENTER_NEWLINE = FLAG(7), EDIT_NO_HORIZONTAL_SCROLL = FLAG(8),
    EDIT_ALWAYS_INSERT_MODE = FLAG(9), EDIT_MULTILINE = FLAG(11),
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
    WINDOW_BORDER = FLAG(0),    ## Draws a border around the window to visually separate the window * from the background
    WINDOW_MOVABLE = FLAG(1),   ## The movable flag indicates that a window can be moved by user input or * by dragging the window header
    WINDOW_SCALABLE = FLAG(2),  ## The scalable flag indicates that a window can be scaled by user input * by dragging a scaler icon at the button of the window
    WINDOW_CLOSABLE = FLAG(3),  ## adds a closable icon into the header
    WINDOW_MINIMIZABLE = FLAG(4), ## adds a minimize icon into the header
    WINDOW_NO_SCROLLBAR = FLAG(5), ## Removes the scrollbar from the window
    WINDOW_TITLE = FLAG(6),     ## Forces a header at the top at the window showing the title
    WINDOW_SCROLL_AUTO_HIDE = FLAG(7), ## Automatically hides the window scrollbar if no user interaction
    WINDOW_BACKGROUND = FLAG(8) ## Always keep window in the background


when defined(vertexBufferOutput):
  type
    UserFontGlyph* {.importc: "struct nk_user_font_glyph", header: "src/nuklear.h".} = object
      uv* {.importc: "uv".}: array[2, Vec2] ## # texture coordinates
      offset* {.importc: "offset".}: Vec2 ## # offset between top left and glyph
      width* {.importc: "width".}: cfloat
      height* {.importc: "height".}: cfloat ## # size of the glyph
      xadvance* {.importc: "xadvance".}: cfloat ## # offset to the next glyph
else:
  type
    UserFontGlyph* {.importc: "struct nk_user_font_glyph", header: "src/nuklear.h".} = object

type
  TextWidthF* = proc (a2: Handle; h: cfloat; a4: cstring; len: cint): cfloat {.cdecl.}
  QueryFontGlyphF* = proc (handle: Handle; font_height: cfloat;
                           glyph: ptr UserFontGlyph; codepoint: Rune;
                           next_codepoint: Rune) {.cdecl.}

when defined(vertexBufferOutput):
  type
    UserFont* {.importc: "struct nk_user_font", header: "src/nuklear.h".} = object
      userdata* {.importc: "userdata".}: Handle ## # user provided font handle
      height* {.importc: "height".}: cfloat ## # max height of the font
      width* {.importc: "width".}: TextWidthF ## # font string width in pixel callback
      query* {.importc: "query".}: QueryFontGlyphF ## # font glyph callback to query drawing info
      texture* {.importc: "texture".}: Handle ## # texture handle to the used font atlas or texture

else:
  type
    UserFont* {.importc: "struct nk_user_font", header: "src/nuklear.h".} = object
      userdata* {.importc: "userdata".}: Handle ## # user provided font handle
      height* {.importc: "height".}: cfloat ## # max height of the font
      width* {.importc: "width".}: TextWidthF ## # font string width in pixel callback

type
  ChartSlot* {.importc: "struct nk_chart_slot", header: "src/nuklear.h".} = object
    `type`* {.importc: "type".}: ChartType
    color* {.importc: "color".}: Color
    highlight* {.importc: "highlight".}: Color
    min* {.importc: "min".}: cfloat
    max* {.importc: "max".}: cfloat
    range* {.importc: "range".}: cfloat
    count* {.importc: "count".}: cint
    last* {.importc: "last".}: Vec2
    index* {.importc: "index".}: cint

  Chart* {.importc: "struct nk_chart", header: "src/nuklear.h".} = object
    slots* {.importc: "slots".}: array[chartMaxSlot, ChartSlot]
    slot* {.importc: "slot".}: cint
    x* {.importc: "x".}: cfloat
    y* {.importc: "y".}: cfloat
    w* {.importc: "w".}: cfloat
    h* {.importc: "h".}: cfloat

  RowLayout* {.importc: "struct nk_row_layout", header: "src/nuklear.h".} = object
    `type`* {.importc: "type".}: cint
    index* {.importc: "index".}: cint
    height* {.importc: "height".}: cfloat
    columns* {.importc: "columns".}: cint
    ratio* {.importc: "ratio".}: ptr cfloat
    item_width* {.importc: "item_width".}: cfloat
    item_height* {.importc: "item_height".}: cfloat
    item_offset* {.importc: "item_offset".}: cfloat
    filled* {.importc: "filled".}: cfloat
    item* {.importc: "item".}: Rect
    tree_depth* {.importc: "tree_depth".}: cint

  PopupBuffer* {.importc: "struct nk_popup_buffer", header: "src/nuklear.h".} = object
    begin* {.importc: "begin".}: csize
    parent* {.importc: "parent".}: csize
    last* {.importc: "last".}: csize
    `end`* {.importc: "end".}: csize
    active* {.importc: "active".}: cint

  MenuState* {.importc: "struct nk_menu_state", header: "src/nuklear.h".} = object
    x* {.importc: "x".}: cfloat
    y* {.importc: "y".}: cfloat
    w* {.importc: "w".}: cfloat
    h* {.importc: "h".}: cfloat
    offset* {.importc: "offset".}: Scroll

  Panel* {.importc: "struct nk_panel", header: "src/nuklear.h".} = object
    flags* {.importc: "flags".}: Flags
    bounds* {.importc: "bounds".}: Rect
    offset* {.importc: "offset".}: ptr Scroll
    at_x* {.importc: "at_x".}: cfloat
    at_y* {.importc: "at_y".}: cfloat
    max_x* {.importc: "max_x".}: cfloat
    footer_height* {.importc: "footer_height".}: cfloat
    header_height* {.importc: "header_height".}: cfloat
    border* {.importc: "border".}: cfloat
    has_scrolling* {.importc: "has_scrolling".}: cuint
    clip* {.importc: "clip".}: Rect
    menu* {.importc: "menu".}: MenuState
    row* {.importc: "row".}: RowLayout
    chart* {.importc: "chart".}: Chart
    popup_buffer* {.importc: "popup_buffer".}: PopupBuffer
    buffer* {.importc: "buffer".}: ptr CommandBuffer
    parent* {.importc: "parent".}: ptr Panel

  CommandBuffer* {.importc: "struct nk_command_buffer", header: "src/nuklear.h".} = object
    base* {.importc: "base".}: ptr Buffer
    clip* {.importc: "clip".}: Rect
    use_clipping* {.importc: "use_clipping".}: cint
    userdata* {.importc: "userdata".}: Handle
    begin* {.importc: "begin".}: csize
    `end`* {.importc: "end".}: csize
    last* {.importc: "last".}: csize


type
  StyleItemType* {.size: sizeof(cint).} = enum
    STYLE_ITEM_COLOR, STYLE_ITEM_IMAGE


type
  StyleItemData* {.importc: "union nk_style_item_data", header: "src/nuklear.h".} = object {.
      union.}
    image* {.importc: "image".}: Image
    color* {.importc: "color".}: Color

  StyleItem* {.importc: "struct nk_style_item", header: "src/nuklear.h".} = object
    `type`* {.importc: "type".}: StyleItemType
    data* {.importc: "data".}: StyleItemData

type
  StyleText* {.importc: "struct nk_style_text", header: "src/nuklear.h".} = object
    color* {.importc: "color".}: Color
    padding* {.importc: "padding".}: Vec2

  StyleButton* {.importc: "struct nk_style_button", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## text
    text_background* {.importc: "text_background".}: Color
    text_normal* {.importc: "text_normal".}: Color
    text_hover* {.importc: "text_hover".}: Color
    text_active* {.importc: "text_active".}: Color
    text_alignment* {.importc: "text_alignment".}: Flags ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    padding* {.importc: "padding".}: Vec2
    image_padding* {.importc: "image_padding".}: Vec2
    touch_padding* {.importc: "touch_padding".}: Vec2 ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer;
        userdata: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; userdata: Handle) {.
        cdecl.}

  StyleToggle* {.importc: "struct nk_style_toggle", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## cursor
    cursor_normal* {.importc: "cursor_normal".}: StyleItem
    cursor_hover* {.importc: "cursor_hover".}: StyleItem ## text
    text_normal* {.importc: "text_normal".}: Color
    text_hover* {.importc: "text_hover".}: Color
    text_active* {.importc: "text_active".}: Color
    text_background* {.importc: "text_background".}: Color
    text_alignment* {.importc: "text_alignment".}: Flags ## properties
    padding* {.importc: "padding".}: Vec2
    touch_padding* {.importc: "touch_padding".}: Vec2
    spacing* {.importc: "spacing".}: cfloat
    border* {.importc: "border".}: cfloat ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleSelectable* {.importc: "struct nk_style_selectable", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background (inactive)
    hover* {.importc: "hover".}: StyleItem
    pressed* {.importc: "pressed".}: StyleItem ## background (active)
    normal_active* {.importc: "normal_active".}: StyleItem
    hover_active* {.importc: "hover_active".}: StyleItem
    pressed_active* {.importc: "pressed_active".}: StyleItem ## text color (inactive)
    text_normal* {.importc: "text_normal".}: Color
    text_hover* {.importc: "text_hover".}: Color
    text_pressed* {.importc: "text_pressed".}: Color ## text color (active)
    text_normal_active* {.importc: "text_normal_active".}: Color
    text_hover_active* {.importc: "text_hover_active".}: Color
    text_pressed_active* {.importc: "text_pressed_active".}: Color
    text_background* {.importc: "text_background".}: Color
    text_alignment* {.importc: "text_alignment".}: Flags ## properties
    rounding* {.importc: "rounding".}: cfloat
    padding* {.importc: "padding".}: Vec2
    touch_padding* {.importc: "touch_padding".}: Vec2
    image_padding* {.importc: "image_padding".}: Vec2 ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleSlider* {.importc: "struct nk_style_slider", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## background bar
    bar_normal* {.importc: "bar_normal".}: Color
    bar_hover* {.importc: "bar_hover".}: Color
    bar_active* {.importc: "bar_active".}: Color
    bar_filled* {.importc: "bar_filled".}: Color ## cursor
    cursor_normal* {.importc: "cursor_normal".}: StyleItem
    cursor_hover* {.importc: "cursor_hover".}: StyleItem
    cursor_active* {.importc: "cursor_active".}: StyleItem ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    bar_height* {.importc: "bar_height".}: cfloat
    padding* {.importc: "padding".}: Vec2
    spacing* {.importc: "spacing".}: Vec2
    cursor_size* {.importc: "cursor_size".}: Vec2 ## optional buttons
    show_buttons* {.importc: "show_buttons".}: cint
    inc_button* {.importc: "inc_button".}: StyleButton
    dec_button* {.importc: "dec_button".}: StyleButton
    inc_symbol* {.importc: "inc_symbol".}: SymbolType
    dec_symbol* {.importc: "dec_symbol".}: SymbolType ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleProgress* {.importc: "struct nk_style_progress", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## cursor
    cursor_normal* {.importc: "cursor_normal".}: StyleItem
    cursor_hover* {.importc: "cursor_hover".}: StyleItem
    cursor_active* {.importc: "cursor_active".}: StyleItem
    cursor_border_color* {.importc: "cursor_border_color".}: Color ## properties
    rounding* {.importc: "rounding".}: cfloat
    border* {.importc: "border".}: cfloat
    cursor_border* {.importc: "cursor_border".}: cfloat
    cursor_rounding* {.importc: "cursor_rounding".}: cfloat
    padding* {.importc: "padding".}: Vec2 ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleScrollbar* {.importc: "struct nk_style_scrollbar", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## # background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## # cursor
    cursor_normal* {.importc: "cursor_normal".}: StyleItem
    cursor_hover* {.importc: "cursor_hover".}: StyleItem
    cursor_active* {.importc: "cursor_active".}: StyleItem
    cursor_border_color* {.importc: "cursor_border_color".}: Color ## # properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    border_cursor* {.importc: "border_cursor".}: cfloat
    rounding_cursor* {.importc: "rounding_cursor".}: cfloat
    padding* {.importc: "padding".}: Vec2 ## # optional buttons
    show_buttons* {.importc: "show_buttons".}: cint
    inc_button* {.importc: "inc_button".}: StyleButton
    dec_button* {.importc: "dec_button".}: StyleButton
    inc_symbol* {.importc: "inc_symbol".}: SymbolType
    dec_symbol* {.importc: "dec_symbol".}: SymbolType ## # optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleEdit* {.importc: "struct nk_style_edit", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color
    scrollbar* {.importc: "scrollbar".}: StyleScrollbar ## cursor
    cursor_normal* {.importc: "cursor_normal".}: Color
    cursor_hover* {.importc: "cursor_hover".}: Color
    cursor_text_normal* {.importc: "cursor_text_normal".}: Color
    cursor_text_hover* {.importc: "cursor_text_hover".}: Color ## text (unselected)
    text_normal* {.importc: "text_normal".}: Color
    text_hover* {.importc: "text_hover".}: Color
    text_active* {.importc: "text_active".}: Color ## text (selected)
    selected_normal* {.importc: "selected_normal".}: Color
    selected_hover* {.importc: "selected_hover".}: Color
    selected_text_normal* {.importc: "selected_text_normal".}: Color
    selected_text_hover* {.importc: "selected_text_hover".}: Color ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    cursor_size* {.importc: "cursor_size".}: cfloat
    scrollbar_size* {.importc: "scrollbar_size".}: Vec2
    padding* {.importc: "padding".}: Vec2
    row_padding* {.importc: "row_padding".}: cfloat

  StyleProperty* {.importc: "struct nk_style_property", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## text
    label_normal* {.importc: "label_normal".}: Color
    label_hover* {.importc: "label_hover".}: Color
    label_active* {.importc: "label_active".}: Color ## symbols
    sym_left* {.importc: "sym_left".}: SymbolType
    sym_right* {.importc: "sym_right".}: SymbolType ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    padding* {.importc: "padding".}: Vec2
    edit* {.importc: "edit".}: StyleEdit
    inc_button* {.importc: "inc_button".}: StyleButton
    dec_button* {.importc: "dec_button".}: StyleButton ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleChart* {.importc: "struct nk_style_chart", header: "src/nuklear.h".} = object
    background* {.importc: "background".}: StyleItem ## colors
    border_color* {.importc: "border_color".}: Color
    selected_color* {.importc: "selected_color".}: Color
    color* {.importc: "color".}: Color ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    padding* {.importc: "padding".}: Vec2

  StyleCombo* {.importc: "struct nk_style_combo", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## label
    label_normal* {.importc: "label_normal".}: Color
    label_hover* {.importc: "label_hover".}: Color
    label_active* {.importc: "label_active".}: Color ## symbol
    symbol_normal* {.importc: "symbol_normal".}: Color
    symbol_hover* {.importc: "symbol_hover".}: Color
    symbol_active* {.importc: "symbol_active".}: Color ## button
    button* {.importc: "button".}: StyleButton
    sym_normal* {.importc: "sym_normal".}: SymbolType
    sym_hover* {.importc: "sym_hover".}: SymbolType
    sym_active* {.importc: "sym_active".}: SymbolType ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    content_padding* {.importc: "content_padding".}: Vec2
    button_padding* {.importc: "button_padding".}: Vec2
    spacing* {.importc: "spacing".}: Vec2

  StyleTab* {.importc: "struct nk_style_tab", header: "src/nuklear.h".} = object
    background* {.importc: "background".}: StyleItem ## background
    border_color* {.importc: "border_color".}: Color
    text* {.importc: "text".}: Color ## button
    tab_maximize_button* {.importc: "tab_maximize_button".}: StyleButton
    tab_minimize_button* {.importc: "tab_minimize_button".}: StyleButton
    node_maximize_button* {.importc: "node_maximize_button".}: StyleButton
    node_minimize_button* {.importc: "node_minimize_button".}: StyleButton
    sym_minimize* {.importc: "sym_minimize".}: SymbolType
    sym_maximize* {.importc: "sym_maximize".}: SymbolType ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    indent* {.importc: "indent".}: cfloat
    padding* {.importc: "padding".}: Vec2
    spacing* {.importc: "spacing".}: Vec2

  StyleHeaderAlign* {.size: sizeof(cint).} = enum
    HEADER_LEFT, HEADER_RIGHT


type
  StyleWindowHeader* {.importc: "struct nk_style_window_header", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem ## button
    close_button* {.importc: "close_button".}: StyleButton
    minimize_button* {.importc: "minimize_button".}: StyleButton
    close_symbol* {.importc: "close_symbol".}: SymbolType
    minimize_symbol* {.importc: "minimize_symbol".}: SymbolType
    maximize_symbol* {.importc: "maximize_symbol".}: SymbolType ## title
    label_normal* {.importc: "label_normal".}: Color
    label_hover* {.importc: "label_hover".}: Color
    label_active* {.importc: "label_active".}: Color ## properties
    align* {.importc: "align".}: StyleHeaderAlign
    padding* {.importc: "padding".}: Vec2
    label_padding* {.importc: "label_padding".}: Vec2
    spacing* {.importc: "spacing".}: Vec2

  StyleWindow* {.importc: "struct nk_style_window", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: StyleWindowHeader
    fixed_background* {.importc: "fixed_background".}: StyleItem
    background* {.importc: "background".}: Color
    border_color* {.importc: "border_color".}: Color
    combo_border_color* {.importc: "combo_border_color".}: Color
    contextual_border_color* {.importc: "contextual_border_color".}: Color
    menu_border_color* {.importc: "menu_border_color".}: Color
    group_border_color* {.importc: "group_border_color".}: Color
    tooltip_border_color* {.importc: "tooltip_border_color".}: Color
    scaler* {.importc: "scaler".}: StyleItem
    border* {.importc: "border".}: cfloat
    combo_border* {.importc: "combo_border".}: cfloat
    contextual_border* {.importc: "contextual_border".}: cfloat
    menu_border* {.importc: "menu_border".}: cfloat
    group_border* {.importc: "group_border".}: cfloat
    tooltip_border* {.importc: "tooltip_border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    spacing* {.importc: "spacing".}: Vec2
    scrollbar_size* {.importc: "scrollbar_size".}: Vec2
    min_size* {.importc: "min_size".}: Vec2
    padding* {.importc: "padding".}: Vec2
    group_padding* {.importc: "group_padding".}: Vec2
    popup_padding* {.importc: "popup_padding".}: Vec2
    combo_padding* {.importc: "combo_padding".}: Vec2
    contextual_padding* {.importc: "contextual_padding".}: Vec2
    menu_padding* {.importc: "menu_padding".}: Vec2
    tooltip_padding* {.importc: "tooltip_padding".}: Vec2

  Style* {.importc: "struct nk_style", header: "src/nuklear.h".} = object
    font* {.importc: "font".}: ptr UserFont
    cursors* {.importc: "cursors".}: array[CURSOR_COUNT, ptr Cursor]
    cursor_active* {.importc: "cursor_active".}: ptr Cursor
    cursor_last* {.importc: "cursor_last".}: ptr Cursor
    cursor_visible* {.importc: "cursor_visible".}: cint
    text* {.importc: "text".}: StyleText
    button* {.importc: "button".}: StyleButton
    contextual_button* {.importc: "contextual_button".}: StyleButton
    menu_button* {.importc: "menu_button".}: StyleButton
    option* {.importc: "option".}: StyleToggle
    checkbox* {.importc: "checkbox".}: StyleToggle
    selectable* {.importc: "selectable".}: StyleSelectable
    slider* {.importc: "slider".}: StyleSlider
    progress* {.importc: "progress".}: StyleProgress
    property* {.importc: "property".}: StyleProperty
    edit* {.importc: "edit".}: StyleEdit
    chart* {.importc: "chart".}: StyleChart
    scrollh* {.importc: "scrollh".}: StyleScrollbar
    scrollv* {.importc: "scrollv".}: StyleScrollbar
    tab* {.importc: "tab".}: StyleTab
    combo* {.importc: "combo".}: StyleCombo
    window* {.importc: "window".}: StyleWindow


type
  MouseButton* {.importc: "struct nk_mouse_button", header: "src/nuklear.h".} = object
    down* {.importc: "down".}: cint
    clicked* {.importc: "clicked".}: cuint
    clicked_pos* {.importc: "clicked_pos".}: Vec2

  Mouse* {.importc: "struct nk_mouse", header: "src/nuklear.h".} = object
    buttons* {.importc: "buttons".}: array[BUTTON_MAX, MouseButton]
    pos* {.importc: "pos".}: Vec2
    prev* {.importc: "prev".}: Vec2
    delta* {.importc: "delta".}: Vec2
    scroll_delta* {.importc: "scroll_delta".}: cfloat
    grab* {.importc: "grab".}: cuchar
    grabbed* {.importc: "grabbed".}: cuchar
    ungrab* {.importc: "ungrab".}: cuchar

  Key* {.importc: "struct nk_key", header: "src/nuklear.h".} = object
    down* {.importc: "down".}: cint
    clicked* {.importc: "clicked".}: cuint

  Keyboard* {.importc: "struct nk_keyboard", header: "src/nuklear.h".} = object
    keys* {.importc: "keys".}: array[KEY_MAX, Key]
    text* {.importc: "text".}: array[inputMax, char]
    text_len* {.importc: "text_len".}: cint

  Input* {.importc: "struct nk_input", header: "src/nuklear.h".} = object
    keyboard* {.importc: "keyboard".}: Keyboard
    mouse* {.importc: "mouse".}: Mouse


type
  config_stack_style_item_element* {.importc: "struct nk_config_stack_style_item_element",
                                    header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr StyleItem
    old_value* {.importc: "old_value".}: StyleItem

  config_stack_float_element* {.
      importc: "struct nk_config_stack_float_element",
      header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr float
    old_value* {.importc: "old_value".}: float

  config_stack_vec2_element* {.
      importc: "struct nk_config_stack_vec2_element",
      header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr Vec2
    old_value* {.importc: "old_value".}: Vec2

  config_stack_flags_element* {.importc: "struct nk_config_stack_flags_element",
      header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr Flags
    old_value* {.importc: "old_value".}: Flags

  config_stack_color_element* {.importc: "struct nk_config_stack_color_element",
      header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr Color
    old_value* {.importc: "old_value".}: Color

  config_stack_user_font_element* {.importc: "struct nk_config_stack_user_font_element",
      header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr ptr UserFont
    old_value* {.importc: "old_value".}: ptr UserFont

  config_stack_button_behavior_element* {.importc: "struct nk_config_stack_button_behavior_element",
      header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr ButtonBehavior
    old_value* {.importc: "old_value".}: ButtonBehavior

  ConfigStackStyleItem* {.importc: "struct nk_config_stack_style_item",
                            header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[styleItemStackSize,
        config_stack_style_item_element]

  ConfigStackFloat* {.importc: "struct nk_config_stack_float",
                                 header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[floatStackSize,
        config_stack_float_element]

  ConfigStackVec2* {.importc: "struct nk_config_stack_vec2",
                                     header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[vectorStackSize,
        config_stack_vec2_element]

  ConfigStackFlags* {.
      importc: "struct nk_config_stack_flags", header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[flagsStackSize,
        config_stack_flags_element]

  ConfigStackColor* {.
      importc: "struct nk_config_stack_color",
      header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[colorStackSize, config_stack_color_element]

  ConfigStackUserFont* {.
      importc: "struct nk_config_stack_user_font",
      header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[fontStackSize, config_stack_user_font_element]

  ConfigStackButtonBehavior* {.importc: "struct nk_config_stack_button_behavior",
      header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[buttonBehaviorStackSize, config_stack_button_behavior_element]

  ConfigurationStacks* {.importc: "struct nk_configuration_stacks", header: "src/nuklear.h".} = object
    style_items* {.importc: "style_items".}: ConfigStackStyleItem
    floats* {.importc: "floats".}: ConfigStackFloat
    vectors* {.importc: "vectors".}: ConfigStackVec2
    flags* {.importc: "flags".}: ConfigStackFlags
    colors* {.importc: "colors".}: ConfigStackColor
    fonts* {.importc: "fonts".}: ConfigStackUserFont
    button_behaviors* {.importc: "button_behaviors".}: ConfigStackButtonBehavior


type
  WindowFlags* {.size: sizeof(cint).} = enum
    WINDOW_PRIVATE = FLAG(9), ## dummy flag marks the beginning of the private window flag part
    WINDOW_DYNAMIC = FLAG(10), ## special window type growing up in height while being filled to a certain maximum height
    WINDOW_ROM = FLAG(11),    ## sets the window into a read only mode and does not allow input changes
    WINDOW_HIDDEN = FLAG(12), ## Hides the window and stops any window interaction and drawing
    WINDOW_CLOSED = FLAG(13), ## Directly closes and frees the window at the end of the frame
    WINDOW_MINIMIZED = FLAG(14), ## marks the window as minimized
    WINDOW_SUB = FLAG(15),    ## Marks the window as subwindow of another window
    WINDOW_GROUP = FLAG(16),  ## Marks the window as window widget group
    WINDOW_POPUP = FLAG(17),  ## Marks the window as a popup window
    WINDOW_NONBLOCK = FLAG(18), ## Marks the window as a nonblock popup window
    WINDOW_CONTEXTUAL = FLAG(19), ## Marks the window as a combo box or menu
    WINDOW_COMBO = FLAG(20),  ## Marks the window as a combo box
    WINDOW_MENU = FLAG(21),   ## Marks the window as a menu
    WINDOW_TOOLTIP = FLAG(22), ## Marks the window as a menu
    WINDOW_REMOVE_ROM = FLAG(23) ## Removes the read only mode at the end of the window


type
  PopupState* {.importc: "struct nk_popup_state", header: "src/nuklear.h".} = object
    win* {.importc: "win".}: ptr Window
    `type`* {.importc: "type".}: WindowFlags
    name* {.importc: "name".}: Hash
    active* {.importc: "active".}: cint
    combo_count* {.importc: "combo_count".}: cuint
    con_count* {.importc: "con_count".}: cuint
    con_old* {.importc: "con_old".}: cuint
    active_con* {.importc: "active_con".}: cuint

  EditState* {.importc: "struct nk_edit_state", header: "src/nuklear.h".} = object
    name* {.importc: "name".}: Hash
    seq* {.importc: "seq".}: cuint
    old* {.importc: "old".}: cuint
    active* {.importc: "active".}: cint
    prev* {.importc: "prev".}: cint
    cursor* {.importc: "cursor".}: cint
    sel_start* {.importc: "sel_start".}: cint
    sel_end* {.importc: "sel_end".}: cint
    scrollbar* {.importc: "scrollbar".}: Scroll
    mode* {.importc: "mode".}: cuchar
    single_line* {.importc: "single_line".}: cuchar

  PropertyState* {.importc: "struct nk_property_state", header: "src/nuklear.h".} = object
    active* {.importc: "active".}: cint
    prev* {.importc: "prev".}: cint
    buffer* {.importc: "buffer".}: array[maxNumberBuffer, char]
    length* {.importc: "length".}: cint
    cursor* {.importc: "cursor".}: cint
    name* {.importc: "name".}: Hash
    seq* {.importc: "seq".}: cuint
    old* {.importc: "old".}: cuint
    state* {.importc: "state".}: cint

  Window* {.importc: "struct nk_window", header: "src/nuklear.h".} = object
    seq* {.importc: "seq".}: cuint
    name* {.importc: "name".}: Hash
    name_string* {.importc: "name_string".}: array[windowMaxName, char]
    flags* {.importc: "flags".}: Flags
    bounds* {.importc: "bounds".}: Rect
    scrollbar* {.importc: "scrollbar".}: Scroll
    buffer* {.importc: "buffer".}: CommandBuffer
    layout* {.importc: "layout".}: ptr Panel
    scrollbar_hiding_timer* {.importc: "scrollbar_hiding_timer".}: cfloat ## persistent widget state
    property* {.importc: "property".}: PropertyState
    popup* {.importc: "popup".}: PopupState
    edit* {.importc: "edit".}: EditState
    scrolled* {.importc: "scrolled".}: cuint
    tables* {.importc: "tables".}: ptr Table
    table_count* {.importc: "table_count".}: cushort
    table_size* {.importc: "table_size".}: cushort ## window list hooks
    next* {.importc: "next".}: ptr Window
    prev* {.importc: "prev".}: ptr Window
    parent* {.importc: "parent".}: ptr Window

  Table* {.importc: "struct nk_table", header: "src/nuklear.h".} = object
    seq* {.importc: "seq".}: cuint
    # keys* {.importc: "keys".}: array[((sizeof(Window) div sizeof(uint)) div 2), Hash]
    # values* {.importc: "values".}: array[((sizeof(Window) div sizeof(uint)) div 2), uint]
    next* {.importc: "next".}: ptr Table
    prev* {.importc: "prev".}: ptr Table


type
  PageData* {.importc: "union nk_page_data", header: "src/nuklear.h".} = object {.union.}
    tbl* {.importc: "tbl".}: Table
    win* {.importc: "win".}: Window

  PageElement* {.importc: "struct nk_page_element", header: "src/nuklear.h".} = object
    data* {.importc: "data".}: PageData
    next* {.importc: "next".}: ptr PageElement
    prev* {.importc: "prev".}: ptr PageElement

  Page* {.importc: "struct nk_page", header: "src/nuklear.h".} = object
    size* {.importc: "size".}: cuint
    next* {.importc: "next".}: ptr Page
    win* {.importc: "win".}: array[1, PageElement]

  Pool* {.importc: "struct nk_pool", header: "src/nuklear.h".} = object
    alloc* {.importc: "alloc".}: Allocator
    `type`* {.importc: "type".}: AllocationType
    page_count* {.importc: "page_count".}: cuint
    pages* {.importc: "pages".}: ptr Page
    freelist* {.importc: "freelist".}: ptr PageElement
    capacity* {.importc: "capacity".}: cuint
    size* {.importc: "size".}: csize
    cap* {.importc: "cap".}: csize


when defined(vertexBufferOutput):
  when defined(commandUserdata):
    type
      DrawList* {.importc: "struct nk_draw_list", header: "src/nuklear.h".} = object
        config* {.importc: "config".}: ConvertConfig
        clip_rect* {.importc: "clip_rect".}: Rect
        buffer* {.importc: "buffer".}: ptr Buffer
        vertices* {.importc: "vertices".}: ptr Buffer
        elements* {.importc: "elements".}: ptr Buffer
        element_count* {.importc: "element_count".}: cuint
        vertex_count* {.importc: "vertex_count".}: cuint
        cmd_offset* {.importc: "cmd_offset".}: csize
        cmd_count* {.importc: "cmd_count".}: cuint
        path_count* {.importc: "path_count".}: cuint
        path_offset* {.importc: "path_offset".}: cuint
        circle_vtx* {.importc: "circle_vtx".}: array[12, Vec2]
        userdata* {.importc: "userdata".}: Handle

  else:
    type
      DrawList* {.importc: "struct nk_draw_list", header: "src/nuklear.h".} = object
        config* {.importc: "config".}: ConvertConfig
        clip_rect* {.importc: "clip_rect".}: Rect
        buffer* {.importc: "buffer".}: ptr Buffer
        vertices* {.importc: "vertices".}: ptr Buffer
        elements* {.importc: "elements".}: ptr Buffer
        element_count* {.importc: "element_count".}: cuint
        vertex_count* {.importc: "vertex_count".}: cuint
        cmd_offset* {.importc: "cmd_offset".}: csize
        cmd_count* {.importc: "cmd_count".}: cuint
        path_count* {.importc: "path_count".}: cuint
        path_offset* {.importc: "path_offset".}: cuint
        circle_vtx* {.importc: "circle_vtx".}: array[12, Vec2]


when defined(vertexBufferOutput):
  when defined(commandUserdata):
    type
      Context* {.importc: "struct nk_context", header: "src/nuklear.h".} = object
        input* {.importc: "input".}: Input
        ## public: can be accessed freely
        style* {.importc: "style".}: Style
        memory* {.importc: "memory".}: Buffer
        clip* {.importc: "clip".}: Clipboard
        last_widget_state* {.importc: "last_widget_state".}: Flags
        delta_time_seconds* {.importc: "delta_time_seconds".}: cfloat
        button_behavior* {.importc: "button_behavior".}: ButtonBehavior
        stacks* {.importc: "stacks".}: ConfigurationStacks
        ## private:
        ##    should only be accessed if you
        ##    know what you are doing
        draw_list* {.importc: "draw_list".}: DrawList
        userdata* {.importc: "userdata".}: Handle
        ## text editor objects are quite big because of an internal
        ##      undo/redo stack. Therefore does not make sense to have one for
        ##      each window for temporary use cases, so I only provide *one* instance
        ##      for all windows. This works because the content is cleared anyway
        text_edit* {.importc: "text_edit".}: TextEdit ## draw buffer used for overlay drawing operation like cursor
        overlay* {.importc: "overlay".}: CommandBuffer ## windows
        build* {.importc: "build".}: cint
        use_pool* {.importc: "use_pool".}: cint
        pool* {.importc: "pool".}: Pool
        begin* {.importc: "begin".}: ptr Window
        `end`* {.importc: "end".}: ptr Window
        active* {.importc: "active".}: ptr Window
        current* {.importc: "current".}: ptr Window
        freelist* {.importc: "freelist".}: ptr PageElement
        count* {.importc: "count".}: cuint
        seq* {.importc: "seq".}: cuint

  else:
    type
      Context* {.importc: "struct nk_context", header: "src/nuklear.h".} = object
        input* {.importc: "input".}: Input
        ## public: can be accessed freely
        style* {.importc: "style".}: Style
        memory* {.importc: "memory".}: Buffer
        clip* {.importc: "clip".}: Clipboard
        last_widget_state* {.importc: "last_widget_state".}: Flags
        delta_time_seconds* {.importc: "delta_time_seconds".}: cfloat
        button_behavior* {.importc: "button_behavior".}: ButtonBehavior
        stacks* {.importc: "stacks".}: ConfigurationStacks
        ## private:
        ##    should only be accessed if you
        ##    know what you are doing
        draw_list* {.importc: "draw_list".}: DrawList
        ## text editor objects are quite big because of an internal
        ##      undo/redo stack. Therefore does not make sense to have one for
        ##      each window for temporary use cases, so I only provide *one* instance
        ##      for all windows. This works because the content is cleared anyway
        text_edit* {.importc: "text_edit".}: TextEdit
        ## draw buffer used for overlay drawing operation like cursor
        overlay* {.importc: "overlay".}: CommandBuffer
        ## windows
        build* {.importc: "build".}: cint
        use_pool* {.importc: "use_pool".}: cint
        pool* {.importc: "pool".}: Pool
        begin* {.importc: "begin".}: ptr Window
        `end`* {.importc: "end".}: ptr Window
        active* {.importc: "active".}: ptr Window
        current* {.importc: "current".}: ptr Window
        freelist* {.importc: "freelist".}: ptr PageElement
        count* {.importc: "count".}: cuint
        seq* {.importc: "seq".}: cuint

else:
  when defined(commandUserdata):
    type
      Context* {.importc: "struct nk_context", header: "src/nuklear.h".} = object
        input* {.importc: "input".}: Input
        ## public: can be accessed freely
        style* {.importc: "style".}: Style
        memory* {.importc: "memory".}: Buffer
        clip* {.importc: "clip".}: Clipboard
        last_widget_state* {.importc: "last_widget_state".}: Flags
        delta_time_seconds* {.importc: "delta_time_seconds".}: cfloat
        button_behavior* {.importc: "button_behavior".}: ButtonBehavior
        stacks* {.importc: "stacks".}: ConfigurationStacks
        ## private:
        ##    should only be accessed if you
        ##    know what you are doing
        userdata* {.importc: "userdata".}: Handle
        ## text editor objects are quite big because of an internal
        ##      undo/redo stack. Therefore does not make sense to have one for
        ##      each window for temporary use cases, so I only provide *one* instance
        ##      for all windows. This works because the content is cleared anyway
        text_edit* {.importc: "text_edit".}: TextEdit
        ## draw buffer used for overlay drawing operation like cursor
        overlay* {.importc: "overlay".}: CommandBuffer
        ## windows
        build* {.importc: "build".}: cint
        use_pool* {.importc: "use_pool".}: cint
        pool* {.importc: "pool".}: Pool
        begin* {.importc: "begin".}: ptr Window
        `end`* {.importc: "end".}: ptr Window
        active* {.importc: "active".}: ptr Window
        current* {.importc: "current".}: ptr Window
        freelist* {.importc: "freelist".}: ptr PageElement
        count* {.importc: "count".}: cuint
        seq* {.importc: "seq".}: cuint

  else:
    type
      Context* {.importc: "struct nk_context", header: "src/nuklear.h".} = object
        input* {.importc: "input".}: Input
        ## public: can be accessed freely
        style* {.importc: "style".}: Style
        memory* {.importc: "memory".}: Buffer
        clip* {.importc: "clip".}: Clipboard
        last_widget_state* {.importc: "last_widget_state".}: Flags
        delta_time_seconds* {.importc: "delta_time_seconds".}: cfloat
        button_behavior* {.importc: "button_behavior".}: ButtonBehavior
        stacks* {.importc: "stacks".}: ConfigurationStacks
        ## private:
        ##    should only be accessed if you
        ##    know what you are doing
        ## text editor objects are quite big because of an internal
        ##      undo/redo stack. Therefore does not make sense to have one for
        ##      each window for temporary use cases, so I only provide *one* instance
        ##      for all windows. This works because the content is cleared anyway
        text_edit* {.importc: "text_edit".}: TextEdit ## draw buffer used for overlay drawing operation like cursor
        overlay* {.importc: "overlay".}: CommandBuffer ## windows
        build* {.importc: "build".}: cint
        use_pool* {.importc: "use_pool".}: cint
        pool* {.importc: "pool".}: Pool
        begin* {.importc: "begin".}: ptr Window
        `end`* {.importc: "end".}: ptr Window
        active* {.importc: "active".}: ptr Window
        current* {.importc: "current".}: ptr Window
        freelist* {.importc: "freelist".}: ptr PageElement
        count* {.importc: "count".}: cuint
        seq* {.importc: "seq".}: cuint

{.push cdecl, header: "src/nuklear.h".}

## context
when defined(defaultAllocator):
  proc init_default*(a2: ptr Context; a3: ptr UserFont): cint {.importc: "nk_init_default".}
proc init_fixed*(a2: ptr Context; memory: pointer; size: csize; a5: ptr UserFont): cint {.importc: "nk_init_fixed".}
proc init_custom*(a2: ptr Context; cmds: ptr Buffer; pool: ptr Buffer; a5: ptr UserFont): cint {.importc: "nk_init_custom".}
proc init*(a2: ptr Context; a3: ptr Allocator; a4: ptr UserFont): cint {.importc: "nk_init".}
proc clear*(a2: ptr Context) {.importc: "nk_clear".}
proc free*(a2: ptr Context) {.importc: "nk_free".}
when defined(commandUserdata):
  proc set_user_data*(a2: ptr Context; handle: Handle) {.importc: "nk_set_user_data".}

## Window
proc begin*(a2: ptr Context; a3: ptr Panel; title: cstring; bounds: Rect; flags: Flags): cint {.importc: "nk_begin".}
proc beginTitled*(a2: ptr Context; a3: ptr Panel; name: cstring; title: cstring;
                  bounds: Rect; flags: Flags): cint {.importc: "nk_begin_titled".}
proc `end`*(a2: ptr Context) {.importc: "nk_end".}
proc findWindow*(ctx: ptr Context; name: cstring): ptr Window {.importc: "nk_window_find".}
proc getWindowBounds*(a2: ptr Context): Rect {.importc: "nk_window_get_bounds".}
proc getWindowPosition*(a2: ptr Context): Vec2 {.importc: "nk_window_get_position".}
proc getWindowSize*(a2: ptr Context): Vec2 {.importc: "nk_window_get_size".}
proc getWindowWidth*(a2: ptr Context): cfloat {.importc: "nk_window_get_width".}
proc getWindowHeight*(a2: ptr Context): cfloat {.importc: "nk_window_get_height".}
proc getWindowPanel*(a2: ptr Context): ptr Panel {.importc: "nk_window_get_panel".}
proc getWindowContentRegion*(a2: ptr Context): Rect {.importc: "nk_window_get_content_region".}
proc getWindowContentRegionMin*(a2: ptr Context): Vec2 {.importc: "nk_window_get_content_region_min".}
proc getWindowContentRegionMax*(a2: ptr Context): Vec2 {.importc: "nk_window_get_content_region_max".}
proc getWindowContentRegionSize*(a2: ptr Context): Vec2 {.importc: "nk_window_get_content_region_size".}
proc getWindowCanvas*(a2: ptr Context): ptr CommandBuffer {.importc: "nk_window_get_canvas".}
proc window_has_focus*(a2: ptr Context): cint {.importc: "nk_window_has_focus".}
proc window_is_collapsed*(a2: ptr Context; a3: cstring): cint {.importc: "nk_window_is_collapsed".}
proc window_is_closed*(a2: ptr Context; a3: cstring): cint {.importc: "nk_window_is_closed".}
proc window_is_hidden*(a2: ptr Context; a3: cstring): cint {.importc: "nk_window_is_hidden".}
proc window_is_active*(a2: ptr Context; a3: cstring): cint {.importc: "nk_window_is_active".}
proc window_is_hovered*(a2: ptr Context): cint {.importc: "nk_window_is_hovered".}
proc window_is_any_hovered*(a2: ptr Context): cint {.importc: "nk_window_is_any_hovered".}
proc item_is_any_active*(a2: ptr Context): cint {.importc: "nk_item_is_any_active".}
proc window_set_bounds*(a2: ptr Context; a3: Rect) {.importc: "nk_window_set_bounds".}
proc window_set_position*(a2: ptr Context; a3: Vec2) {.importc: "nk_window_set_position".}
proc window_set_size*(a2: ptr Context; a3: Vec2) {.importc: "nk_window_set_size".}
proc window_set_focus*(a2: ptr Context; name: cstring) {.importc: "nk_window_set_focus".}
proc window_close*(ctx: ptr Context; name: cstring) {.importc: "nk_window_close".}
proc window_collapse*(a2: ptr Context; name: cstring; a4: CollapseStates) {.importc: "nk_window_collapse".}
proc window_collapse_if*(a2: ptr Context; name: cstring; a4: CollapseStates; cond: cint) {.importc: "nk_window_collapse_if".}
proc window_show*(a2: ptr Context; name: cstring; a4: ShowStates) {.importc: "nk_window_show".}
proc window_show_if*(a2: ptr Context; name: cstring; a4: ShowStates; cond: cint) {.importc: "nk_window_show_if".}

## Layout
proc layout_row_dynamic*(a2: ptr Context; height: cfloat; cols: cint) {.importc: "nk_layout_row_dynamic".}
proc layout_row_static*(a2: ptr Context; height: cfloat; item_width: cint; cols: cint) {.importc: "nk_layout_row_static".}
proc layout_row_begin*(a2: ptr Context; a3: LayoutFormat; row_height: cfloat;
                      cols: cint) {.importc: "nk_layout_row_begin".}
proc layout_row_push*(a2: ptr Context; value: cfloat) {.importc: "nk_layout_row_push".}
proc layout_row_end*(a2: ptr Context) {.importc: "nk_layout_row_end".}
proc layout_row*(a2: ptr Context; a3: LayoutFormat; height: cfloat; cols: cint;
                ratio: ptr cfloat) {.importc: "nk_layout_row".}
proc layout_space_begin*(a2: ptr Context; a3: LayoutFormat; height: cfloat;
                        widget_count: cint) {.importc: "nk_layout_space_begin".}
proc layout_space_push*(a2: ptr Context; a3: Rect) {.importc: "nk_layout_space_push".}
proc layout_space_end*(a2: ptr Context) {.importc: "nk_layout_space_end".}
proc layout_space_bounds*(a2: ptr Context): Rect {.importc: "nk_layout_space_bounds".}
proc layout_space_to_screen*(a2: ptr Context; a3: Vec2): Vec2 {.importc: "nk_layout_space_to_screen".}
proc layout_space_to_local*(a2: ptr Context; a3: Vec2): Vec2 {.importc: "nk_layout_space_to_local".}
proc layout_space_rect_to_screen*(a2: ptr Context; a3: Rect): Rect {.importc: "nk_layout_space_rect_to_screen".}
proc layout_space_rect_to_local*(a2: ptr Context; a3: Rect): Rect {.importc: "nk_layout_space_rect_to_local".}
proc layout_ratio_from_pixel*(a2: ptr Context; pixel_width: cfloat): cfloat {.importc: "nk_layout_ratio_from_pixel".}

## Layout: Group
proc group_begin*(a2: ptr Context; a3: ptr Panel; title: cstring; a5: Flags): cint {.importc: "nk_group_begin".}
proc group_end*(a2: ptr Context) {.importc: "nk_group_end".}

{.pop.}

## Layout: Tree
template tree_push*(ctx: ptr Context, typ: TreeType, title: string, state: CollapseStates): cint =
  let
    pos = instantiationInfo()
    fileLine = pos.filename & ":" & $pos.line

  tree_push_hashed(ctx, typ, title, state, fileLine, strlen(fileLine), pos.line.cint)

template tree_push_id*(ctx: ptr Context, typ: TreeType, title: string, state: CollapseStates, id: cint): cint =
  let
    pos = instantiationInfo()
    fileLine = pos.filename & ":" & $pos.line

  tree_push_hashed(ctx, typ, title, state, fileLine, strlen(fileLine), id)

proc tree_push_hashed*(a2: ptr Context; a3: TreeType; title: cstring;
                      initial_state: CollapseStates; hash: cstring; len: cint;
                      seed: cint): cint {.cdecl, importc: "nk_tree_push_hashed",
                                       header: "src/nuklear.h".}

template tree_image_push*(ctx: ptr Context, typ: TreeType, img: Image, title: string, state: CollapseStates): cint =
  let
    pos = instantiationInfo()
    fileLine = pos.filename & ":" & $pos.line

  tree_image_push_hashed(ctx, typ, img, title, state, fileLine, strlen(fileLine), pos.line)

template tree_image_push_id*(ctx: ptr Context, typ: TreeType, img: Image, title: string, state: CollapseStates, id: cint): cint =
  let
    pos = instantiationInfo()
    fileLine = pos.filename & ":" & $pos.line

  tree_image_push_hashed(ctx, typ, img, title, state, fileLine, strlen(fileLine), id)

{.push cdecl, header: "src/nuklear.h".}

proc tree_image_push_hashed*(a2: ptr Context; a3: TreeType; a4: Image; title: cstring;
                            initial_state: CollapseStates; hash: cstring;
                            len: cint; seed: cint): cint {.importc: "nk_tree_image_push_hashed".}

proc tree_pop*(a2: ptr Context) {.importc: "nk_tree_pop".}

## Widgets
proc text*(a2: ptr Context; a3: cstring; a4: cint; a5: Flags) {.importc: "nk_text".}
proc text_colored*(a2: ptr Context; a3: cstring; a4: cint; a5: Flags; a6: Color) {.importc: "nk_text_colored".}
proc text_wrap*(a2: ptr Context; a3: cstring; a4: cint) {.importc: "nk_text_wrap".}
proc text_wrap_colored*(a2: ptr Context; a3: cstring; a4: cint; a5: Color) {.importc: "nk_text_wrap_colored".}
proc label*(a2: ptr Context; a3: cstring; align: Flags) {.importc: "nk_label".}
proc label_colored*(a2: ptr Context; a3: cstring; align: Flags; a5: Color) {.importc: "nk_label_colored".}
proc label_wrap*(a2: ptr Context; a3: cstring) {.importc: "nk_label_wrap".}
proc label_colored_wrap*(a2: ptr Context; a3: cstring; a4: Color) {.importc: "nk_label_colored_wrap".}
proc image*(a2: ptr Context; a3: Image) {.importc: "nk_image".}
when defined(standardVarargs):
  proc labelf*(a2: ptr Context; a3: Flags; a4: cstring) {.varargs, importc: "nk_labelf".}
  proc labelf_colored*(a2: ptr Context; align: Flags; a4: Color; a5: cstring) {.varargs, importc: "nk_labelf_colored".}
  proc labelf_wrap*(a2: ptr Context; a3: cstring) {.varargs, importc: "nk_labelf_wrap".}
  proc labelf_colored_wrap*(a2: ptr Context; a3: Color; a4: cstring) {.varargs, importc: "nk_labelf_colored_wrap".}
  proc value_bool*(a2: ptr Context; prefix: cstring; a4: cint) {.importc: "nk_value_bool".}
  proc value_int*(a2: ptr Context; prefix: cstring; a4: cint) {.importc: "nk_value_int".}
  proc value_uint*(a2: ptr Context; prefix: cstring; a4: cuint) {.importc: "nk_value_uint".}
  proc value_float*(a2: ptr Context; prefix: cstring; a4: cfloat) {.importc: "nk_value_float".}
  proc value_color_byte*(a2: ptr Context; prefix: cstring; a4: Color) {.importc: "nk_value_color_byte".}
  proc value_color_float*(a2: ptr Context; prefix: cstring; a4: Color) {.importc: "nk_value_color_float".}
  proc value_color_hex*(a2: ptr Context; prefix: cstring; a4: Color) {.importc: "nk_value_color_hex".}

## Widgets: Buttons
proc button_text*(a2: ptr Context; title: cstring; len: cint): cint {.importc: "nk_button_text".}
proc button_label*(a2: ptr Context; title: cstring): cint {.importc: "nk_button_label".}
proc button_color*(a2: ptr Context; a3: Color): cint {.importc: "nk_button_color".}
proc button_symbol*(a2: ptr Context; a3: SymbolType): cint {.importc: "nk_button_symbol".}
proc button_image*(a2: ptr Context; img: Image): cint {.importc: "nk_button_image".}
proc button_symbol_label*(a2: ptr Context; a3: SymbolType; a4: cstring;
                         text_alignment: Flags): cint {.importc: "nk_button_symbol_label".}
proc button_symbol_text*(a2: ptr Context; a3: SymbolType; a4: cstring; a5: cint;
                        alignment: Flags): cint {.importc: "nk_button_symbol_text".}
proc button_image_label*(a2: ptr Context; img: Image; a4: cstring; text_alignment: Flags): cint {.importc: "nk_button_image_label".}
proc button_image_text*(a2: ptr Context; img: Image; a4: cstring; a5: cint;
                       alignment: Flags): cint {.importc: "nk_button_image_text".}
proc button_set_behavior*(a2: ptr Context; a3: ButtonBehavior) {.importc: "nk_button_set_behavior".}
proc button_push_behavior*(a2: ptr Context; a3: ButtonBehavior): cint {.importc: "nk_button_push_behavior".}
proc button_pop_behavior*(a2: ptr Context): cint {.importc: "nk_button_pop_behavior".}

## Widgets: Checkbox
proc check_label*(a2: ptr Context; a3: cstring; active: cint): cint {.importc: "nk_check_label".}
proc check_text*(a2: ptr Context; a3: cstring; a4: cint; active: cint): cint {.importc: "nk_check_text".}
proc check_flags_label*(a2: ptr Context; a3: cstring; flags: cuint; value: cuint): cuint {.importc: "nk_check_flags_label".}
proc check_flags_text*(a2: ptr Context; a3: cstring; a4: cint; flags: cuint; value: cuint): cuint {.importc: "nk_check_flags_text".}
proc checkbox_label*(a2: ptr Context; a3: cstring; active: ptr cint): cint {.importc: "nk_checkbox_label".}
proc checkbox_text*(a2: ptr Context; a3: cstring; a4: cint; active: ptr cint): cint {.importc: "nk_checkbox_text".}
proc checkbox_flags_label*(a2: ptr Context; a3: cstring; flags: ptr cuint; value: cuint): cint {.importc: "nk_checkbox_flags_label".}
proc checkbox_flags_text*(a2: ptr Context; a3: cstring; a4: cint; flags: ptr cuint;
                         value: cuint): cint {.importc: "nk_checkbox_flags_text".}

## Widgets: Radio
proc radio_label*(a2: ptr Context; a3: cstring; active: ptr cint): cint {.importc: "nk_radio_label".}
proc radio_text*(a2: ptr Context; a3: cstring; a4: cint; active: ptr cint): cint {.importc: "nk_radio_text".}
proc option_label*(a2: ptr Context; a3: cstring; active: cint): cint {.importc: "nk_option_label".}
proc option_text*(a2: ptr Context; a3: cstring; a4: cint; active: cint): cint {.importc: "nk_option_text".}

## Widgets: Selectable
proc selectable_label*(a2: ptr Context; a3: cstring; align: Flags; value: ptr cint): cint {.importc: "nk_selectable_label".}
proc selectable_text*(a2: ptr Context; a3: cstring; a4: cint; align: Flags;
                     value: ptr cint): cint {.importc: "nk_selectable_text".}
proc selectable_image_label*(a2: ptr Context; a3: Image; a4: cstring; align: Flags;
                            value: ptr cint): cint {.importc: "nk_selectable_image_label".}
proc selectable_image_text*(a2: ptr Context; a3: Image; a4: cstring; a5: cint;
                           align: Flags; value: ptr cint): cint {.importc: "nk_selectable_image_text".}
proc select_label*(a2: ptr Context; a3: cstring; align: Flags; value: cint): cint {.importc: "nk_select_label".}
proc select_text*(a2: ptr Context; a3: cstring; a4: cint; align: Flags; value: cint): cint {.importc: "nk_select_text".}
proc select_image_label*(a2: ptr Context; a3: Image; a4: cstring; align: Flags;
                        value: cint): cint {.importc: "nk_select_image_label".}
proc select_image_text*(a2: ptr Context; a3: Image; a4: cstring; a5: cint; align: Flags;
                       value: cint): cint {.importc: "nk_select_image_text".}

## Widgets: Slider
proc slideFloat*(a2: ptr Context; min: cfloat; val: cfloat; max: cfloat; step: cfloat): cfloat {.importc: "nk_slide_float".}
proc slideInt*(a2: ptr Context; min: cint; val: cint; max: cint; step: cint): cint {.importc: "nk_slide_int".}
proc sliderFloat*(a2: ptr Context; min: cfloat; val: ptr cfloat; max: cfloat; step: cfloat): cint {.importc: "nk_slider_float".}
proc sliderInt*(a2: ptr Context; min: cint; val: ptr cint; max: cint; step: cint): cint {.importc: "nk_slider_int".}

## Widgets: Progressbar
proc progress*(a2: ptr Context; cur: ptr csize; max: csize; modifyable: cint): cint {.importc: "nk_progress".}
proc prog*(a2: ptr Context; cur: csize; max: csize; modifyable: cint): csize {.importc: "nk_prog".}

## Widgets: Color picker
proc colorPicker*(a2: ptr Context; a3: Color; a4: ColorFormat): Color {.importc: "nk_color_picker".}
proc colorPick*(a2: ptr Context; a3: ptr Color; a4: ColorFormat): cint {.importc: "nk_color_pick".}

## Widgets: Property
proc propertyInt*(layout: ptr Context; name: cstring; min: cint; val: ptr cint; max: cint;
                  step: cint; inc_per_pixel: cfloat) {.importc: "nk_property_int".}
proc propertyFloat*(layout: ptr Context; name: cstring; min: cfloat; val: ptr cfloat;
                    max: cfloat; step: cfloat; inc_per_pixel: cfloat) {.importc: "nk_property_float".}
proc propertyDouble*(layout: ptr Context; name: cstring; min: cdouble;
                     val: ptr cdouble; max: cdouble; step: cdouble;
                     inc_per_pixel: cfloat) {.importc: "nk_property_double".}
proc propertyi*(layout: ptr Context; name: cstring; min: cint; val: cint; max: cint;
               step: cint; inc_per_pixel: cfloat): cint {.importc: "nk_propertyi".}
proc propertyf*(layout: ptr Context; name: cstring; min: cfloat; val: cfloat; max: cfloat;
               step: cfloat; inc_per_pixel: cfloat): cfloat {.importc: "nk_propertyf".}
proc propertyd*(layout: ptr Context; name: cstring; min: cdouble; val: cdouble;
               max: cdouble; step: cdouble; inc_per_pixel: cfloat): cdouble {.importc: "nk_propertyd".}

## Widgets: TextEdit
proc edit_string*(a2: ptr Context; a3: Flags; buffer: cstring; len: ptr cint; max: cint;
                 a7: PluginFilter): Flags {.importc: "nk_edit_string".}
proc edit_buffer*(a2: ptr Context; a3: Flags; a4: ptr TextEdit; a5: PluginFilter): Flags {.importc: "nk_edit_buffer".}
proc edit_string_zero_terminated*(a2: ptr Context; a3: Flags; buffer: cstring;
                                 max: cint; a6: PluginFilter): Flags {.importc: "nk_edit_string_zero_terminated".}

## Chart
proc chart_begin*(a2: ptr Context; a3: ChartType; num: cint; min: cfloat; max: cfloat): cint {.importc: "nk_chart_begin".}
proc chart_begin_colored*(a2: ptr Context; a3: ChartType; a4: Color; active: Color;
                         num: cint; min: cfloat; max: cfloat): cint {.importc: "nk_chart_begin_colored".}
proc chart_add_slot*(ctx: ptr Context; a3: ChartType; count: cint; min_value: cfloat;
                    max_value: cfloat) {.importc: "nk_chart_add_slot".}
proc chart_add_slot_colored*(ctx: ptr Context; a3: ChartType; a4: Color; active: Color;
                            count: cint; min_value: cfloat; max_value: cfloat) {.importc: "nk_chart_add_slot_colored".}
proc chart_push*(a2: ptr Context; a3: cfloat): Flags {.importc: "nk_chart_push".}
proc chart_push_slot*(a2: ptr Context; a3: cfloat; a4: cint): Flags {.importc: "nk_chart_push_slot".}
proc chart_end*(a2: ptr Context) {.importc: "nk_chart_end".}
proc plot*(a2: ptr Context; a3: ChartType; values: ptr cfloat; count: cint; offset: cint) {.importc: "nk_plot".}

{.pop.}

proc plot_function*(a2: ptr Context; a3: ChartType; userdata: pointer; value_getter: proc (
    user: pointer; index: cint): cfloat {.cdecl.}; count: cint; offset: cint) {.cdecl,
    importc: "nk_plot_function", header: "src/nuklear.h".}

{.push cdecl, header: "src/nuklear.h".}

## Popups
proc popup_begin*(a2: ptr Context; a3: ptr Panel; a4: PopupType; a5: cstring; a6: Flags;
                 bounds: Rect): cint {.importc: "nk_popup_begin".}
proc popup_close*(a2: ptr Context) {.importc: "nk_popup_close".}
proc popup_end*(a2: ptr Context) {.importc: "nk_popup_end".}

## Combobox
proc combo*(a2: ptr Context; items: cstringArray; count: cint; selected: cint;
           item_height: cint; max_height: cint): cint {.importc: "nk_combo".}
proc comboSeparator*(a2: ptr Context; items_separated_by_separator: cstring;
                     separator: cint; selected: cint; count: cint; item_height: cint;
                     max_height: cint): cint {.importc: "nk_combo_separator".}
proc comboString*(a2: ptr Context; items_separated_by_zeros: cstring; selected: cint;
                  count: cint; item_height: cint; max_height: cint): cint {.importc: "nk_combo_string".}

{.pop.}
proc comboCallback*(a2: ptr Context; item_getter: proc (a2: pointer; a3: cint;
    a4: cstringArray) {.cdecl.}; userdata: pointer; selected: cint; count: cint;
                    item_height: cint; max_height: cint): cint {.cdecl, importc: "nk_combo_callback", header: "src/nuklear.h".}
{.push cdecl, header: "src/nuklear.h".}
proc combobox*(a2: ptr Context; items: cstringArray; count: cint; selected: ptr cint;
              item_height: cint; max_height: cint) {.importc: "nk_combobox".}
proc comboboxString*(a2: ptr Context; items_separated_by_zeros: cstring;
                     selected: ptr cint; count: cint; item_height: cint;
                     max_height: cint) {.importc: "nk_combobox_string".}
proc comboboxSeparator*(a2: ptr Context; items_separated_by_separator: cstring;
                        separator: cint; selected: ptr cint; count: cint;
                        item_height: cint; max_height: cint) {.importc: "nk_combobox_separator".}

{.pop.}

proc comboboxCallback*(a2: ptr Context; item_getter: proc (a2: pointer; a3: cint;
    a4: cstringArray) {.cdecl.}; a4: pointer; selected: ptr cint; count: cint;
                       item_height: cint; max_height: cint) {.cdecl,
    importc: "nk_combobox_callback", header: "src/nuklear.h".}

{.push cdecl, header: "src/nuklear.h".}

## Combobox: abstract
proc combo_begin_text*(a2: ptr Context; a3: ptr Panel; selected: cstring; a5: cint;
                      max_height: cint): cint {.importc: "nk_combo_begin_text".}
proc combo_begin_label*(a2: ptr Context; a3: ptr Panel; selected: cstring;
                       max_height: cint): cint {.importc: "nk_combo_begin_label".}
proc comboBeginColor*(a2: ptr Context; a3: ptr Panel; color: Color; max_height: cint): cint {.
    importc: "nk_combo_begin_color".}
proc combo_begin_symbol*(a2: ptr Context; a3: ptr Panel; a4: SymbolType;
                        max_height: cint): cint {.importc: "nk_combo_begin_symbol".}
proc combo_begin_symbol_label*(a2: ptr Context; a3: ptr Panel; selected: cstring;
                              a5: SymbolType; height: cint): cint {.importc: "nk_combo_begin_symbol_label".}
proc combo_begin_symbol_text*(a2: ptr Context; a3: ptr Panel; selected: cstring;
                             a5: cint; a6: SymbolType; height: cint): cint {.importc: "nk_combo_begin_symbol_text".}
proc combo_begin_image*(a2: ptr Context; a3: ptr Panel; img: Image; max_height: cint): cint {.
    importc: "nk_combo_begin_image".}
proc combo_begin_image_label*(a2: ptr Context; a3: ptr Panel; selected: cstring; a5: Image; height: cint): cint {.importc: "nk_combo_begin_image_label".}
proc combo_begin_image_text*(a2: ptr Context; a3: ptr Panel; selected: cstring; a5: cint; a6: Image; height: cint): cint {.
    importc: "nk_combo_begin_image_text".}
proc combo_item_label*(a2: ptr Context; a3: cstring; alignment: Flags): cint {.
    importc: "nk_combo_item_label".}
proc combo_item_text*(a2: ptr Context; a3: cstring; a4: cint; alignment: Flags): cint {.
    importc: "nk_combo_item_text".}
proc combo_item_image_label*(a2: ptr Context; a3: Image; a4: cstring; alignment: Flags): cint {.
    importc: "nk_combo_item_image_label".}
proc combo_item_image_text*(a2: ptr Context; a3: Image; a4: cstring; a5: cint; alignment: Flags): cint {.
    importc: "nk_combo_item_image_text".}
proc combo_item_symbol_label*(a2: ptr Context; a3: SymbolType; a4: cstring; alignment: Flags): cint {.
    importc: "nk_combo_item_symbol_label".}
proc combo_item_symbol_text*(a2: ptr Context; a3: SymbolType; a4: cstring; a5: cint; alignment: Flags): cint {.
    importc: "nk_combo_item_symbol_text".}
proc comboClose*(a2: ptr Context) {.importc: "nk_combo_close".}
proc comboEnd*(a2: ptr Context) {.importc: "nk_combo_end".}

{.pop.}

## Contextual
proc contextual_begin*(a2: ptr Context; a3: ptr Panel; a4: Flags; a5: Vec2;
                      trigger_bounds: Rect): cint {.cdecl,
    importc: "nk_contextual_begin", header: "src/nuklear.h".}
proc contextual_item_text*(a2: ptr Context; a3: cstring; a4: cint; align: Flags): cint {.
    cdecl, importc: "nk_contextual_item_text", header: "src/nuklear.h".}
proc contextual_item_label*(a2: ptr Context; a3: cstring; align: Flags): cint {.cdecl,
    importc: "nk_contextual_item_label", header: "src/nuklear.h".}
proc contextual_item_image_label*(a2: ptr Context; a3: Image; a4: cstring;
                                 alignment: Flags): cint {.cdecl,
    importc: "nk_contextual_item_image_label", header: "src/nuklear.h".}
proc contextual_item_image_text*(a2: ptr Context; a3: Image; a4: cstring; len: cint;
                                alignment: Flags): cint {.cdecl,
    importc: "nk_contextual_item_image_text", header: "src/nuklear.h".}
proc contextual_item_symbol_label*(a2: ptr Context; a3: SymbolType; a4: cstring;
                                  alignment: Flags): cint {.cdecl,
    importc: "nk_contextual_item_symbol_label", header: "src/nuklear.h".}
proc contextual_item_symbol_text*(a2: ptr Context; a3: SymbolType; a4: cstring;
                                 a5: cint; alignment: Flags): cint {.cdecl,
    importc: "nk_contextual_item_symbol_text", header: "src/nuklear.h".}
proc contextualClose*(a2: ptr Context) {.cdecl, importc: "nk_contextual_close",
                                      header: "src/nuklear.h".}
proc contextualEnd*(a2: ptr Context) {.cdecl, importc: "nk_contextual_end",
                                    header: "src/nuklear.h".}

## Tooltip
proc tooltip*(a2: ptr Context; a3: cstring) {.cdecl, importc: "nk_tooltip", header: "src/nuklear.h".}
proc tooltipBegin*(a2: ptr Context; a3: ptr Panel; width: cfloat): cint {.cdecl, importc: "nk_tooltip_begin", header: "src/nuklear.h".}
proc tooltipEnd*(a2: ptr Context) {.cdecl, importc: "nk_tooltip_end", header: "src/nuklear.h".}

## Menu
proc menubar_begin*(a2: ptr Context) {.cdecl, importc: "nk_menubar_begin",
                                   header: "src/nuklear.h".}
proc menubar_end*(a2: ptr Context) {.cdecl, importc: "nk_menubar_end",
                                 header: "src/nuklear.h".}
proc menu_begin_text*(a2: ptr Context; a3: ptr Panel; a4: cstring; a5: cint; align: Flags;
                     width: cfloat): cint {.cdecl, importc: "nk_menu_begin_text",
    header: "src/nuklear.h".}
proc menu_begin_label*(a2: ptr Context; a3: ptr Panel; a4: cstring; align: Flags;
                      width: cfloat): cint {.cdecl, importc: "nk_menu_begin_label",
    header: "src/nuklear.h".}
proc menu_begin_image*(a2: ptr Context; a3: ptr Panel; a4: cstring; a5: Image;
                      width: cfloat): cint {.cdecl, importc: "nk_menu_begin_image",
    header: "src/nuklear.h".}
proc menu_begin_image_text*(a2: ptr Context; a3: ptr Panel; a4: cstring; a5: cint;
                           align: Flags; a7: Image; width: cfloat): cint {.cdecl,
    importc: "nk_menu_begin_image_text", header: "src/nuklear.h".}
proc menu_begin_image_label*(a2: ptr Context; a3: ptr Panel; a4: cstring; align: Flags;
                            a6: Image; width: cfloat): cint {.cdecl,
    importc: "nk_menu_begin_image_label", header: "src/nuklear.h".}
proc menu_begin_symbol*(a2: ptr Context; a3: ptr Panel; a4: cstring; a5: SymbolType;
                       width: cfloat): cint {.cdecl,
    importc: "nk_menu_begin_symbol", header: "src/nuklear.h".}
proc menu_begin_symbol_text*(a2: ptr Context; a3: ptr Panel; a4: cstring; a5: cint;
                            align: Flags; a7: SymbolType; width: cfloat): cint {.
    cdecl, importc: "nk_menu_begin_symbol_text", header: "src/nuklear.h".}
proc menu_begin_symbol_label*(a2: ptr Context; a3: ptr Panel; a4: cstring; align: Flags;
                             a6: SymbolType; width: cfloat): cint {.cdecl,
    importc: "nk_menu_begin_symbol_label", header: "src/nuklear.h".}
proc menu_item_text*(a2: ptr Context; a3: cstring; a4: cint; align: Flags): cint {.cdecl,
    importc: "nk_menu_item_text", header: "src/nuklear.h".}
proc menu_item_label*(a2: ptr Context; a3: cstring; alignment: Flags): cint {.cdecl,
    importc: "nk_menu_item_label", header: "src/nuklear.h".}
proc menu_item_image_label*(a2: ptr Context; a3: Image; a4: cstring; alignment: Flags): cint {.
    cdecl, importc: "nk_menu_item_image_label", header: "src/nuklear.h".}
proc menu_item_image_text*(a2: ptr Context; a3: Image; a4: cstring; len: cint;
                          alignment: Flags): cint {.cdecl,
    importc: "nk_menu_item_image_text", header: "src/nuklear.h".}
proc menu_item_symbol_text*(a2: ptr Context; a3: SymbolType; a4: cstring; a5: cint;
                           alignment: Flags): cint {.cdecl,
    importc: "nk_menu_item_symbol_text", header: "src/nuklear.h".}
proc menuItemSymbolLabel*(a2: ptr Context; a3: SymbolType; a4: cstring;
                            alignment: Flags): cint {.cdecl,
    importc: "nk_menu_item_symbol_label", header: "src/nuklear.h".}
proc menuClose*(a2: ptr Context) {.cdecl, importc: "nk_menu_close",
                                header: "src/nuklear.h".}
proc menuEnd*(a2: ptr Context) {.cdecl, importc: "nk_menu_end", header: "src/nuklear.h".}

## Drawing
when defined(vertexBufferOutput):
  proc convert*(a2: ptr Context; cmds: ptr Buffer; vertices: ptr Buffer;
               elements: ptr Buffer; a6: ptr ConvertConfig) {.cdecl,
      importc: "nk_convert", header: "src/nuklear.h".}
  proc drawBegin*(a2: ptr Context; a3: ptr Buffer): ptr DrawCommand {.cdecl,
      importc: "nk__draw_begin", header: "src/nuklear.h".}
  proc drawEnd*(a2: ptr Context; a3: ptr Buffer): ptr DrawCommand {.cdecl,
      importc: "nk__draw_end", header: "src/nuklear.h".}
  proc drawNext*(a2: ptr DrawCommand; a3: ptr Buffer; a4: ptr Context): ptr DrawCommand {.
      cdecl, importc: "nk__draw_next", header: "src/nuklear.h".}

## User Input
{.push cdecl, header: "src/nuklear.h".}
proc inputBegin*(a2: ptr Context) {.importc: "nk_input_begin".}
proc inputMotion*(a2: ptr Context; x: cint; y: cint) {.importc: "nk_input_motion".}
proc inputKey*(a2: ptr Context; a3: Keys; down: cint) {.importc: "nk_input_key".}
proc inputButton*(a2: ptr Context; a3: Buttons; x: cint; y: cint; down: cint) {.importc: "nk_input_button".}
proc inputScroll*(a2: ptr Context; y: cfloat) {.importc: "nk_input_scroll".}
proc inputChar*(a2: ptr Context; a3: char) {.importc: "nk_input_char".}
proc inputGlyph*(a2: ptr Context; a3: Glyph) {.importc: "nk_input_glyph".}
proc inputUnicode*(a2: ptr Context; a3: Rune) {.importc: "nk_input_unicode".}
proc inputEnd*(a2: ptr Context) {.importc: "nk_input_end".}
{.pop.}

## Style
proc style_default*(a2: ptr Context) {.cdecl, importc: "nk_style_default",
                                   header: "src/nuklear.h".}
proc style_from_table*(a2: ptr Context; a3: ptr Color) {.cdecl,
    importc: "nk_style_from_table", header: "src/nuklear.h".}
proc style_load_cursor*(a2: ptr Context; a3: StyleCursor; a4: ptr Cursor) {.cdecl,
    importc: "nk_style_load_cursor", header: "src/nuklear.h".}
proc style_load_all_cursors*(a2: ptr Context; a3: ptr Cursor) {.cdecl,
    importc: "nk_style_load_all_cursors", header: "src/nuklear.h".}
proc style_get_color_by_name*(a2: StyleColors): cstring {.cdecl,
    importc: "nk_style_get_color_by_name", header: "src/nuklear.h".}
proc style_set_font*(a2: ptr Context; a3: ptr UserFont) {.cdecl,
    importc: "nk_style_set_font", header: "src/nuklear.h".}
proc style_set_cursor*(a2: ptr Context; a3: StyleCursor): cint {.cdecl,
    importc: "nk_style_set_cursor", header: "src/nuklear.h".}
proc style_show_cursor*(a2: ptr Context) {.cdecl, importc: "nk_style_show_cursor",
                                       header: "src/nuklear.h".}
proc style_hide_cursor*(a2: ptr Context) {.cdecl, importc: "nk_style_hide_cursor",
                                       header: "src/nuklear.h".}

## Style: stack
proc stylePushFont*(a2: ptr Context; a3: ptr UserFont): cint {.cdecl,
    importc: "nk_style_push_font", header: "src/nuklear.h".}
proc stylePushFloat*(a2: ptr Context; a3: ptr cfloat; a4: cfloat): cint {.cdecl,
    importc: "nk_style_push_float", header: "src/nuklear.h".}
proc stylePushVec2*(a2: ptr Context; a3: ptr Vec2; a4: Vec2): cint {.cdecl,
    importc: "nk_style_push_vec2", header: "src/nuklear.h".}
proc stylePushStyleItem*(a2: ptr Context; a3: ptr StyleItem; a4: StyleItem): cint {.
    cdecl, importc: "nk_style_push_style_item", header: "src/nuklear.h".}
proc stylePushFlags*(a2: ptr Context; a3: ptr Flags; a4: Flags): cint {.cdecl,
    importc: "nk_style_push_flags", header: "src/nuklear.h".}
proc stylePushColor*(a2: ptr Context; a3: ptr Color; a4: Color): cint {.cdecl,
    importc: "nk_style_push_color", header: "src/nuklear.h".}
proc stylePopFont*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_font",
    header: "src/nuklear.h".}
proc stylePopFloat*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_float",
    header: "src/nuklear.h".}
proc stylePopVec2*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_vec2",
    header: "src/nuklear.h".}
proc stylePopStyleItem*(a2: ptr Context): cint {.cdecl,
    importc: "nk_style_pop_style_item", header: "src/nuklear.h".}
proc stylePopFlags*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_flags",
    header: "src/nuklear.h".}
proc stylePopColor*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_color",
    header: "src/nuklear.h".}

## Utilities
proc widgetBounds*(a2: ptr Context): Rect {.cdecl, importc: "nk_widget_bounds",
                                        header: "src/nuklear.h".}
proc widgetPosition*(a2: ptr Context): Vec2 {.cdecl, importc: "nk_widget_position",
    header: "src/nuklear.h".}
proc widgetSize*(a2: ptr Context): Vec2 {.cdecl, importc: "nk_widget_size",
                                      header: "src/nuklear.h".}
proc widgetIsHovered*(a2: ptr Context): cint {.cdecl,
    importc: "nk_widget_is_hovered", header: "src/nuklear.h".}
proc widgetIsMouseClicked*(a2: ptr Context; a3: Buttons): cint {.cdecl,
    importc: "nk_widget_is_mouse_clicked", header: "src/nuklear.h".}
proc widgetHasMouseClickDown*(a2: ptr Context; a3: Buttons; down: cint): cint {.
    cdecl, importc: "nk_widget_has_mouse_click_down", header: "src/nuklear.h".}
proc spacing*(a2: ptr Context; cols: cint) {.cdecl, importc: "nk_spacing",
                                       header: "src/nuklear.h".}

## base widget function
proc widget*(a2: ptr Rect; a3: ptr Context): WidgetLayoutStates {.cdecl,
    importc: "nk_widget", header: "src/nuklear.h".}
proc widgetFitting*(a2: ptr Rect; a3: ptr Context; a4: Vec2): WidgetLayoutStates {.
    cdecl, importc: "nk_widget_fitting", header: "src/nuklear.h".}

## color (conversion user --> nuklear)
proc rgb*(r: cint; g: cint; b: cint): Color {.cdecl, importc: "nk_rgb", header: "src/nuklear.h".}
proc rgbIv*(rgb: ptr cint): Color {.cdecl, importc: "nk_rgb_iv", header: "src/nuklear.h".}
proc rgbBv*(rgb: ptr byte): Color {.cdecl, importc: "nk_rgb_bv", header: "src/nuklear.h".}
proc rgbF*(r: cfloat; g: cfloat; b: cfloat): Color {.cdecl, importc: "nk_rgb_f",
    header: "src/nuklear.h".}
proc rgbFv*(rgb: ptr cfloat): Color {.cdecl, importc: "nk_rgb_fv", header: "src/nuklear.h".}
proc rgbHex*(rgb: cstring): Color {.cdecl, importc: "nk_rgb_hex", header: "src/nuklear.h".}
proc rgba*(r: cint; g: cint; b: cint; a: cint): Color {.cdecl, importc: "nk_rgba",
    header: "src/nuklear.h".}
proc rgbaU32*(a2: uint): Color {.cdecl, importc: "nk_rgba_u32", header: "src/nuklear.h".}
proc rgbaIv*(rgba: ptr cint): Color {.cdecl, importc: "nk_rgba_iv", header: "src/nuklear.h".}
proc rgbaBv*(rgba: ptr byte): Color {.cdecl, importc: "nk_rgba_bv", header: "src/nuklear.h".}
proc rgbaF*(r: cfloat; g: cfloat; b: cfloat; a: cfloat): Color {.cdecl,
    importc: "nk_rgba_f", header: "src/nuklear.h".}
proc rgbaFv*(rgba: ptr cfloat): Color {.cdecl, importc: "nk_rgba_fv",
                                    header: "src/nuklear.h".}
proc rgbaHex*(rgb: cstring): Color {.cdecl, importc: "nk_rgba_hex",
                                  header: "src/nuklear.h".}
proc hsv*(h: cint; s: cint; v: cint): Color {.cdecl, importc: "nk_hsv", header: "src/nuklear.h".}
proc hsvFv*(hsv: ptr cint): Color {.cdecl, importc: "nk_hsv_iv", header: "src/nuklear.h".}
proc hsvBv*(hsv: ptr byte): Color {.cdecl, importc: "nk_hsv_bv", header: "src/nuklear.h".}
proc hsvF*(h: cfloat; s: cfloat; v: cfloat): Color {.cdecl, importc: "nk_hsv_f",
    header: "src/nuklear.h".}
proc hsvFv*(hsv: ptr cfloat): Color {.cdecl, importc: "nk_hsv_fv", header: "src/nuklear.h".}
proc hsva*(h: cint; s: cint; v: cint; a: cint): Color {.cdecl, importc: "nk_hsva",
    header: "src/nuklear.h".}
proc hsvaFv*(hsva: ptr cint): Color {.cdecl, importc: "nk_hsva_iv", header: "src/nuklear.h".}
proc hsvaBv*(hsva: ptr byte): Color {.cdecl, importc: "nk_hsva_bv", header: "src/nuklear.h".}
proc hsvaF*(h: cfloat; s: cfloat; v: cfloat; a: cfloat): Color {.cdecl,
    importc: "nk_hsva_f", header: "src/nuklear.h".}
proc hsvaFv*(hsva: ptr cfloat): Color {.cdecl, importc: "nk_hsva_fv",
                                    header: "src/nuklear.h".}

## color (conversion nuklear --> user)
proc colorF*(r: ptr cfloat; g: ptr cfloat; b: ptr cfloat; a: ptr cfloat; a6: Color) {.cdecl,
    importc: "nk_color_f", header: "src/nuklear.h".}
proc colorFv*(rgba_out: ptr cfloat; a3: Color) {.cdecl, importc: "nk_color_fv",
    header: "src/nuklear.h".}
proc colorU32*(a2: Color): uint {.cdecl, importc: "nk_color_u32", header: "src/nuklear.h".}
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
proc colorHsvaB*(h: ptr byte; s: ptr byte; v: ptr byte; a: ptr byte; a6: Color) {.cdecl,
    importc: "nk_color_hsva_b", header: "src/nuklear.h".}
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

##  ==============================================================
##
##                           MEMORY BUFFER
##
##  ===============================================================
##  A basic (double)-buffer with linear allocation and resetting as only
##    freeing policy. The buffer's main purpose is to control all memory management
##    inside the GUI toolkit and still leave memory control as much as possible in
##    the hand of the user while also making sure the library is easy to use if
##    not as much control is needed.
##    In general all memory inside this library can be provided from the user in
##    three different ways.
##
##    The first way and the one providing most control is by just passing a fixed
##    size memory block. In this case all control lies in the hand of the user
##    since he can exactly control where the memory comes from and how much memory
##    the library should consume. Of course using the fixed size API removes the
##    ability to automatically resize a buffer if not enough memory is provided so
##    you have to take over the resizing. While being a fixed sized buffer sounds
##    quite limiting, it is very effective in this library since the actual memory
##    consumption is quite stable and has a fixed upper bound for a lot of cases.
##
##    If you don't want to think about how much memory the library should allocate
##   at all time or have a very dynamic UI with unpredictable memory consumption
##    habits but still want control over memory allocation you can use the dynamic
##    allocator based API. The allocator consists of two callbacks for allocating
##    and freeing memory and optional userdata so you can plugin your own allocator.
##
##    The final and easiest way can be used by defining
##    defaultAllocator which uses the standard library memory
##    allocation functions malloc and free and takes over complete control over
##    memory in this library.
##

when defined(defaultAllocator):
  proc bufferInitDefault*(a2: ptr Buffer) {.cdecl,
      importc: "nk_buffer_init_default", header: "src/nuklear.h".}
proc bufferInit*(a2: ptr Buffer; a3: ptr Allocator; size: csize) {.cdecl,
    importc: "nk_buffer_init", header: "src/nuklear.h".}
proc bufferInitFixed*(a2: ptr Buffer; memory: pointer; size: csize) {.cdecl,
    importc: "nk_buffer_init_fixed", header: "src/nuklear.h".}
proc bufferInfo*(a2: ptr MemoryStatus; a3: ptr Buffer) {.cdecl,
    importc: "nk_buffer_info", header: "src/nuklear.h".}
proc push*(a2: ptr Buffer; kind: BufferAllocationType; memory: pointer;
                 size: csize; align: csize) {.cdecl, importc: "nk_buffer_push",
                                        header: "src/nuklear.h".}
proc mark*(a2: ptr Buffer; kind: BufferAllocationType) {.cdecl,
    importc: "nk_buffer_mark", header: "src/nuklear.h".}
proc reset*(a2: ptr Buffer; kind: BufferAllocationType) {.cdecl,
    importc: "nk_buffer_reset", header: "src/nuklear.h".}
proc clear*(a2: ptr Buffer) {.cdecl, importc: "nk_buffer_clear", header: "src/nuklear.h".}
proc free*(a2: ptr Buffer) {.cdecl, importc: "nk_buffer_free", header: "src/nuklear.h".}
proc memory*(a2: ptr Buffer): pointer {.cdecl, importc: "nk_buffer_memory",
    header: "src/nuklear.h".}
proc memoryConst*(a2: ptr Buffer): pointer {.cdecl,
    importc: "nk_buffer_memory_const", header: "src/nuklear.h".}
proc total*(a2: ptr Buffer): csize {.cdecl, importc: "nk_buffer_total",
                                      header: "src/nuklear.h".}


##  ===============================================================
##
##                       TEXT EDITOR
##
##  ===============================================================
## Editing text in this library is handled by either `nk_edit_string` or
##  `nk_edit_buffer`. But like almost everything in this library there are multiple
##  ways of doing it and a balance between control and ease of use with memory
##  as well as functionality controlled by flags.
##
##  This library generally allows three different levels of memory control:
##  First of is the most basic way of just providing a simple char array with
##  string length. This method is probably the easiest way of handling simple
##  user text input. Main upside is complete control over memory while the biggest
##  downside in comparsion with the other two approaches is missing undo/redo.
##
##  For UIs that require undo/redo the second way was created. It is based on
##  a fixed size nk_text_edit struct, which has an internal undo/redo stack.
##  This is mainly useful if you want something more like a text editor but don't want
##  to have a dynamically growing buffer.
##
##  The final way is using a dynamically growing nk_text_edit struct, which
##  has both a default version if you don't care where memory comes from and an
##  allocator version if you do. While the text editor is quite powerful for its
##  complexity I would not recommend editing gigabytes of data with it.
##  It is rather designed for uses cases which make sense for a GUI library not for
##  an full blown text editor.
##

type
  TextEditType* {.size: sizeof(cint).} = enum
    TEXT_EDIT_SINGLE_LINE, TEXT_EDIT_MULTI_LINE


type
  TextEditMode* {.size: sizeof(cint).} = enum
    TEXT_EDIT_MODE_VIEW, TEXT_EDIT_MODE_INSERT, TEXT_EDIT_MODE_REPLACE

{.push cdecl, header: "src/nuklear.h".}

## filter function

proc filterDefault*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_default".}
proc filterAscii*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_ascii".}
proc filterFloat*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_float".}
proc filterDecimal*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_decimal".}
proc filterHex*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_hex".}
proc filterOct*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_oct".}
proc filterBinary*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_binary".}

## text editor

when defined(defaultAllocator):
  proc initDefault*(a2: ptr TextEdit) {.importc: "nk_textedit_init_default".}
proc init*(a2: ptr TextEdit; a3: ptr Allocator; size: csize) {.importc: "nk_textedit_init".}
proc initFixed*(a2: ptr TextEdit; memory: pointer; size: csize) {.importc: "nk_textedit_init_fixed".}
proc free*(a2: ptr TextEdit) {.importc: "nk_textedit_free".}
proc text*(a2: ptr TextEdit; a3: cstring; total_len: cint) {.importc: "nk_textedit_text".}
proc delete*(a2: ptr TextEdit; where: cint; len: cint) {.importc: "nk_textedit_delete".}
proc deleteSelection*(a2: ptr TextEdit) {.importc: "nk_textedit_delete_selection".}
proc selectAll*(a2: ptr TextEdit) {.importc: "nk_textedit_select_all".}
proc cut*(a2: ptr TextEdit): cint {.importc: "nk_textedit_cut".}
proc paste*(a2: ptr TextEdit; a3: cstring; len: cint): cint {.importc: "nk_textedit_paste".}
proc undo*(a2: ptr TextEdit) {.importc: "nk_textedit_undo".}
proc redo*(a2: ptr TextEdit) {.importc: "nk_textedit_redo".}

{.pop.}

##  ===============================================================
##
##                           FONT
##
##  ===============================================================
##  Font handling in this library was designed to be quite customizable and lets
##    you decide what you want to use and what you want to provide. In this sense
##    there are four different degrees between control and ease of use and two
##    different drawing APIs to provide for.
##
##    So first of the easiest way to do font handling is by just providing a
##    `nk_user_font` struct which only requires the height in pixel of the used
##    font and a callback to calculate the width of a string. This way of handling
##    fonts is best fitted for using the normal draw shape command API were you
##    do all the text drawing yourself and the library does not require any kind
##    of deeper knowledge about which font handling mechanism you use.
##
##    While the first approach works fine if you don't want to use the optional
##    vertex buffer output it is not enough if you do. To get font handling working
##    for these cases you have to provide two additional parameters inside the
##    `nk_user_font`. First a texture atlas handle used to draw text as subimages
##    of a bigger font atlas texture and a callback to query a character's glyph
##    information (offset, size, ...). So it is still possible to provide your own
##    font and use the vertex buffer output.
##
##    The final approach if you do not have a font handling functionality or don't
##    want to use it in this library is by using the optional font baker. This API
##    is divided into a high- and low-level API with different priorities between
##    ease of use and control. Both API's can be used to create a font and
##    font atlas texture and can even be used with or without the vertex buffer
##    output. So it still uses the `nk_user_font` struct and the two different
##    approaches previously stated still work.
##    Now to the difference between the low level API and the high level API. The low
##    level API provides a lot of control over the baking process of the font and
##    provides total control over memory. It consists of a number of functions that
##    need to be called from begin to end and each step requires some additional
##    configuration, so it is a lot more complex than the high-level API.
##    If you don't want to do all the work required for using the low-level API
##    you can use the font atlas API. It provides the same functionality as the
##    low-level API but takes away some configuration and all of memory control and
##    in term provides a easier to use API.
##

when defined(fontBaking):
  type
    FontCoordType* {.size: sizeof(cint).} = enum
      COORD_UV,               ## texture coordinates inside font glyphs are clamped between 0-1
      COORD_PIXEL             ## texture coordinates inside font glyphs are in absolute pixel
  type
    BakedFont* {.importc: "struct nk_baked_font", header: "src/nuklear.h".} = object
      height* {.importc: "height".}: cfloat ## height of the font
      ascent* {.importc: "ascent".}: cfloat
      descent* {.importc: "descent".}: cfloat ## font glyphs ascent and descent
      glyph_offset* {.importc: "glyph_offset".}: Rune ## glyph array offset inside the font glyph baking output array
      glyph_count* {.importc: "glyph_count".}: Rune ## number of glyphs of this font inside the glyph baking array output
      ranges* {.importc: "ranges".}: ptr Rune ## font codepoint ranges as pairs of (from/to) and 0 as last element

  type
    FontConfig* {.importc: "struct nk_font_config", header: "src/nuklear.h".} = object
      next* {.importc: "next".}: ptr FontConfig ## NOTE: only used internally
      ttf_blob* {.importc: "ttf_blob".}: pointer ## pointer to loaded TTF file memory block.
                                             ##      NOTE: not needed for nk_font_atlas_add_from_memory and nk_font_atlas_add_from_file.
      ttf_size* {.importc: "ttf_size".}: csize ## size of the loaded TTF file memory block
                                          ##      NOTE: not needed for nk_font_atlas_add_from_memory and nk_font_atlas_add_from_file.
      ttf_data_owned_by_atlas* {.importc: "ttf_data_owned_by_atlas".}: cuchar ## used inside font atlas:
                                                                          ## default to: 0
      merge_mode* {.importc: "merge_mode".}: cuchar ## merges this font into the last font
      pixel_snap* {.importc: "pixel_snap".}: cuchar ## align very character to pixel boundary (if true set oversample (1,1))
      oversample_v* {.importc: "oversample_v".}: cuchar
      oversample_h* {.importc: "oversample_h".}: cuchar ## rasterize at hight quality for sub-pixel position
      padding* {.importc: "padding".}: array[3, cuchar]
      size* {.importc: "size".}: cfloat ## baked pixel height of the font
      coord_type* {.importc: "coord_type".}: FontCoordType ## texture coordinate format with either pixel or UV coordinates
      spacing* {.importc: "spacing".}: Vec2 ## extra pixel spacing between glyphs
      range* {.importc: "range".}: ptr Rune ## list of unicode ranges (2 values per range, zero terminated)
      font* {.importc: "font".}: ptr BakedFont ## font to setup in the baking process: NOTE: not needed for font atlas
      fallback_glyph* {.importc: "fallback_glyph".}: Rune ## fallback glyph to use if a given rune is not found

  type
    FontGlyph* {.importc: "struct nk_font_glyph", header: "src/nuklear.h".} = object
      codepoint* {.importc: "codepoint".}: Rune
      xadvance* {.importc: "xadvance".}: cfloat
      x0* {.importc: "x0".}: cfloat
      y0* {.importc: "y0".}: cfloat
      x1* {.importc: "x1".}: cfloat
      y1* {.importc: "y1".}: cfloat
      w* {.importc: "w".}: cfloat
      h* {.importc: "h".}: cfloat
      u0* {.importc: "u0".}: cfloat
      v0* {.importc: "v0".}: cfloat
      u1* {.importc: "u1".}: cfloat
      v1* {.importc: "v1".}: cfloat

  type
    Font* {.importc: "struct nk_font", header: "src/nuklear.h".} = object
      next* {.importc: "next".}: ptr Font
      handle* {.importc: "handle".}: UserFont
      info* {.importc: "info".}: BakedFont
      scale* {.importc: "scale".}: cfloat
      glyphs* {.importc: "glyphs".}: ptr FontGlyph
      fallback* {.importc: "fallback".}: ptr FontGlyph
      fallback_codepoint* {.importc: "fallback_codepoint".}: Rune
      texture* {.importc: "texture".}: Handle
      config* {.importc: "config".}: ptr FontConfig

  type
    FontAtlasFormat* {.size: sizeof(cint).} = enum
      FONT_ATLAS_ALPHA8, FONT_ATLAS_RGBA32
  type
    FontAtlas* {.importc: "struct nk_font_atlas", header: "src/nuklear.h".} = object
      pixel* {.importc: "pixel".}: pointer
      tex_width* {.importc: "tex_width".}: cint
      tex_height* {.importc: "tex_height".}: cint
      permanent* {.importc: "permanent".}: Allocator
      temporary* {.importc: "temporary".}: Allocator
      custom* {.importc: "custom".}: Recti
      cursors* {.importc: "cursors".}: array[CURSOR_COUNT, Cursor]
      glyph_count* {.importc: "glyph_count".}: cint
      glyphs* {.importc: "glyphs".}: ptr FontGlyph
      default_font* {.importc: "default_font".}: ptr Font
      fonts* {.importc: "fonts".}: ptr Font
      config* {.importc: "config".}: ptr FontConfig
      font_num* {.importc: "font_num".}: cint

  ## some language glyph codepoint ranges

  {.push cdecl, header: "src/nuklear.h".}

  proc font_default_glyph_ranges*(): ptr Rune {.importc: "nk_font_default_glyph_ranges".}
  proc font_chinese_glyph_ranges*(): ptr Rune {.importc: "nk_font_chinese_glyph_ranges".}
  proc font_cyrillic_glyph_ranges*(): ptr Rune {.importc: "nk_font_cyrillic_glyph_ranges".}
  proc font_korean_glyph_ranges*(): ptr Rune {.importc: "nk_font_korean_glyph_ranges".}
  when defined(defaultAllocator):
    proc initDefault*(a2: ptr FontAtlas) {.importc: "nk_font_atlas_init_default".}
  proc init*(a2: ptr FontAtlas; a3: ptr Allocator) {.importc: "nk_font_atlas_init".}
  proc initCustom*(a2: ptr FontAtlas; persistent: ptr Allocator;
                              transient: ptr Allocator) {.importc: "nk_font_atlas_init_custom".}
  proc begin*(a2: ptr FontAtlas) {.importc: "nk_font_atlas_begin".}
  proc font_config*(pixel_height: cfloat): FontConfig {.importc: "nk_font_config".}
  proc add*(a2: ptr FontAtlas; a3: ptr FontConfig): ptr Font {.importc: "nk_font_atlas_add".}
  when defined(defaultFont):
    proc addDefault*(a2: ptr FontAtlas; height: cfloat;
                     a4: ptr FontConfig = nil): ptr Font {.importc: "nk_font_atlas_add_default".}
  proc addFromMemory*(atlas: ptr FontAtlas; memory: pointer; size: csize;
                      height: cfloat; config: ptr FontConfig = nil): ptr Font {.importc: "nk_font_atlas_add_from_memory".}
  when defined(standardIO):
    proc addFromFile*(atlas: ptr FontAtlas; file_path: cstring;
                      height: cfloat; a5: ptr FontConfig = nil): ptr Font {.importc: "nk_font_atlas_add_from_file".}
  proc addCompressed*(a2: ptr FontAtlas; memory: pointer; size: csize;
                      height: cfloat; a6: ptr FontConfig = nil): ptr Font {.importc: "nk_font_atlas_add_compressed".}
  proc addCompressedBase85*(a2: ptr FontAtlas; data: cstring;
                            height: cfloat; config: ptr FontConfig = nil): ptr Font {.importc: "nk_font_atlas_add_compressed_base85".}
  proc bake*(a2: ptr FontAtlas; width: ptr cint; height: ptr cint;
             a5: FontAtlasFormat): pointer {.importc: "nk_font_atlas_bake".}
  proc `end`*(a2: ptr FontAtlas; tex: Handle; a4: ptr DrawNullTexture) {.importc: "nk_font_atlas_end".}
  proc clear*(a2: ptr FontAtlas) {.importc: "nk_font_atlas_clear".}
  proc findGlyph*(a2: ptr Font; unicode: Rune): ptr FontGlyph {.importc: "nk_font_find_glyph".}

  {.pop.}

##  ===============================================================
##
##                           DRAWING
##
##  ===============================================================
##  This library was designed to be render backend agnostic so it does
##    not draw anything to screen. Instead all drawn shapes, widgets
##    are made of, are buffered into memory and make up a command queue.
##    Each frame therefore fills the command buffer with draw commands
##    that then need to be executed by the user and his own render backend.
##    After that the command buffer needs to be cleared and a new frame can be
##    started. It is probably important to note that the command buffer is the main
##    drawing API and the optional vertex buffer API only takes this format and
##    converts it into a hardware accessible format.
##
##    Draw commands are divided into filled shapes and shape outlines but only
##    filled shapes as well as line, curves and scissor are required to be provided.
##    All other shape drawing commands can be used but are not required. This was
##    done to allow the maximum number of render backends to be able to use this
##    library without you having to do additional work.
##

type
  CommandType* {.size: sizeof(cint).} = enum
    COMMAND_NOP, COMMAND_SCISSOR, COMMAND_LINE, COMMAND_CURVE, COMMAND_RECT,
    COMMAND_RECT_FILLED, COMMAND_RECT_MULTI_COLOR, COMMAND_CIRCLE,
    COMMAND_CIRCLE_FILLED, COMMAND_ARC, COMMAND_ARC_FILLED, COMMAND_TRIANGLE,
    COMMAND_TRIANGLE_FILLED, COMMAND_POLYGON, COMMAND_POLYGON_FILLED,
    COMMAND_POLYLINE, COMMAND_TEXT, COMMAND_IMAGE


## command base and header of every command inside the buffer

when defined(commandUserdata):
  type
    Command* {.importc: "struct nk_command", header: "src/nuklear.h".} = object
      `type`* {.importc: "type".}: CommandType
      next* {.importc: "next".}: csize
      userdata* {.importc: "userdata".}: Handle

else:
  type
    Command* {.importc: "struct nk_command", header: "src/nuklear.h".} = object
      `type`* {.importc: "type".}: CommandType
      next* {.importc: "next".}: csize

type
  command_scissor* {.importc: "struct nk_command_scissor", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort
    w* {.importc: "w".}: cushort
    h* {.importc: "h".}: cushort

  command_line* {.importc: "struct nk_command_line", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    line_thickness* {.importc: "line_thickness".}: cushort
    begin* {.importc: "begin".}: Vec2i
    `end`* {.importc: "end".}: Vec2i
    color* {.importc: "color".}: Color

  command_curve* {.importc: "struct nk_command_curve", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    line_thickness* {.importc: "line_thickness".}: cushort
    begin* {.importc: "begin".}: Vec2i
    `end`* {.importc: "end".}: Vec2i
    ctrl* {.importc: "ctrl".}: array[2, Vec2i]
    color* {.importc: "color".}: Color

  command_rect* {.importc: "struct nk_command_rect", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    rounding* {.importc: "rounding".}: cushort
    line_thickness* {.importc: "line_thickness".}: cushort
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort
    w* {.importc: "w".}: cushort
    h* {.importc: "h".}: cushort
    color* {.importc: "color".}: Color

  command_rect_filled* {.importc: "struct nk_command_rect_filled", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    rounding* {.importc: "rounding".}: cushort
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort
    w* {.importc: "w".}: cushort
    h* {.importc: "h".}: cushort
    color* {.importc: "color".}: Color

  command_rect_multi_color* {.importc: "struct nk_command_rect_multi_color",
                             header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort
    w* {.importc: "w".}: cushort
    h* {.importc: "h".}: cushort
    left* {.importc: "left".}: Color
    top* {.importc: "top".}: Color
    bottom* {.importc: "bottom".}: Color
    right* {.importc: "right".}: Color

  command_triangle* {.importc: "struct nk_command_triangle", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    line_thickness* {.importc: "line_thickness".}: cushort
    a* {.importc: "a".}: Vec2i
    b* {.importc: "b".}: Vec2i
    c* {.importc: "c".}: Vec2i
    color* {.importc: "color".}: Color

  command_triangle_filled* {.importc: "struct nk_command_triangle_filled",
                            header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    a* {.importc: "a".}: Vec2i
    b* {.importc: "b".}: Vec2i
    c* {.importc: "c".}: Vec2i
    color* {.importc: "color".}: Color

  command_circle* {.importc: "struct nk_command_circle", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort
    line_thickness* {.importc: "line_thickness".}: cushort
    w* {.importc: "w".}: cushort
    h* {.importc: "h".}: cushort
    color* {.importc: "color".}: Color

  command_circle_filled* {.importc: "struct nk_command_circle_filled", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort
    w* {.importc: "w".}: cushort
    h* {.importc: "h".}: cushort
    color* {.importc: "color".}: Color

  command_arc* {.importc: "struct nk_command_arc", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    cx* {.importc: "cx".}: cshort
    cy* {.importc: "cy".}: cshort
    r* {.importc: "r".}: cushort
    line_thickness* {.importc: "line_thickness".}: cushort
    a* {.importc: "a".}: array[2, cfloat]
    color* {.importc: "color".}: Color

  command_arc_filled* {.importc: "struct nk_command_arc_filled", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    cx* {.importc: "cx".}: cshort
    cy* {.importc: "cy".}: cshort
    r* {.importc: "r".}: cushort
    a* {.importc: "a".}: array[2, cfloat]
    color* {.importc: "color".}: Color

  command_polygon* {.importc: "struct nk_command_polygon", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    color* {.importc: "color".}: Color
    line_thickness* {.importc: "line_thickness".}: cushort
    point_count* {.importc: "point_count".}: cushort
    points* {.importc: "points".}: array[1, Vec2i]

  command_polygon_filled* {.importc: "struct nk_command_polygon_filled",
                           header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    color* {.importc: "color".}: Color
    point_count* {.importc: "point_count".}: cushort
    points* {.importc: "points".}: array[1, Vec2i]

  command_polyline* {.importc: "struct nk_command_polyline", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    color* {.importc: "color".}: Color
    line_thickness* {.importc: "line_thickness".}: cushort
    point_count* {.importc: "point_count".}: cushort
    points* {.importc: "points".}: array[1, Vec2i]

  command_image* {.importc: "struct nk_command_image", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort
    w* {.importc: "w".}: cushort
    h* {.importc: "h".}: cushort
    img* {.importc: "img".}: Image
    col* {.importc: "col".}: Color

  command_text* {.importc: "struct nk_command_text", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: Command
    font* {.importc: "font".}: ptr UserFont
    background* {.importc: "background".}: Color
    foreground* {.importc: "foreground".}: Color
    x* {.importc: "x".}: cshort
    y* {.importc: "y".}: cshort
    w* {.importc: "w".}: cushort
    h* {.importc: "h".}: cushort
    height* {.importc: "height".}: cfloat
    length* {.importc: "length".}: cint
    string* {.importc: "string".}: array[1, char]

  CommandClipping* {.size: sizeof(cint).} = enum
    CLIPPING_OFF = false, CLIPPING_ON = true

{.push cdecl, header: "src/nuklear.h".}

## shape outlines

proc strokeLine*(b: ptr CommandBuffer; x0: cfloat; y0: cfloat; x1: cfloat; y1: cfloat;
                 line_thickness: cfloat; a8: Color) {.importc: "nk_stroke_line".}
proc strokeCurve*(a2: ptr CommandBuffer; a3: cfloat; a4: cfloat; a5: cfloat; a6: cfloat;
                  a7: cfloat; a8: cfloat; a9: cfloat; a10: cfloat;
                  line_thickness: cfloat; a12: Color) {.importc: "nk_stroke_curve".}
proc strokeRect*(a2: ptr CommandBuffer; a3: Rect; rounding: cfloat;
                 line_thickness: cfloat; a6: Color) {.importc: "nk_stroke_rect".}
proc strokeCircle*(a2: ptr CommandBuffer; a3: Rect; line_thickness: cfloat; a5: Color) {.
    importc: "nk_stroke_circle".}
proc strokeArc*(a2: ptr CommandBuffer; cx: cfloat; cy: cfloat; radius: cfloat;
                a_min: cfloat; a_max: cfloat; line_thickness: cfloat; a9: Color) {.
    importc: "nk_stroke_arc".}
proc strokeTriangle*(a2: ptr CommandBuffer; a3: cfloat; a4: cfloat; a5: cfloat;
                     a6: cfloat; a7: cfloat; a8: cfloat; line_thichness: cfloat;
                     a10: Color) {.importc: "nk_stroke_triangle".}
proc strokePolyline*(a2: ptr CommandBuffer; points: ptr cfloat; point_count: cint;
                     line_thickness: cfloat; col: Color) {.importc: "nk_stroke_polyline".}
proc strokePolygon*(a2: ptr CommandBuffer; a3: ptr cfloat; point_count: cint;
                    line_thickness: cfloat; a6: Color) {.importc: "nk_stroke_polygon".}
## filled shades

proc fillRect*(a2: ptr CommandBuffer; a3: Rect; rounding: cfloat; a5: Color) {.importc: "nk_fill_rect".}
proc fillRectMultiColor*(a2: ptr CommandBuffer; a3: Rect; left: Color; top: Color;
                           right: Color; bottom: Color) {.importc: "nk_fill_rect_multi_color".}
proc fillCircle*(a2: ptr CommandBuffer; a3: Rect; a4: Color) {.importc: "nk_fill_circle".}
proc fillArc*(a2: ptr CommandBuffer; cx: cfloat; cy: cfloat; radius: cfloat;
              a_min: cfloat; a_max: cfloat; a8: Color) {.importc: "nk_fill_arc".}
proc fillTriangle*(a2: ptr CommandBuffer; x0: cfloat; y0: cfloat; x1: cfloat;
                   y1: cfloat; x2: cfloat; y2: cfloat; a9: Color) {.importc: "nk_fill_triangle".}
proc fillPolygon*(a2: ptr CommandBuffer; a3: ptr cfloat; point_count: cint; a5: Color) {.
    importc: "nk_fill_polygon".}

## misc

proc pushScissor*(a2: ptr CommandBuffer; a3: Rect) {.importc: "nk_push_scissor".}
proc drawImage*(a2: ptr CommandBuffer; a3: Rect; a4: ptr Image; a5: Color) {.importc: "nk_draw_image".}
proc drawText*(a2: ptr CommandBuffer; a3: Rect; text: cstring; len: cint;
               a6: ptr UserFont; a7: Color; a8: Color) {.importc: "nk_draw_text".}
proc next*(a2: ptr Context; a3: ptr Command): ptr Command {.importc: "nk__next".}
proc begin*(a2: ptr Context): ptr Command {.importc: "nk__begin".}

{.pop.}

##  ===============================================================
##
##                           INPUT
##
##  ===============================================================

{.push cdecl, header: "src/nuklear.h".}

proc hasMouseClick*(a2: ptr Input; a3: Buttons): cint {.importc: "nk_input_has_mouse_click".}
proc hasMouseClickInRect*(a2: ptr Input; a3: Buttons; a4: Rect): cint {.importc: "nk_input_has_mouse_click_in_rect".}
proc hasMouseClickDownInRect*(a2: ptr Input; a3: Buttons; a4: Rect;
                                        down: cint): cint {.importc: "nk_input_has_mouse_click_down_in_rect".}
proc isMouseClickInRect*(a2: ptr Input; a3: Buttons; a4: Rect): cint {.importc: "nk_input_is_mouse_click_in_rect".}
proc isMouseClickDownInRect*(i: ptr Input; id: Buttons; b: Rect; down: cint): cint {.
    importc: "nk_input_is_mouse_click_down_in_rect".}
proc anyMouseClickInRect*(a2: ptr Input; a3: Rect): cint {.importc: "nk_input_any_mouse_click_in_rect".}
proc isMousePrevHoveringRect*(a2: ptr Input; a3: Rect): cint {.importc: "nk_input_is_mouse_prev_hovering_rect".}
proc isMouseHoveringRect*(a2: ptr Input; a3: Rect): cint {.importc: "nk_input_is_mouse_hovering_rect".}
proc mouseClicked*(a2: ptr Input; a3: Buttons; a4: Rect): cint {.importc: "nk_input_mouse_clicked".}
proc isMouseDown*(a2: ptr Input; a3: Buttons): cint {.importc: "nk_input_is_mouse_down".}
proc isMousePressed*(a2: ptr Input; a3: Buttons): cint {.importc: "nk_input_is_mouse_pressed".}
proc isMouseReleased*(a2: ptr Input; a3: Buttons): cint {.importc: "nk_input_is_mouse_released".}
proc isKeyPressed*(a2: ptr Input; a3: Keys): cint {.importc: "nk_input_is_key_pressed".}
proc isKeyReleased*(a2: ptr Input; a3: Keys): cint {.importc: "nk_input_is_key_released".}
proc isKeyDown*(a2: ptr Input; a3: Keys): cint {.importc: "nk_input_is_key_down".}

{.pop.}

## ===============================================================
##
##                           DRAW LIST
##
##  ===============================================================
when defined(vertexBufferOutput):
  {.push cdecl, header: "src/nuklear.h".}

  ## draw list
  proc draw_list_init*(a2: ptr DrawList) {.importc: "nk_draw_list_init".}
  proc draw_list_setup*(canvas: ptr DrawList; config: ptr ConvertConfig;
                       cmds: ptr Buffer; vertices: ptr Buffer; elements: ptr Buffer) {.
      importc: "nk_draw_list_setup".}
  proc draw_list_clear*(a2: ptr DrawList) {.importc: "nk_draw_list_clear".}

  ## drawing
  proc draw_list_begin*(a2: ptr DrawList; a3: ptr Buffer): ptr DrawCommand {.
      importc: "nk__draw_list_begin".}
  proc draw_list_next*(a2: ptr DrawCommand; a3: ptr Buffer; a4: ptr DrawList): ptr DrawCommand {.
      importc: "nk__draw_list_next".}
  proc draw_list_end*(a2: ptr DrawList; a3: ptr Buffer): ptr DrawCommand {.
      importc: "nk__draw_list_end".}
  proc draw_list_clear*(list: ptr DrawList) {.importc: "nk_draw_list_clear".}

  ## path
  proc pathClear*(a2: ptr DrawList) {.importc: "nk_draw_list_path_clear".}
  proc pathLineTo*(list: ptr DrawList; pos: Vec2) {.
      importc: "nk_draw_list_path_line_to".}
  proc pathArcToFast*(a2: ptr DrawList; center: Vec2; radius: cfloat;
                                  a_min: cint; a_max: cint) {.
      importc: "nk_draw_list_path_arc_to_fast".}
  proc pathArcTo*(a2: ptr DrawList; center: Vec2; radius: cfloat;
                             a_min: cfloat; a_max: cfloat; segments: cuint) {.
      importc: "nk_draw_list_path_arc_to".}
  proc pathRectTo*(a2: ptr DrawList; a: Vec2; b: Vec2; rounding: cfloat) {.
      importc: "nk_draw_list_path_rect_to".}
  proc pathCurveTo*(a2: ptr DrawList; p2: Vec2; p3: Vec2; p4: Vec2;
                               num_segments: cuint) {.
      importc: "nk_draw_list_path_curve_to".}
  proc pathFill*(a2: ptr DrawList; a3: Color) {.
      importc: "nk_draw_list_path_fill".}
  proc pathStroke*(a2: ptr DrawList; a3: Color; closed: DrawListStroke;
                             thickness: cfloat) {.
      importc: "nk_draw_list_path_stroke".}

  ## stroke
  proc strokeLine*(a2: ptr DrawList; a: Vec2; b: Vec2; a5: Color;
                             thickness: cfloat) {.
      importc: "nk_draw_list_stroke_line".}
  proc strokeRect*(a2: ptr DrawList; rect: Rect; a4: Color;
                             rounding: cfloat; thickness: cfloat) {.
      importc: "nk_draw_list_stroke_rect".}
  proc strokeTriangle*(a2: ptr DrawList; a: Vec2; b: Vec2; c: Vec2; a6: Color;
                                 thickness: cfloat) {.
      importc: "nk_draw_list_stroke_triangle".}
  proc strokeCircle*(a2: ptr DrawList; center: Vec2; radius: cfloat;
                               a5: Color; segs: cuint; thickness: cfloat) {.
      importc: "nk_draw_list_stroke_circle".}
  proc strokeCurve*(a2: ptr DrawList; p0: Vec2; cp0: Vec2; cp1: Vec2;
                              p1: Vec2; a7: Color; segments: cuint; thickness: cfloat) {.
      importc: "nk_draw_list_stroke_curve".}
  proc strokePolyLine*(a2: ptr DrawList; pnts: ptr Vec2; cnt: cuint;
                                  a5: Color; a6: DrawListStroke;
                                  thickness: cfloat; a8: AntiAliasing) {.
      importc: "nk_draw_list_stroke_poly_line".}

  ## fill
  proc fillRect*(a2: ptr DrawList; rect: Rect; a4: Color; rounding: cfloat) {.
      importc: "nk_draw_list_fill_rect".}
  proc fillRectMultiColor*(list: ptr DrawList; rect: Rect; left: Color;
                                       top: Color; right: Color; bottom: Color) {.
      importc: "nk_draw_list_fill_rect_multi_color".}
  proc fillTriangle*(a2: ptr DrawList; a: Vec2; b: Vec2; c: Vec2; a6: Color) {.
      importc: "nk_draw_list_fill_triangle".}
  proc fillCircle*(a2: ptr DrawList; center: Vec2; radius: cfloat;
                             col: Color; segs: cuint) {.
      importc: "nk_draw_list_fill_circle".}
  proc fillPolyConves*(a2: ptr DrawList; points: ptr Vec2; count: cuint;
                                  a5: Color; a6: AntiAliasing) {.
      importc: "nk_draw_list_fill_poly_convex".}

  ## misc
  proc addImage*(a2: ptr DrawList; texture: Image; rect: Rect; a5: Color) {.
      importc: "nk_draw_list_add_image".}
  proc addText*(a2: ptr DrawList; a3: ptr UserFont; a4: Rect; text: cstring;
                          len: cint; font_height: cfloat; a8: Color) {.
      importc: "nk_draw_list_add_text".}
  when defined(commandUserdata):
    proc pushUserdata*(a2: ptr DrawList; userdata: Handle) {.
        importc: "nk_draw_list_push_userdata".}

  {.pop.}


##  ===============================================================
##
##                           GUI
##
##  ===============================================================

{.push cdecl, header: "src/nuklear.h".}
proc styleItemImage*(img: Image): StyleItem {.importc: "nk_style_item_image".}
proc styleItemColor*(a2: Color): StyleItem {.importc: "nk_style_item_color".}
proc styleItemHide*(): StyleItem {.importc: "nk_style_item_hide".}
{.pop.}


##  ==============================================================
##                           PANEL
##  ==============================================================

##  ==============================================================
##                           WINDOW
##  ==============================================================

##  ==============================================================
##                           STACK
##  ==============================================================

##  ==============================================================
##                           CONTEXT
##  ==============================================================

##  ==============================================================
##                           MATH
##  ==============================================================

template MIN*(a, b: untyped): untyped =
  (if (a) < (b): (a) else: (b))

template MAX*(a, b: untyped): untyped =
  (if (a) < (b): (b) else: (a))

template CLAMP*(i, v, x: untyped): untyped =
  (MAX(MIN(v, x), i))

const
  PI* = 3.141592654
  # UTF_INVALID* = 0x0000FFFD
  MAX_FLOAT_PRECISION* = 2

template UNUSED*(x: untyped): untyped =
  ((void)(x))

template SATURATE*(x: untyped): untyped =
  (MAX(0, MIN(1.0, x)))

template LEN*(a: untyped): untyped =
  (sizeof((a) div sizeof((a)[0])))

template ABS*(a: untyped): untyped =
  (if ((a) < 0): - (a) else: (a))

template BETWEEN*(x, a, b: untyped): untyped =
  ((a) <= (x) and (x) <= (b))

template INBOX*(px, py, x, y, w, h: untyped): untyped =
  (BETWEEN(px, x, x + w) and BETWEEN(py, y, y + h))

template INTERSECT*(x0, y0, w0, h0, x1, y1, w1, h1: untyped): untyped =
  (not (((x1 > (x0 + w0)) or ((x1 + w1) < x0) or (y1 > (y0 + h0)) or (y1 + h1) < y0)))

template CONTAINS*(x, y, w, h, bx, by, bw, bh: untyped): untyped =
  (INBOX(x, y, bx, by, bw, bh) and INBOX(x + w, y + h, bx, by, bw, bh))

template vec2_sub*(a, b: Vec2): untyped =
  vec2((a).x - (b).x, (a).y - (b).y)

template vec2_add*(a, b: Vec2): untyped =
  vec2((a).x + (b).x, (a).y + (b).y)

template vec2_len_sqr*(a: Vec2): untyped =
  ((a).x * (a).x + (a).y * (a).y)

template vec2_muls*(a: Vec2, t: untyped): untyped =
  vec2((a).x * (t), (a).y * (t))

template ptr_add*(t, p, i: untyped): untyped =
  (cast[ptr t]((cast[pointer]((cast[ptr byte]((p)) + (i))))))

template ptr_add_const*(t, p, i: untyped): untyped =
  (cast[ptr t]((cast[pointer]((cast[ptr byte]((p)) + (i))))))

template zero_struct*(s: untyped): untyped =
  zeroMem(addr(s), sizeof((s)))

## ==============================================================
##                           ALIGNMENT
## ==============================================================
## Pointer to Integer type conversion for pointer alignment

# when defined(__PTRDIFF_TYPE__): ## # This case should work for GCC
#   template UINT_TO_PTR*(x: expr): expr =
#     (cast[pointer]((__PTRDIFF_TYPE__)(x)))

#   template PTR_TO_UINT*(x: expr): expr =
#     ((size)(__PTRDIFF_TYPE__)(x))

# elif not defined(__GNUC__):     ## # works for compilers other than LLVM
#   template UINT_TO_PTR*(x: expr): expr =
#     (cast[pointer](addr((cast[cstring](0))[x])))

#   template PTR_TO_UINT*(x: expr): expr =
#     ((size)((cast[cstring](x)) - cast[cstring](0)))

# elif defined(USE_FIXED_TYPES): ## # used if we have <stdint.h>
#   template UINT_TO_PTR*(x: expr): expr =
#     (cast[pointer]((uintptr_t)(x)))

#   template PTR_TO_UINT*(x: expr): expr =
#     ((uintptr_t)(x))

# else:
#   template UINT_TO_PTR*(x: expr): expr =
#     (cast[pointer]((x)))

#   template PTR_TO_UINT*(x: expr): expr =
#     ((size)(x))

# template ALIGN_PTR*(x, mask: expr): expr =
#   (UINT_TO_PTR((PTR_TO_UINT(cast[ptr byte]((x)) + (mask - 1)) and not (mask - 1))))

# template ALIGN_PTR_BACK*(x, mask: expr): expr =
#   (UINT_TO_PTR((PTR_TO_UINT(cast[ptr byte]((x))) and not (mask - 1))))

# template OFFSETOF*(st, m: expr): expr =
#   ((`ptr`) and ((cast[ptr st](0)).m))

# template offsetof*(typ, field): untyped =
#   (var dummy: typ; cast[int](addr(dummy.field)) - cast[int](addr(dummy)))

# template CONTAINER_OF*(`ptr`, `type`, member: expr): expr =
#   cast[ptr `type`]((cast[pointer]((cast[cstring]((
#       if 1: (`ptr`) else: addr((cast[ptr `type`](0)).member))) -
#       OFFSETOF(`type`, member)))))
