import core/nuklear_context, core/nuklear_panel

{.push cdecl, header: "src/nuklear.h".}
## Tooltip
proc tooltip*(a2: ptr Context; a3: cstring) {.importc: "nk_tooltip".}
proc begin*(a2: ptr Context; a3: ptr Panel; width: cfloat): cint {.importc: "nk_tooltip_begin".}
proc `end`*(a2: ptr Context) {.importc: "nk_tooltip_end".}

{.pop.}
