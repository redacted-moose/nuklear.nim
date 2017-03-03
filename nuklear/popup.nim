import core/nuklear_context, core/nuklear_panel, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}

## Popups
proc begin*(a2: ptr Context; a3: ptr Panel; a4: PopupType; a5: cstring; a6: Flags;
                 bounds: Rect): cint {.importc: "nk_popup_begin".}
proc close*(a2: ptr Context) {.importc: "nk_popup_close".}
proc `end`*(a2: ptr Context) {.importc: "nk_popup_end".}

{.pop.}
