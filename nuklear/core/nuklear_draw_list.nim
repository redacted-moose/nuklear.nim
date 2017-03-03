{.pragma: nuklear, header: "src/nuklear.h".}

import nuklear_api, nuklear_memory_buffer, nuklear_font

## ===============================================================
##
##                           DRAW LIST
##
## ===============================================================
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

when defined(vertexBufferOutput):
  type
    DrawIndex* = uint16

    DrawListStroke* {.size: sizeof(cint).} = enum
      STROKE_OPEN = false,      ## build up path has no connection back to the beginning
      STROKE_CLOSED = true

    DrawVertexLayoutAttribute* {.size: sizeof(cint).} = enum
      nkVertexPosition, nkVertexColor, nkVertexTexcoord, nkVertexAttributeCount

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
    DrawVertexLayoutElement* {.nuklear, importc: "struct nk_draw_vertex_layout_element".} = object
      attribute* {.importc: "attribute".}: DrawVertexLayoutAttribute
      format* {.importc: "format".}: DrawVertexLayoutFormat
      offset* {.importc: "offset".}: csize

    ConvertConfig* {.nuklear, importc: "struct nk_convert_config".} = object
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

  when defined(commandUserdata):
    type
      DrawCommand* {.nuklear, importc: "struct nk_draw_command".} = object
        elem_count* {.importc: "elem_count".}: cuint ## number of elements in the current draw batch
        clip_rect* {.importc: "clip_rect".}: Rect    ## current screen clipping rectangle
        texture* {.importc: "texture".}: Handle      ## current texture to set
        userdata* {.importc: "userdata".}: Handle

      DrawList* {.nuklear, importc: "struct nk_draw_list".} = object
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
      DrawCommand* {.nuklear, importc: "struct nk_draw_command".} = object
        elem_count* {.importc: "elem_count".}: cuint ## number of elements in the current draw batch
        clip_rect* {.importc: "clip_rect".}: Rect    ## current screen clipping rectangle
        texture* {.importc: "texture".}: Handle      ## current texture to set

      DrawList* {.nuklear, importc: "struct nk_draw_list".} = object
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


  ## draw list
  proc draw_list_init*(a2: ptr DrawList) {.nuklear, importc: "nk_draw_list_init".}
  proc draw_list_setup*(canvas: ptr DrawList; config: ptr ConvertConfig; cmds: ptr Buffer; vertices: ptr Buffer; elements: ptr Buffer) {.nuklear, importc: "nk_draw_list_setup".}
  proc draw_list_clear*(list: ptr DrawList) {.nuklear, importc: "nk_draw_list_clear".}

  {.push cdecl, header: "src/nuklear.h".}
  ## drawing
  proc draw_list_begin*(a2: ptr DrawList; a3: ptr Buffer): ptr DrawCommand {.importc: "nk__draw_list_begin".}
  proc draw_list_next*(a2: ptr DrawCommand; a3: ptr Buffer; a4: ptr DrawList): ptr DrawCommand {.importc: "nk__draw_list_next".}
  proc draw_list_end*(a2: ptr DrawList; a3: ptr Buffer): ptr DrawCommand {.importc: "nk__draw_list_end".}
  # proc draw_list_clear*(a2: ptr DrawList) {.importc: "nk_draw_list_clear".}

  ## path
  proc pathClear*(a2: ptr DrawList) {.importc: "nk_draw_list_path_clear".}
  proc pathLineTo*(list: ptr DrawList; pos: Vec2) {.importc: "nk_draw_list_path_line_to".}
  proc pathArcToFast*(a2: ptr DrawList; center: Vec2; radius: cfloat; a_min: cint; a_max: cint) {.importc: "nk_draw_list_path_arc_to_fast".}
  proc pathArcTo*(a2: ptr DrawList; center: Vec2; radius: cfloat; a_min: cfloat; a_max: cfloat; segments: cuint) {.importc: "nk_draw_list_path_arc_to".}
  proc pathRectTo*(a2: ptr DrawList; a: Vec2; b: Vec2; rounding: cfloat) {.importc: "nk_draw_list_path_rect_to".}
  proc pathCurveTo*(a2: ptr DrawList; p2: Vec2; p3: Vec2; p4: Vec2; num_segments: cuint) {.importc: "nk_draw_list_path_curve_to".}
  proc pathFill*(a2: ptr DrawList; a3: Color) {.importc: "nk_draw_list_path_fill".}
  proc pathStroke*(a2: ptr DrawList; a3: Color; closed: DrawListStroke; thickness: cfloat) {.importc: "nk_draw_list_path_stroke".}

  ## stroke
  proc strokeLine*(a2: ptr DrawList; a: Vec2; b: Vec2; a5: Color; thickness: cfloat) {.importc: "nk_draw_list_stroke_line".}
  proc strokeRect*(a2: ptr DrawList; rect: Rect; a4: Color; rounding: cfloat; thickness: cfloat) {.importc: "nk_draw_list_stroke_rect".}
  proc strokeTriangle*(a2: ptr DrawList; a: Vec2; b: Vec2; c: Vec2; a6: Color; thickness: cfloat) {.importc: "nk_draw_list_stroke_triangle".}
  proc strokeCircle*(a2: ptr DrawList; center: Vec2; radius: cfloat;
                               a5: Color; segs: cuint; thickness: cfloat) {.
      importc: "nk_draw_list_stroke_circle".}
  proc strokeCurve*(a2: ptr DrawList; p0: Vec2; cp0: Vec2; cp1: Vec2;
                              p1: Vec2; a7: Color; segments: cuint; thickness: cfloat) {.
      importc: "nk_draw_list_stroke_curve".}
  proc strokePolyLine*(a2: ptr DrawList; pnts: ptr Vec2; cnt: cuint;
                                  a5: Color; a6: DrawListStroke;
                                  thickness: cfloat; a8: AntiAliasing) {.importc: "nk_draw_list_stroke_poly_line".}

  ## fill
  proc fillRect*(a2: ptr DrawList; rect: Rect; a4: Color; rounding: cfloat) {.importc: "nk_draw_list_fill_rect".}
  proc fillRectMultiColor*(list: ptr DrawList; rect: Rect; left: Color;
                                       top: Color; right: Color; bottom: Color) {.importc: "nk_draw_list_fill_rect_multi_color".}
  proc fillTriangle*(a2: ptr DrawList; a: Vec2; b: Vec2; c: Vec2; a6: Color) {.importc: "nk_draw_list_fill_triangle".}
  proc fillCircle*(a2: ptr DrawList; center: Vec2; radius: cfloat;
                             col: Color; segs: cuint) {.importc: "nk_draw_list_fill_circle".}
  proc fillPolyConvex*(a2: ptr DrawList; points: ptr Vec2; count: cuint;
                                  a5: Color; a6: AntiAliasing) {.importc: "nk_draw_list_fill_poly_convex".}

  ## misc
  proc addImage*(a2: ptr DrawList; texture: Image; rect: Rect; a5: Color) {.importc: "nk_draw_list_add_image".}
  proc addText*(a2: ptr DrawList; a3: ptr UserFont; a4: Rect; text: cstring;
                          len: cint; font_height: cfloat; a8: Color) {.importc: "nk_draw_list_add_text".}

  when defined(commandUserdata):
    proc pushUserdata*(a2: ptr DrawList; userdata: Handle) {.importc: "nk_draw_list_push_userdata".}

  {.pop.}

