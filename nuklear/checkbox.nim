import core/nuklear_context

{.push cdecl, header: "src/nuklear.h".}

## Widgets: Checkbox
proc label*(a2: ptr Context; a3: cstring; active: ptr cint): cint {.importc: "nk_checkbox_label".}
proc text*(a2: ptr Context; a3: cstring; a4: cint; active: ptr cint): cint {.importc: "nk_checkbox_text".}
proc flags_label*(a2: ptr Context; a3: cstring; flags: ptr cuint; value: cuint): cint {.importc: "nk_checkbox_flags_label".}
proc flags_text*(a2: ptr Context; a3: cstring; a4: cint; flags: ptr cuint; value: cuint): cint {.importc: "nk_checkbox_flags_text".}

{.pop.}
