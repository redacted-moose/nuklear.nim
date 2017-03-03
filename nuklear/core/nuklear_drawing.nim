{.pragma: nuklear, cdecl, header: "src/nuklear.h".}

import nuklear_api, nuklear_memory_buffer, nuklear_font

type
  CommandBuffer* {.importc: "struct nk_command_buffer", header: "src/nuklear.h".} = object
    base* {.importc: "base".}: ptr Buffer
    clip* {.importc: "clip".}: Rect
    use_clipping* {.importc: "use_clipping".}: cint
    userdata* {.importc: "userdata".}: Handle
    begin* {.importc: "begin".}: csize
    `end`* {.importc: "end".}: csize
    last* {.importc: "last".}: csize

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

{.pop.}
