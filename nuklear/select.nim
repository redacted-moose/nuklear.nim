import core/nuklear_context, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}

proc select_label*(a2: ptr Context; a3: cstring; align: Flags; value: cint): cint {.importc: "nk_select_label".}
proc select_text*(a2: ptr Context; a3: cstring; a4: cint; align: Flags; value: cint): cint {.importc: "nk_select_text".}
proc select_image_label*(a2: ptr Context; a3: Image; a4: cstring; align: Flags;
                        value: cint): cint {.importc: "nk_select_image_label".}
proc select_image_text*(a2: ptr Context; a3: Image; a4: cstring; a5: cint; align: Flags;
                       value: cint): cint {.importc: "nk_select_image_text".}

{.pop.}
