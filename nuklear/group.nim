import core/nuklear_context, core/nuklear_panel, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}

## Layout: Group
proc group_begin*(a2: ptr Context; a3: ptr Panel; title: cstring; a5: Flags): cint {.importc: "nk_group_begin".}
proc group_end*(a2: ptr Context) {.importc: "nk_group_end".}

{.pop.}
