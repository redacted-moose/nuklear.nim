import core/nuklear_context

{.push cdecl, header: "src/nuklear.h".}

## Widgets: Radio
proc label*(a2: ptr Context; a3: cstring; active: ptr cint): cint {.importc: "nk_radio_label".}
proc text*(a2: ptr Context; a3: cstring; a4: cint; active: ptr cint): cint {.importc: "nk_radio_text".}

{.pop.}
