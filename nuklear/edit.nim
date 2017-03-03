import core/nuklear_context, core/nuklear_api, core/nuklear_text_edit

{.push cdecl, header: "src/nuklear.h".}

## Widgets: TextEdit
proc string*(a2: ptr Context; a3: Flags; buffer: cstring; len: ptr cint; max: cint;
                 a7: PluginFilter): Flags {.importc: "nk_edit_string".}
proc buffer*(a2: ptr Context; a3: Flags; a4: ptr TextEdit; a5: PluginFilter): Flags {.importc: "nk_edit_buffer".}
proc string_zero_terminated*(a2: ptr Context; a3: Flags; buffer: cstring;
                                 max: cint; a6: PluginFilter): Flags {.importc: "nk_edit_string_zero_terminated".}

{.pop.}
