import nuklear_memory_buffer, nuklear_allocator, nuklear_api

{.pragma: nuklear, cdecl, header: "src/nuklear.h".}
##  ==============================================================
##
##                           STRING
##
##  ===============================================================
##  Basic string buffer which is only used in context with the text editor
##   to manage and manipulate dynamic or fixed size string content. This is _NOT_
##   the default string handling method.

type
  Str* {.importc: "struct nk_str", header: "src/nuklear.h".} = object
    buffer* {.importc: "buffer".}: Buffer
    len* {.importc: "len".}: cint                 ## in codepoints/runes/glyphs


when defined(defaultAllocator):
  proc initDefault*(a2: ptr Str) {.nuklear, importc: "nk_str_init_default".}
proc init*(a2: ptr Str; a3: ptr Allocator; size: csize) {.nuklear, importc: "nk_str_init".}
proc initFixed*(a2: ptr Str; memory: pointer; size: csize) {.nuklear, importc: "nk_str_init_fixed".}
proc clear*(a2: ptr Str) {.nuklear, importc: "nk_str_clear".}
proc free*(a2: ptr Str) {.nuklear, importc: "nk_str_free".}
proc appendTextChar*(a2: ptr Str; a3: cstring; a4: cint): cint {.nuklear, importc: "nk_str_append_text_char".}
proc appendStrChar*(a2: ptr Str; a3: cstring): cint {.nuklear, importc: "nk_str_append_str_char".}
proc appendTextUtf8*(a2: ptr Str; a3: cstring; a4: cint): cint {.nuklear, importc: "nk_str_append_text_utf8".}
proc appendStrUtf8*(a2: ptr Str; a3: cstring): cint {.nuklear, importc: "nk_str_append_str_utf8".}
proc appendTextRunes*(a2: ptr Str; a3: ptr Rune; a4: cint): cint {.nuklear, importc: "nk_str_append_text_runes".}
proc appendStrRunes*(a2: ptr Str; a3: ptr Rune): cint {.nuklear, importc: "nk_str_append_str_runes".}
proc insertAtChar*(a2: ptr Str; pos: cint; a4: cstring; a5: cint): cint {.nuklear, importc: "nk_str_insert_at_char".}
proc insertAtRune*(a2: ptr Str; pos: cint; a4: cstring; a5: cint): cint {.nuklear, importc: "nk_str_insert_at_rune".}
proc insertTextChar*(a2: ptr Str; pos: cint; a4: cstring; a5: cint): cint {.nuklear, importc: "nk_str_insert_text_char".}
proc insertStrChar*(a2: ptr Str; pos: cint; a4: cstring): cint {.nuklear, importc: "nk_str_insert_str_char".}
proc insertTextUtf8*(a2: ptr Str; pos: cint; a4: cstring; a5: cint): cint {.nuklear, importc: "nk_str_insert_text_utf8".}
proc insertStrUtf8*(a2: ptr Str; pos: cint; a4: cstring): cint {.nuklear, importc: "nk_str_insert_str_utf8".}
proc insertTextRunes*(a2: ptr Str; pos: cint; a4: ptr Rune; a5: cint): cint {.nuklear, importc: "nk_str_insert_text_runes".}
proc insertStrRunes*(a2: ptr Str; pos: cint; a4: ptr Rune): cint {.nuklear, importc: "nk_str_insert_str_runes".}
proc removeChars*(a2: ptr Str; len: cint) {.nuklear, importc: "nk_str_remove_chars".}
proc removeRunes*(str: ptr Str; len: cint) {.nuklear, importc: "nk_str_remove_runes".}
proc deleteChars*(a2: ptr Str; pos: cint; len: cint) {.nuklear, importc: "nk_str_delete_chars".}
proc deleteRunes*(a2: ptr Str; pos: cint; len: cint) {.nuklear, importc: "nk_str_delete_runes".}
proc atChar*(a2: ptr Str; pos: cint): cstring {.nuklear, importc: "nk_str_at_char".}
proc atRune*(a2: ptr Str; pos: cint; unicode: ptr Rune; len: ptr cint): cstring {.nuklear, importc: "nk_str_at_rune".}
proc runeAt*(a2: ptr Str; pos: cint): Rune {.nuklear, importc: "nk_str_rune_at".}
proc atCharConst*(a2: ptr Str; pos: cint): cstring {.nuklear, importc: "nk_str_at_char_const".}
proc atconst*(a2: ptr Str; pos: cint; unicode: ptr Rune; len: ptr cint): cstring {.nuklear, importc: "nk_str_at_const".}
proc get*(a2: ptr Str): cstring {.cdecl, importc: "nk_str_get", header: "src/nuklear.h".}
proc getConst*(a2: ptr Str): cstring {.nuklear, importc: "nk_str_get_const".}
proc len*(a2: ptr Str): cint {.nuklear, importc: "nk_str_len".}
proc lenChar*(a2: ptr Str): cint {.nuklear, importc: "nk_str_len_char".}
