import core/nuklear_context, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}

proc begin*(a2: ptr Context; a3: LayoutFormat; height: cfloat;
                        widget_count: cint) {.importc: "nk_layout_space_begin".}
proc push*(a2: ptr Context; a3: Rect) {.importc: "nk_layout_space_push".}
proc `end`*(a2: ptr Context) {.importc: "nk_layout_space_end".}
proc bounds*(a2: ptr Context): Rect {.importc: "nk_layout_space_bounds".}
proc to_screen*(a2: ptr Context; a3: Vec2): Vec2 {.importc: "nk_layout_space_to_screen".}
proc to_local*(a2: ptr Context; a3: Vec2): Vec2 {.importc: "nk_layout_space_to_local".}
proc rect_to_screen*(a2: ptr Context; a3: Rect): Rect {.importc: "nk_layout_space_rect_to_screen".}
proc rect_to_local*(a2: ptr Context; a3: Rect): Rect {.importc: "nk_layout_space_rect_to_local".}

{.pop.}
