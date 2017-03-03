import core/nuklear_context, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}
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

## Utilities
proc bounds*(a2: ptr Context): Rect {.importc: "nk_widget_bounds".}
proc position*(a2: ptr Context): Vec2 {.importc: "nk_widget_position".}
proc size*(a2: ptr Context): Vec2 {.importc: "nk_widget_size".}
proc isHovered*(a2: ptr Context): cint {.importc: "nk_widget_is_hovered".}
proc isMouseClicked*(a2: ptr Context; a3: Buttons): cint {.importc: "nk_widget_is_mouse_clicked".}
proc hasMouseClickDown*(a2: ptr Context; a3: Buttons; down: cint): cint {.importc: "nk_widget_has_mouse_click_down".}
proc spacing*(a2: ptr Context; cols: cint) {.importc: "nk_spacing".}

## base widget function
proc widget*(a2: ptr Rect; a3: ptr Context): WidgetLayoutStates {.importc: "nk_widget".}
proc widgetFitting*(a2: ptr Rect; a3: ptr Context; a4: Vec2): WidgetLayoutStates {.importc: "nk_widget_fitting".}

{.pop.}
