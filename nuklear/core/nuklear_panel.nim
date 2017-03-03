{.pragma: nuklear, cdecl, header: "src.nuklear.h".}

import nuklear_api, nuklear_drawing

const
  chartMaxSlot* {.intdefine.}: int = 4

when (chartMaxSlot != 4):
  {.passC: "-DNK_CHART_MAX_SLOT=" & $chartMaxSlot.}


type
  ChartSlot* {.importc: "struct nk_chart_slot", header: "src/nuklear.h".} = object
    `type`* {.importc: "type".}: ChartType
    color* {.importc: "color".}: Color
    highlight* {.importc: "highlight".}: Color
    min* {.importc: "min".}: cfloat
    max* {.importc: "max".}: cfloat
    range* {.importc: "range".}: cfloat
    count* {.importc: "count".}: cint
    last* {.importc: "last".}: Vec2
    index* {.importc: "index".}: cint

  Chart* {.importc: "struct nk_chart", header: "src/nuklear.h".} = object
    slots* {.importc: "slots".}: array[chartMaxSlot, ChartSlot]
    slot* {.importc: "slot".}: cint
    x* {.importc: "x".}: cfloat
    y* {.importc: "y".}: cfloat
    w* {.importc: "w".}: cfloat
    h* {.importc: "h".}: cfloat

  RowLayout* {.importc: "struct nk_row_layout", header: "src/nuklear.h".} = object
    `type`* {.importc: "type".}: cint
    index* {.importc: "index".}: cint
    height* {.importc: "height".}: cfloat
    columns* {.importc: "columns".}: cint
    ratio* {.importc: "ratio".}: ptr cfloat
    item_width* {.importc: "item_width".}: cfloat
    item_height* {.importc: "item_height".}: cfloat
    item_offset* {.importc: "item_offset".}: cfloat
    filled* {.importc: "filled".}: cfloat
    item* {.importc: "item".}: Rect
    tree_depth* {.importc: "tree_depth".}: cint

  PopupBuffer* {.importc: "struct nk_popup_buffer", header: "src/nuklear.h".} = object
    begin* {.importc: "begin".}: csize
    parent* {.importc: "parent".}: csize
    last* {.importc: "last".}: csize
    `end`* {.importc: "end".}: csize
    active* {.importc: "active".}: cint

  MenuState* {.importc: "struct nk_menu_state", header: "src/nuklear.h".} = object
    x* {.importc: "x".}: cfloat
    y* {.importc: "y".}: cfloat
    w* {.importc: "w".}: cfloat
    h* {.importc: "h".}: cfloat
    offset* {.importc: "offset".}: Scroll

  Panel* {.importc: "struct nk_panel", header: "src/nuklear.h".} = object
    flags* {.importc: "flags".}: Flags
    bounds* {.importc: "bounds".}: Rect
    offset* {.importc: "offset".}: ptr Scroll
    at_x* {.importc: "at_x".}: cfloat
    at_y* {.importc: "at_y".}: cfloat
    max_x* {.importc: "max_x".}: cfloat
    footer_height* {.importc: "footer_height".}: cfloat
    header_height* {.importc: "header_height".}: cfloat
    border* {.importc: "border".}: cfloat
    has_scrolling* {.importc: "has_scrolling".}: cuint
    clip* {.importc: "clip".}: Rect
    menu* {.importc: "menu".}: MenuState
    row* {.importc: "row".}: RowLayout
    chart* {.importc: "chart".}: Chart
    popup_buffer* {.importc: "popup_buffer".}: PopupBuffer
    buffer* {.importc: "buffer".}: ptr CommandBuffer
    parent* {.importc: "parent".}: ptr Panel
