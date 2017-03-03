import core/nuklear_context

{.push cdecl, header: "src/nuklear.h".}
proc label*(a2: ptr Context; a3: cstring; active: cint): cint {.importc: "nk_check_label".}
proc text*(a2: ptr Context; a3: cstring; a4: cint; active: cint): cint {.importc: "nk_check_text".}
proc flags_label*(a2: ptr Context; a3: cstring; flags: cuint; value: cuint): cuint {.importc: "nk_check_flags_label".}
proc flags_text*(a2: ptr Context; a3: cstring; a4: cint; flags: cuint; value: cuint): cuint {.importc: "nk_check_flags_text".}
