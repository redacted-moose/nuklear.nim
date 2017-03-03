{.pragma: nuklear, cdecl, header: "src/nuklear.h".}

import core/nuklear_context, core/nuklear_api, core/nuklear_font, core/nuklear_gui

## Style
proc default*(a2: ptr Context) {.cdecl, importc: "nk_style_default",
                                   header: "src/nuklear.h".}
proc fromTable*(a2: ptr Context; a3: ptr Color) {.cdecl,
    importc: "nk_style_from_table", header: "src/nuklear.h".}
proc loadCursor*(a2: ptr Context; a3: StyleCursor; a4: ptr Cursor) {.cdecl,
    importc: "nk_style_load_cursor", header: "src/nuklear.h".}
proc loadAllCursors*(a2: ptr Context; a3: ptr Cursor) {.cdecl,
    importc: "nk_style_load_all_cursors", header: "src/nuklear.h".}
proc getColorByName*(a2: StyleColors): cstring {.cdecl,
    importc: "nk_style_get_color_by_name", header: "src/nuklear.h".}
proc setFont*(a2: ptr Context; a3: ptr UserFont) {.cdecl,
    importc: "nk_style_set_font", header: "src/nuklear.h".}
proc setCursor*(a2: ptr Context; a3: StyleCursor): cint {.cdecl,
    importc: "nk_style_set_cursor", header: "src/nuklear.h".}
proc showCursor*(a2: ptr Context) {.cdecl, importc: "nk_style_show_cursor",
                                       header: "src/nuklear.h".}
proc hideCursor*(a2: ptr Context) {.cdecl, importc: "nk_style_hide_cursor",
                                       header: "src/nuklear.h".}

## Style: stack
proc push*(a2: ptr Context; a3: ptr UserFont): cint {.cdecl,
    importc: "nk_style_push_font", header: "src/nuklear.h".}
proc push*(a2: ptr Context; a3: ptr cfloat; a4: cfloat): cint {.cdecl,
    importc: "nk_style_push_float", header: "src/nuklear.h".}
proc push*(a2: ptr Context; a3: ptr Vec2; a4: Vec2): cint {.cdecl,
    importc: "nk_style_push_vec2", header: "src/nuklear.h".}
proc push*(a2: ptr Context; a3: ptr StyleItem; a4: StyleItem): cint {.
    cdecl, importc: "nk_style_push_style_item", header: "src/nuklear.h".}
proc push*(a2: ptr Context; a3: ptr Flags; a4: Flags): cint {.cdecl,
    importc: "nk_style_push_flags", header: "src/nuklear.h".}
proc push*(a2: ptr Context; a3: ptr Color; a4: Color): cint {.cdecl,
    importc: "nk_style_push_color", header: "src/nuklear.h".}
proc popFont*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_font",
    header: "src/nuklear.h".}
proc popFloat*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_float",
    header: "src/nuklear.h".}
proc popVec2*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_vec2", header: "src/nuklear.h".}
proc popStyleItem*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_style_item", header: "src/nuklear.h".}
proc popFlags*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_flags", header: "src/nuklear.h".}
proc popColor*(a2: ptr Context): cint {.cdecl, importc: "nk_style_pop_color", header: "src/nuklear.h".}
