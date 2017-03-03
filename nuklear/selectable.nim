import core/nuklear_context, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}

## Widgets: Selectable
proc selectable_label*(a2: ptr Context; a3: cstring; align: Flags; value: ptr cint): cint {.importc: "nk_selectable_label".}
proc selectable_text*(a2: ptr Context; a3: cstring; a4: cint; align: Flags;
                     value: ptr cint): cint {.importc: "nk_selectable_text".}
proc selectable_image_label*(a2: ptr Context; a3: Image; a4: cstring; align: Flags;
                            value: ptr cint): cint {.importc: "nk_selectable_image_label".}
proc selectable_image_text*(a2: ptr Context; a3: Image; a4: cstring; a5: cint;
                           align: Flags; value: ptr cint): cint {.importc: "nk_selectable_image_text".}

{.pop.}