else:
  type
    DrawCommand* {.nuklear, importc: "struct nk_draw_command".} = object

    DrawVertexLayoutElement* {.nuklear, importc: "struct nk_draw_vertex_layout_element".} = object

    ConvertConfig* {.nuklear, importc: "struct nk_convert_config".} = object
      global_alpha* {.importc: "global_alpha".}: cfloat ## global alpha value
      line_AA* {.importc: "line_AA".}: AntiAliasing ## line anti-aliasing flag can be turned off if you are tight on memory
      shape_AA* {.importc: "shape_AA".}: AntiAliasing ## shape anti-aliasing flag can be turned off if you are tight on memory
      circle_segment_count* {.importc: "circle_segment_count".}: cuint ## number of segments used for circles: default to 22
      arc_segment_count* {.importc: "arc_segment_count".}: cuint ## number of segments used for arcs: default to 22
      curve_segment_count* {.importc: "curve_segment_count".}: cuint ## number of segments used for curves: default to 22
      null* {.importc: "null".}: DrawNullTexture ## handle to texture with a white pixel for shape drawing
      vertex_size* {.importc: "vertex_size".}: csize ## sizeof one vertex for vertex packing
      vertex_alignment* {.importc: "vertex_alignment".}: csize ## vertex alignment: Can be optained by NK_ALIGNOF
