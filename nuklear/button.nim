# {.push cdecl, header: "src/nuklear.h".}
{.pragma: nuklear, cdecl, header: "src/nuklear.h".}

import core/nuklear_api, core/nuklear_context

proc text*(a2: ptr Context; title: cstring; len: cint): cint {.nuklear, importc: "nk_button_text".}
proc label*(a2: ptr Context; title: cstring): cint {.nuklear, importc: "nk_button_label".}
proc color*(a2: ptr Context; a3: Color): cint {.nuklear, importc: "nk_button_color".}
proc symbol*(a2: ptr Context; a3: SymbolType): cint {.nuklear, importc: "nk_button_symbol".}
proc image*(a2: ptr Context; img: Image): cint {.nuklear, importc: "nk_button_image".}
proc symbol_label*(a2: ptr Context; a3: SymbolType; a4: cstring; text_alignment: Flags): cint {.nuklear, importc: "nk_button_symbol_label".}
proc symbol_text*(a2: ptr Context; a3: SymbolType; a4: cstring; a5: cint; alignment: Flags): cint {.nuklear, importc: "nk_button_symbol_text".}
proc image_label*(a2: ptr Context; img: Image; a4: cstring; text_alignment: Flags): cint {.nuklear, importc: "nk_button_image_label".}
proc image_text*(a2: ptr Context; img: Image; a4: cstring; a5: cint; alignment: Flags): cint {.nuklear, importc: "nk_button_image_text".}
proc set_behavior*(a2: ptr Context; a3: ButtonBehavior) {.nuklear, importc: "nk_button_set_behavior".}
proc push_behavior*(a2: ptr Context; a3: ButtonBehavior): cint {.nuklear, importc: "nk_button_push_behavior".}
proc pop_behavior*(a2: ptr Context): cint {.nuklear, importc: "nk_button_pop_behavior".}
# {.pop.}
