{.pragma: nuklear, cdecl, header: "src/nuklear.h".}

import nuklear_string, nuklear_api, nuklear_allocator

##  ===============================================================
##
##                       TEXT EDITOR
##
##  ===============================================================
## Editing text in this library is handled by either `nk_edit_string` or
##  `nk_edit_buffer`. But like almost everything in this library there are multiple
##  ways of doing it and a balance between control and ease of use with memory
##  as well as functionality controlled by flags.
##
##  This library generally allows three different levels of memory control:
##  First of is the most basic way of just providing a simple char array with
##  string length. This method is probably the easiest way of handling simple
##  user text input. Main upside is complete control over memory while the biggest
##  downside in comparsion with the other two approaches is missing undo/redo.
##
##  For UIs that require undo/redo the second way was created. It is based on
##  a fixed size nk_text_edit struct, which has an internal undo/redo stack.
##  This is mainly useful if you want something more like a text editor but don't want
##  to have a dynamically growing buffer.
##
##  The final way is using a dynamically growing nk_text_edit struct, which
##  has both a default version if you don't care where memory comes from and an
##  allocator version if you do. While the text editor is quite powerful for its
##  complexity I would not recommend editing gigabytes of data with it.
##  It is rather designed for uses cases which make sense for a GUI library not for
##  an full blown text editor.
##

const
  texteditUndostatecount* {.intdefine.}: int = 99
  texteditUndocharcount* {.intdefine.}: int = 999

when (texteditUndostatecount != 99):
  {.passC: "-DNK_TEXTEDIT_UNDOSTATECOUNT=" & $texteditUndostatecount.}

when (texteditUndocharcount != 999):
  {.passC: "-DNK_TEXTEDIT_UNDOCHARCOUNT=" & $texteditUndocharcount.}


type
  Clipboard* {.importc: "struct nk_clipboard", header: "src/nuklear.h".} = object
    userdata* {.importc: "userdata".}: Handle
    paste* {.importc: "paste".}: PluginPaste
    copy* {.importc: "copy".}: PluginCopy

  TextUndoRecord* {.importc: "struct nk_text_undo_record", header: "src/nuklear.h".} = object
    where* {.importc: "where".}: cint
    insert_length* {.importc: "insert_length".}: cshort
    delete_length* {.importc: "delete_length".}: cshort
    char_storage* {.importc: "char_storage".}: cshort

  TextUndoState* {.importc: "struct nk_text_undo_state", header: "src/nuklear.h".} = object
    undo_rec* {.importc: "undo_rec".}: array[texteditUndostatecount, TextUndoRecord]
    undo_char* {.importc: "undo_char".}: array[texteditUndocharcount, Rune]
    undo_point* {.importc: "undo_point".}: cshort
    redo_point* {.importc: "redo_point".}: cshort
    undo_char_point* {.importc: "undo_char_point".}: cshort
    redo_char_point* {.importc: "redo_char_point".}: cshort

  TextEdit* {.importc: "struct nk_text_edit", header: "src/nuklear.h".} = object
    clip* {.importc: "clip".}: Clipboard
    string* {.importc: "string".}: Str
    filter* {.importc: "filter".}: PluginFilter
    scrollbar* {.importc: "scrollbar".}: Vec2
    cursor* {.importc: "cursor".}: cint
    select_start* {.importc: "select_start".}: cint
    select_end* {.importc: "select_end".}: cint
    mode* {.importc: "mode".}: cuchar
    cursor_at_end_of_line* {.importc: "cursor_at_end_of_line".}: cuchar
    initialized* {.importc: "initialized".}: cuchar
    has_preferred_x* {.importc: "has_preferred_x".}: cuchar
    single_line* {.importc: "single_line".}: cuchar
    active* {.importc: "active".}: cuchar
    padding1* {.importc: "padding1".}: cuchar
    preferred_x* {.importc: "preferred_x".}: cfloat
    undo* {.importc: "undo".}: TextUndoState

  PluginFilter* = proc (a2: ptr TextEdit; unicode: Rune): cint {.cdecl.}
  PluginPaste* = proc (a2: Handle; a3: ptr TextEdit) {.cdecl.}
  PluginCopy* = proc (a2: Handle; a3: cstring; len: cint) {.cdecl.}

  TextEditType* {.size: sizeof(cint).} = enum
    TEXT_EDIT_SINGLE_LINE, TEXT_EDIT_MULTI_LINE

  TextEditMode* {.size: sizeof(cint).} = enum
    TEXT_EDIT_MODE_VIEW, TEXT_EDIT_MODE_INSERT, TEXT_EDIT_MODE_REPLACE

{.push cdecl, header: "src/nuklear.h".}

## filter function

proc filterDefault*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_default".}
proc filterAscii*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_ascii".}
proc filterFloat*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_float".}
proc filterDecimal*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_decimal".}
proc filterHex*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_hex".}
proc filterOct*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_oct".}
proc filterBinary*(a2: ptr TextEdit; unicode: Rune): cint {.importc: "nk_filter_binary".}

## text editor

when defined(defaultAllocator):
  proc initDefault*(a2: ptr TextEdit) {.importc: "nk_textedit_init_default".}
proc init*(a2: ptr TextEdit; a3: ptr Allocator; size: csize) {.importc: "nk_textedit_init".}
proc initFixed*(a2: ptr TextEdit; memory: pointer; size: csize) {.importc: "nk_textedit_init_fixed".}
proc free*(a2: ptr TextEdit) {.importc: "nk_textedit_free".}
proc text*(a2: ptr TextEdit; a3: cstring; total_len: cint) {.importc: "nk_textedit_text".}
proc delete*(a2: ptr TextEdit; where: cint; len: cint) {.importc: "nk_textedit_delete".}
proc deleteSelection*(a2: ptr TextEdit) {.importc: "nk_textedit_delete_selection".}
proc selectAll*(a2: ptr TextEdit) {.importc: "nk_textedit_select_all".}
proc cut*(a2: ptr TextEdit): cint {.importc: "nk_textedit_cut".}
proc paste*(a2: ptr TextEdit; a3: cstring; len: cint): cint {.importc: "nk_textedit_paste".}
proc undo*(a2: ptr TextEdit) {.importc: "nk_textedit_undo".}
proc redo*(a2: ptr TextEdit) {.importc: "nk_textedit_redo".}

{.pop.}
