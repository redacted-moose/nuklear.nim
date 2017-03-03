{.pragma: nuklear, cdecl, header: "src/nuklear.h".}

import nuklear_api, nuklear_panel, nuklear_drawing, nuklear_table

const
  maxNumberBuffer* {.intdefine.}: int = 64
  windowMaxName* {.intdefine.}: int = 64

when (maxNumberBuffer != 64):
  {.passC: "-DNK_MAX_NUMBER_BUFFER=" & $maxNumberBuffer.}

when (windowMaxName != 64):
  {.passC: "-DNK_WINDOW_MAX_NAME=" & $windowMaxName.}


type
  WindowFlags* {.size: sizeof(cint).} = enum
    WINDOW_PRIVATE = FLAG(9), ## dummy flag marks the beginning of the private window flag part
    WINDOW_DYNAMIC = FLAG(10), ## special window type growing up in height while being filled to a certain maximum height
    WINDOW_ROM = FLAG(11),    ## sets the window into a read only mode and does not allow input changes
    WINDOW_HIDDEN = FLAG(12), ## Hides the window and stops any window interaction and drawing
    WINDOW_CLOSED = FLAG(13), ## Directly closes and frees the window at the end of the frame
    WINDOW_MINIMIZED = FLAG(14), ## marks the window as minimized
    WINDOW_SUB = FLAG(15),    ## Marks the window as subwindow of another window
    WINDOW_GROUP = FLAG(16),  ## Marks the window as window widget group
    WINDOW_POPUP = FLAG(17),  ## Marks the window as a popup window
    WINDOW_NONBLOCK = FLAG(18), ## Marks the window as a nonblock popup window
    WINDOW_CONTEXTUAL = FLAG(19), ## Marks the window as a combo box or menu
    WINDOW_COMBO = FLAG(20),  ## Marks the window as a combo box
    WINDOW_MENU = FLAG(21),   ## Marks the window as a menu
    WINDOW_TOOLTIP = FLAG(22), ## Marks the window as a menu
    WINDOW_REMOVE_ROM = FLAG(23) ## Removes the read only mode at the end of the window


type
  PopupState* {.importc: "struct nk_popup_state", header: "src/nuklear.h".} = object
    win* {.importc: "win".}: ptr Window
    `type`* {.importc: "type".}: WindowFlags
    name* {.importc: "name".}: Hash
    active* {.importc: "active".}: cint
    combo_count* {.importc: "combo_count".}: cuint
    con_count* {.importc: "con_count".}: cuint
    con_old* {.importc: "con_old".}: cuint
    active_con* {.importc: "active_con".}: cuint

  EditState* {.importc: "struct nk_edit_state", header: "src/nuklear.h".} = object
    name* {.importc: "name".}: Hash
    seq* {.importc: "seq".}: cuint
    old* {.importc: "old".}: cuint
    active* {.importc: "active".}: cint
    prev* {.importc: "prev".}: cint
    cursor* {.importc: "cursor".}: cint
    sel_start* {.importc: "sel_start".}: cint
    sel_end* {.importc: "sel_end".}: cint
    scrollbar* {.importc: "scrollbar".}: Scroll
    mode* {.importc: "mode".}: cuchar
    single_line* {.importc: "single_line".}: cuchar

  PropertyState* {.importc: "struct nk_property_state", header: "src/nuklear.h".} = object
    active* {.importc: "active".}: cint
    prev* {.importc: "prev".}: cint
    buffer* {.importc: "buffer".}: array[maxNumberBuffer, char]
    length* {.importc: "length".}: cint
    cursor* {.importc: "cursor".}: cint
    name* {.importc: "name".}: Hash
    seq* {.importc: "seq".}: cuint
    old* {.importc: "old".}: cuint
    state* {.importc: "state".}: cint

  Window* {.importc: "struct nk_window", header: "src/nuklear.h".} = object
    seq* {.importc: "seq".}: cuint
    name* {.importc: "name".}: Hash
    name_string* {.importc: "name_string".}: array[windowMaxName, char]
    flags* {.importc: "flags".}: Flags
    bounds* {.importc: "bounds".}: Rect
    scrollbar* {.importc: "scrollbar".}: Scroll
    buffer* {.importc: "buffer".}: CommandBuffer
    layout* {.importc: "layout".}: ptr Panel
    scrollbar_hiding_timer* {.importc: "scrollbar_hiding_timer".}: cfloat ## persistent widget state
    property* {.importc: "property".}: PropertyState
    popup* {.importc: "popup".}: PopupState
    edit* {.importc: "edit".}: EditState
    scrolled* {.importc: "scrolled".}: cuint
    tables* {.importc: "tables".}: ptr Table
    table_count* {.importc: "table_count".}: cushort
    table_size* {.importc: "table_size".}: cushort ## window list hooks
    next* {.importc: "next".}: ptr Window
    prev* {.importc: "prev".}: ptr Window
    parent* {.importc: "parent".}: ptr Window
