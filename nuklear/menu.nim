import core/nuklear_context, core/nuklear_panel, core/nuklear_api

## Menu
proc menubar_begin*(a2: ptr Context) {.cdecl, importc: "nk_menubar_begin",
                                   header: "src/nuklear.h".}
proc menubar_end*(a2: ptr Context) {.cdecl, importc: "nk_menubar_end",
                                 header: "src/nuklear.h".}
proc begin_text*(a2: ptr Context; a3: ptr Panel; a4: cstring; a5: cint; align: Flags;
                     width: cfloat): cint {.cdecl, importc: "nk_menu_begin_text",
    header: "src/nuklear.h".}
proc begin_label*(a2: ptr Context; a3: ptr Panel; a4: cstring; align: Flags;
                      width: cfloat): cint {.cdecl, importc: "nk_menu_begin_label",
    header: "src/nuklear.h".}
proc begin_image*(a2: ptr Context; a3: ptr Panel; a4: cstring; a5: Image;
                      width: cfloat): cint {.cdecl, importc: "nk_menu_begin_image",
    header: "src/nuklear.h".}
proc begin_image_text*(a2: ptr Context; a3: ptr Panel; a4: cstring; a5: cint;
                           align: Flags; a7: Image; width: cfloat): cint {.cdecl,
    importc: "nk_menu_begin_image_text", header: "src/nuklear.h".}
proc begin_image_label*(a2: ptr Context; a3: ptr Panel; a4: cstring; align: Flags;
                            a6: Image; width: cfloat): cint {.cdecl,
    importc: "nk_menu_begin_image_label", header: "src/nuklear.h".}
proc begin_symbol*(a2: ptr Context; a3: ptr Panel; a4: cstring; a5: SymbolType;
                       width: cfloat): cint {.cdecl,
    importc: "nk_menu_begin_symbol", header: "src/nuklear.h".}
proc begin_symbol_text*(a2: ptr Context; a3: ptr Panel; a4: cstring; a5: cint;
                            align: Flags; a7: SymbolType; width: cfloat): cint {.
    cdecl, importc: "nk_menu_begin_symbol_text", header: "src/nuklear.h".}
proc begin_symbol_label*(a2: ptr Context; a3: ptr Panel; a4: cstring; align: Flags;
                             a6: SymbolType; width: cfloat): cint {.cdecl,
    importc: "nk_menu_begin_symbol_label", header: "src/nuklear.h".}
proc item_text*(a2: ptr Context; a3: cstring; a4: cint; align: Flags): cint {.cdecl,
    importc: "nk_menu_item_text", header: "src/nuklear.h".}
proc item_label*(a2: ptr Context; a3: cstring; alignment: Flags): cint {.cdecl,
    importc: "nk_menu_item_label", header: "src/nuklear.h".}
proc item_image_label*(a2: ptr Context; a3: Image; a4: cstring; alignment: Flags): cint {.
    cdecl, importc: "nk_menu_item_image_label", header: "src/nuklear.h".}
proc item_image_text*(a2: ptr Context; a3: Image; a4: cstring; len: cint;
                          alignment: Flags): cint {.cdecl,
    importc: "nk_menu_item_image_text", header: "src/nuklear.h".}
proc item_symbol_text*(a2: ptr Context; a3: SymbolType; a4: cstring; a5: cint;
                           alignment: Flags): cint {.cdecl,
    importc: "nk_menu_item_symbol_text", header: "src/nuklear.h".}
proc itemSymbolLabel*(a2: ptr Context; a3: SymbolType; a4: cstring;
                            alignment: Flags): cint {.cdecl,
    importc: "nk_menu_item_symbol_label", header: "src/nuklear.h".}
proc close*(a2: ptr Context) {.cdecl, importc: "nk_menu_close",
                                header: "src/nuklear.h".}
proc `end`*(a2: ptr Context) {.cdecl, importc: "nk_menu_end", header: "src/nuklear.h".}
