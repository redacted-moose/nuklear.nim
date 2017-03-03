import core/nuklear_context, core/nuklear_panel, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}

## Combobox
proc combo*(a2: ptr Context; items: cstringArray; count: cint; selected: cint;
           item_height: cint; max_height: cint): cint {.importc: "nk_combo".}
proc comboSeparator*(a2: ptr Context; items_separated_by_separator: cstring;
                     separator: cint; selected: cint; count: cint; item_height: cint;
                     max_height: cint): cint {.importc: "nk_combo_separator".}
proc comboString*(a2: ptr Context; items_separated_by_zeros: cstring; selected: cint;
                  count: cint; item_height: cint; max_height: cint): cint {.importc: "nk_combo_string".}

## Combobox: abstract
proc begin_text*(a2: ptr Context; a3: ptr Panel; selected: cstring; a5: cint;
                      max_height: cint): cint {.importc: "nk_combo_begin_text".}
proc begin_label*(a2: ptr Context; a3: ptr Panel; selected: cstring;
                       max_height: cint): cint {.importc: "nk_combo_begin_label".}
proc beginColor*(a2: ptr Context; a3: ptr Panel; color: Color; max_height: cint): cint {. importc: "nk_combo_begin_color".}
proc begin_symbol*(a2: ptr Context; a3: ptr Panel; a4: SymbolType;
                        max_height: cint): cint {.importc: "nk_combo_begin_symbol".}
proc begin_symbol_label*(a2: ptr Context; a3: ptr Panel; selected: cstring;
                              a5: SymbolType; height: cint): cint {.importc: "nk_combo_begin_symbol_label".}
proc begin_symbol_text*(a2: ptr Context; a3: ptr Panel; selected: cstring;
                             a5: cint; a6: SymbolType; height: cint): cint {.importc: "nk_combo_begin_symbol_text".}
proc begin_image*(a2: ptr Context; a3: ptr Panel; img: Image; max_height: cint): cint {.
    importc: "nk_combo_begin_image".}
proc begin_image_label*(a2: ptr Context; a3: ptr Panel; selected: cstring; a5: Image; height: cint): cint {.importc: "nk_combo_begin_image_label".}
proc begin_image_text*(a2: ptr Context; a3: ptr Panel; selected: cstring; a5: cint; a6: Image; height: cint): cint {.
    importc: "nk_combo_begin_image_text".}
proc item_label*(a2: ptr Context; a3: cstring; alignment: Flags): cint {.
    importc: "nk_combo_item_label".}
proc item_text*(a2: ptr Context; a3: cstring; a4: cint; alignment: Flags): cint {.
    importc: "nk_combo_item_text".}
proc item_image_label*(a2: ptr Context; a3: Image; a4: cstring; alignment: Flags): cint {.
    importc: "nk_combo_item_image_label".}
proc item_image_text*(a2: ptr Context; a3: Image; a4: cstring; a5: cint; alignment: Flags): cint {.
    importc: "nk_combo_item_image_text".}
proc item_symbol_label*(a2: ptr Context; a3: SymbolType; a4: cstring; alignment: Flags): cint {.
    importc: "nk_combo_item_symbol_label".}
proc item_symbol_text*(a2: ptr Context; a3: SymbolType; a4: cstring; a5: cint; alignment: Flags): cint {.
    importc: "nk_combo_item_symbol_text".}
proc close*(a2: ptr Context) {.importc: "nk_combo_close".}
proc `end`*(a2: ptr Context) {.importc: "nk_combo_end".}

{.pop.}
