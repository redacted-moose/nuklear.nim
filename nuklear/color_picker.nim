import core/nuklear_context, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}

## Widgets: Color picker
proc colorPicker*(a2: ptr Context; a3: Color; a4: ColorFormat): Color {.importc: "nk_color_picker".}
proc colorPick*(a2: ptr Context; a3: ptr Color; a4: ColorFormat): cint {.importc: "nk_color_pick".}

{.pop.}
