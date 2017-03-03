import core/nuklear_context

{.push cdecl, header: "src/nuklear.h".}
proc combobox*(a2: ptr Context; items: cstringArray; count: cint; selected: ptr cint;
              item_height: cint; max_height: cint) {.importc: "nk_combobox".}
proc string*(a2: ptr Context; items_separated_by_zeros: cstring;
                     selected: ptr cint; count: cint; item_height: cint;
                     max_height: cint) {.importc: "nk_combobox_string".}
proc separator*(a2: ptr Context; items_separated_by_separator: cstring;
                        separator: cint; selected: ptr cint; count: cint;
                        item_height: cint; max_height: cint) {.importc: "nk_combobox_separator".}

{.pop.}

proc callback*(a2: ptr Context; item_getter: proc (a2: pointer; a3: cint;
    a4: cstringArray) {.cdecl.}; a4: pointer; selected: ptr cint; count: cint;
                       item_height: cint; max_height: cint) {.cdecl,
    importc: "nk_combobox_callback", header: "core/src/nuklear.h".}
