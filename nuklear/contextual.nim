import core/nuklear_context, core/nuklear_panel, core/nuklear_api

## Contextual
proc begin*(a2: ptr Context; a3: ptr Panel; a4: Flags; a5: Vec2;
                      trigger_bounds: Rect): cint {.cdecl,
    importc: "nk_contextual_begin", header: "src/nuklear.h".}
proc item_text*(a2: ptr Context; a3: cstring; a4: cint; align: Flags): cint {.
    cdecl, importc: "nk_contextual_item_text", header: "src/nuklear.h".}
proc item_label*(a2: ptr Context; a3: cstring; align: Flags): cint {.cdecl,
    importc: "nk_contextual_item_label", header: "src/nuklear.h".}
proc item_image_label*(a2: ptr Context; a3: Image; a4: cstring;
                                 alignment: Flags): cint {.cdecl,
    importc: "nk_contextual_item_image_label", header: "src/nuklear.h".}
proc item_image_text*(a2: ptr Context; a3: Image; a4: cstring; len: cint;
                                alignment: Flags): cint {.cdecl,
    importc: "nk_contextual_item_image_text", header: "src/nuklear.h".}
proc item_symbol_label*(a2: ptr Context; a3: SymbolType; a4: cstring;
                                  alignment: Flags): cint {.cdecl,
    importc: "nk_contextual_item_symbol_label", header: "src/nuklear.h".}
proc item_symbol_text*(a2: ptr Context; a3: SymbolType; a4: cstring;
                                 a5: cint; alignment: Flags): cint {.cdecl,
    importc: "nk_contextual_item_symbol_text", header: "src/nuklear.h".}
proc close*(a2: ptr Context) {.cdecl, importc: "nk_contextual_close",
                                      header: "src/nuklear.h".}
proc `end`*(a2: ptr Context) {.cdecl, importc: "nk_contextual_end",
                                    header: "src/nuklear.h".}
