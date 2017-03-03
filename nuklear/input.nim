import core/nuklear_input, core/nuklear_context, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}
proc begin*(a2: ptr Context) {.importc: "nk_input_begin".}
proc motion*(a2: ptr Context; x: cint; y: cint) {.importc: "nk_input_motion".}
proc key*(a2: ptr Context; a3: Keys; down: cint) {.importc: "nk_input_key".}
proc button*(a2: ptr Context; a3: Buttons; x: cint; y: cint; down: cint) {.importc: "nk_input_button".}
proc scroll*(a2: ptr Context; y: cfloat) {.importc: "nk_input_scroll".}
proc char*(a2: ptr Context; a3: char) {.importc: "nk_input_char".}
proc glyph*(a2: ptr Context; a3: Glyph) {.importc: "nk_input_glyph".}
proc unicode*(a2: ptr Context; a3: Rune) {.importc: "nk_input_unicode".}
proc `end`*(a2: ptr Context) {.importc: "nk_input_end".}
{.pop.}
