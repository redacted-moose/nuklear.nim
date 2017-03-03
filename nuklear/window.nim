import core/nuklear_window, core/nuklear_context, core/nuklear_panel, core/nuklear_api, core/nuklear_drawing

{.push cdecl, header: "src/nuklear.h".}

# Window
proc begin*(a2: ptr Context; a3: ptr Panel; title: cstring; bounds: Rect; flags: Flags): cint {.importc: "nk_begin".}
proc beginTitled*(a2: ptr Context; a3: ptr Panel; name: cstring; title: cstring; bounds: Rect; flags: Flags): cint {.importc: "nk_begin_titled".}
proc `end`*(a2: ptr Context) {.importc: "nk_end".}
proc find*(ctx: ptr Context; name: cstring): ptr Window {.importc: "nk_window_find".}
proc getBounds*(a2: ptr Context): Rect {.importc: "nk_window_get_bounds".}
proc getPosition*(a2: ptr Context): Vec2 {.importc: "nk_window_get_position".}
proc getSize*(a2: ptr Context): Vec2 {.importc: "nk_window_get_size".}
proc getWidth*(a2: ptr Context): cfloat {.importc: "nk_window_get_width".}
proc getHeight*(a2: ptr Context): cfloat {.importc: "nk_window_get_height".}
proc getPanel*(a2: ptr Context): ptr Panel {.importc: "nk_window_get_panel".}
proc getContentRegion*(a2: ptr Context): Rect {.importc: "nk_window_get_content_region".}
proc getContentRegionMin*(a2: ptr Context): Vec2 {.importc: "nk_window_get_content_region_min".}
proc getContentRegionMax*(a2: ptr Context): Vec2 {.importc: "nk_window_get_content_region_max".}
proc getContentRegionSize*(a2: ptr Context): Vec2 {.importc: "nk_window_get_content_region_size".}
proc getCanvas*(a2: ptr Context): ptr CommandBuffer {.importc: "nk_window_get_canvas".}
proc hasFocus*(a2: ptr Context): cint {.importc: "nk_window_has_focus".}
proc isCollapsed*(a2: ptr Context; a3: cstring): cint {.importc: "nk_window_is_collapsed".}
proc isClosed*(a2: ptr Context; a3: cstring): cint {.importc: "nk_window_is_closed".}
proc isHidden*(a2: ptr Context; a3: cstring): cint {.importc: "nk_window_is_hidden".}
proc isActive*(a2: ptr Context; a3: cstring): cint {.importc: "nk_window_is_active".}
proc isHovered*(a2: ptr Context): cint {.importc: "nk_window_is_hovered".}
proc isAnyHovered*(a2: ptr Context): cint {.importc: "nk_window_is_any_hovered".}
proc itemIsAnyActive*(a2: ptr Context): cint {.importc: "nk_item_is_any_active".}
proc setBounds*(a2: ptr Context; a3: Rect) {.importc: "nk_window_set_bounds".}
proc setPosition*(a2: ptr Context; a3: Vec2) {.importc: "nk_window_set_position".}
proc setSize*(a2: ptr Context; a3: Vec2) {.importc: "nk_window_set_size".}
proc setFocus*(a2: ptr Context; name: cstring) {.importc: "nk_window_set_focus".}
proc close*(ctx: ptr Context; name: cstring) {.importc: "nk_window_close".}
proc collapse*(a2: ptr Context; name: cstring; a4: CollapseStates) {.importc: "nk_window_collapse".}
proc collapseIf*(a2: ptr Context; name: cstring; a4: CollapseStates; cond: cint) {.importc: "nk_window_collapse_if".}
proc show*(a2: ptr Context; name: cstring; a4: ShowStates) {.importc: "nk_window_show".}
proc showIf*(a2: ptr Context; name: cstring; a4: ShowStates; cond: cint) {.importc: "nk_window_show_if".}

{.pop.}
