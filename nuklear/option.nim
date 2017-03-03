import core/nuklear_context

{.push cdecl, header: "src/nuklear.h".}

proc label*(a2: ptr Context; a3: cstring; active: cint): cint {.importc: "nk_option_label".}
proc text*(a2: ptr Context; a3: cstring; a4: cint; active: cint): cint {.importc: "nk_option_text".}

{.pop.}
