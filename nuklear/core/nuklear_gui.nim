{.pragma: nuklear, cdecl, header: "src/nuklear.h".}

import nuklear_api, nuklear_drawing, nuklear_font

type
  StyleItemType* {.size: sizeof(cint).} = enum
    STYLE_ITEM_COLOR, STYLE_ITEM_IMAGE


type
  StyleItemData* {.importc: "union nk_style_item_data", header: "src/nuklear.h".} = object {.
      union.}
    image* {.importc: "image".}: Image
    color* {.importc: "color".}: Color

  StyleItem* {.importc: "struct nk_style_item", header: "src/nuklear.h".} = object
    `type`* {.importc: "type".}: StyleItemType
    data* {.importc: "data".}: StyleItemData

type
  StyleText* {.importc: "struct nk_style_text", header: "src/nuklear.h".} = object
    color* {.importc: "color".}: Color
    padding* {.importc: "padding".}: Vec2

  StyleButton* {.importc: "struct nk_style_button", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## text
    text_background* {.importc: "text_background".}: Color
    text_normal* {.importc: "text_normal".}: Color
    text_hover* {.importc: "text_hover".}: Color
    text_active* {.importc: "text_active".}: Color
    text_alignment* {.importc: "text_alignment".}: Flags ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    padding* {.importc: "padding".}: Vec2
    image_padding* {.importc: "image_padding".}: Vec2
    touch_padding* {.importc: "touch_padding".}: Vec2 ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer;
        userdata: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; userdata: Handle) {.
        cdecl.}

  StyleToggle* {.importc: "struct nk_style_toggle", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## cursor
    cursor_normal* {.importc: "cursor_normal".}: StyleItem
    cursor_hover* {.importc: "cursor_hover".}: StyleItem ## text
    text_normal* {.importc: "text_normal".}: Color
    text_hover* {.importc: "text_hover".}: Color
    text_active* {.importc: "text_active".}: Color
    text_background* {.importc: "text_background".}: Color
    text_alignment* {.importc: "text_alignment".}: Flags ## properties
    padding* {.importc: "padding".}: Vec2
    touch_padding* {.importc: "touch_padding".}: Vec2
    spacing* {.importc: "spacing".}: cfloat
    border* {.importc: "border".}: cfloat ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleSelectable* {.importc: "struct nk_style_selectable", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background (inactive)
    hover* {.importc: "hover".}: StyleItem
    pressed* {.importc: "pressed".}: StyleItem ## background (active)
    normal_active* {.importc: "normal_active".}: StyleItem
    hover_active* {.importc: "hover_active".}: StyleItem
    pressed_active* {.importc: "pressed_active".}: StyleItem ## text color (inactive)
    text_normal* {.importc: "text_normal".}: Color
    text_hover* {.importc: "text_hover".}: Color
    text_pressed* {.importc: "text_pressed".}: Color ## text color (active)
    text_normal_active* {.importc: "text_normal_active".}: Color
    text_hover_active* {.importc: "text_hover_active".}: Color
    text_pressed_active* {.importc: "text_pressed_active".}: Color
    text_background* {.importc: "text_background".}: Color
    text_alignment* {.importc: "text_alignment".}: Flags ## properties
    rounding* {.importc: "rounding".}: cfloat
    padding* {.importc: "padding".}: Vec2
    touch_padding* {.importc: "touch_padding".}: Vec2
    image_padding* {.importc: "image_padding".}: Vec2 ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleSlider* {.importc: "struct nk_style_slider", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## background bar
    bar_normal* {.importc: "bar_normal".}: Color
    bar_hover* {.importc: "bar_hover".}: Color
    bar_active* {.importc: "bar_active".}: Color
    bar_filled* {.importc: "bar_filled".}: Color ## cursor
    cursor_normal* {.importc: "cursor_normal".}: StyleItem
    cursor_hover* {.importc: "cursor_hover".}: StyleItem
    cursor_active* {.importc: "cursor_active".}: StyleItem ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    bar_height* {.importc: "bar_height".}: cfloat
    padding* {.importc: "padding".}: Vec2
    spacing* {.importc: "spacing".}: Vec2
    cursor_size* {.importc: "cursor_size".}: Vec2 ## optional buttons
    show_buttons* {.importc: "show_buttons".}: cint
    inc_button* {.importc: "inc_button".}: StyleButton
    dec_button* {.importc: "dec_button".}: StyleButton
    inc_symbol* {.importc: "inc_symbol".}: SymbolType
    dec_symbol* {.importc: "dec_symbol".}: SymbolType ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleProgress* {.importc: "struct nk_style_progress", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## cursor
    cursor_normal* {.importc: "cursor_normal".}: StyleItem
    cursor_hover* {.importc: "cursor_hover".}: StyleItem
    cursor_active* {.importc: "cursor_active".}: StyleItem
    cursor_border_color* {.importc: "cursor_border_color".}: Color ## properties
    rounding* {.importc: "rounding".}: cfloat
    border* {.importc: "border".}: cfloat
    cursor_border* {.importc: "cursor_border".}: cfloat
    cursor_rounding* {.importc: "cursor_rounding".}: cfloat
    padding* {.importc: "padding".}: Vec2 ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleScrollbar* {.importc: "struct nk_style_scrollbar", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## # background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## # cursor
    cursor_normal* {.importc: "cursor_normal".}: StyleItem
    cursor_hover* {.importc: "cursor_hover".}: StyleItem
    cursor_active* {.importc: "cursor_active".}: StyleItem
    cursor_border_color* {.importc: "cursor_border_color".}: Color ## # properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    border_cursor* {.importc: "border_cursor".}: cfloat
    rounding_cursor* {.importc: "rounding_cursor".}: cfloat
    padding* {.importc: "padding".}: Vec2 ## # optional buttons
    show_buttons* {.importc: "show_buttons".}: cint
    inc_button* {.importc: "inc_button".}: StyleButton
    dec_button* {.importc: "dec_button".}: StyleButton
    inc_symbol* {.importc: "inc_symbol".}: SymbolType
    dec_symbol* {.importc: "dec_symbol".}: SymbolType ## # optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleEdit* {.importc: "struct nk_style_edit", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color
    scrollbar* {.importc: "scrollbar".}: StyleScrollbar ## cursor
    cursor_normal* {.importc: "cursor_normal".}: Color
    cursor_hover* {.importc: "cursor_hover".}: Color
    cursor_text_normal* {.importc: "cursor_text_normal".}: Color
    cursor_text_hover* {.importc: "cursor_text_hover".}: Color ## text (unselected)
    text_normal* {.importc: "text_normal".}: Color
    text_hover* {.importc: "text_hover".}: Color
    text_active* {.importc: "text_active".}: Color ## text (selected)
    selected_normal* {.importc: "selected_normal".}: Color
    selected_hover* {.importc: "selected_hover".}: Color
    selected_text_normal* {.importc: "selected_text_normal".}: Color
    selected_text_hover* {.importc: "selected_text_hover".}: Color ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    cursor_size* {.importc: "cursor_size".}: cfloat
    scrollbar_size* {.importc: "scrollbar_size".}: Vec2
    padding* {.importc: "padding".}: Vec2
    row_padding* {.importc: "row_padding".}: cfloat

  StyleProperty* {.importc: "struct nk_style_property", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## text
    label_normal* {.importc: "label_normal".}: Color
    label_hover* {.importc: "label_hover".}: Color
    label_active* {.importc: "label_active".}: Color ## symbols
    sym_left* {.importc: "sym_left".}: SymbolType
    sym_right* {.importc: "sym_right".}: SymbolType ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    padding* {.importc: "padding".}: Vec2
    edit* {.importc: "edit".}: StyleEdit
    inc_button* {.importc: "inc_button".}: StyleButton
    dec_button* {.importc: "dec_button".}: StyleButton ## optional user callbacks
    userdata* {.importc: "userdata".}: Handle
    draw_begin* {.importc: "draw_begin".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}
    draw_end* {.importc: "draw_end".}: proc (a2: ptr CommandBuffer; a3: Handle) {.cdecl.}

  StyleChart* {.importc: "struct nk_style_chart", header: "src/nuklear.h".} = object
    background* {.importc: "background".}: StyleItem ## colors
    border_color* {.importc: "border_color".}: Color
    selected_color* {.importc: "selected_color".}: Color
    color* {.importc: "color".}: Color ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    padding* {.importc: "padding".}: Vec2

  StyleCombo* {.importc: "struct nk_style_combo", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem
    border_color* {.importc: "border_color".}: Color ## label
    label_normal* {.importc: "label_normal".}: Color
    label_hover* {.importc: "label_hover".}: Color
    label_active* {.importc: "label_active".}: Color ## symbol
    symbol_normal* {.importc: "symbol_normal".}: Color
    symbol_hover* {.importc: "symbol_hover".}: Color
    symbol_active* {.importc: "symbol_active".}: Color ## button
    button* {.importc: "button".}: StyleButton
    sym_normal* {.importc: "sym_normal".}: SymbolType
    sym_hover* {.importc: "sym_hover".}: SymbolType
    sym_active* {.importc: "sym_active".}: SymbolType ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    content_padding* {.importc: "content_padding".}: Vec2
    button_padding* {.importc: "button_padding".}: Vec2
    spacing* {.importc: "spacing".}: Vec2

  StyleTab* {.importc: "struct nk_style_tab", header: "src/nuklear.h".} = object
    background* {.importc: "background".}: StyleItem ## background
    border_color* {.importc: "border_color".}: Color
    text* {.importc: "text".}: Color ## button
    tab_maximize_button* {.importc: "tab_maximize_button".}: StyleButton
    tab_minimize_button* {.importc: "tab_minimize_button".}: StyleButton
    node_maximize_button* {.importc: "node_maximize_button".}: StyleButton
    node_minimize_button* {.importc: "node_minimize_button".}: StyleButton
    sym_minimize* {.importc: "sym_minimize".}: SymbolType
    sym_maximize* {.importc: "sym_maximize".}: SymbolType ## properties
    border* {.importc: "border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    indent* {.importc: "indent".}: cfloat
    padding* {.importc: "padding".}: Vec2
    spacing* {.importc: "spacing".}: Vec2

  StyleHeaderAlign* {.size: sizeof(cint).} = enum
    HEADER_LEFT, HEADER_RIGHT


type
  StyleWindowHeader* {.importc: "struct nk_style_window_header", header: "src/nuklear.h".} = object
    normal* {.importc: "normal".}: StyleItem ## background
    hover* {.importc: "hover".}: StyleItem
    active* {.importc: "active".}: StyleItem ## button
    close_button* {.importc: "close_button".}: StyleButton
    minimize_button* {.importc: "minimize_button".}: StyleButton
    close_symbol* {.importc: "close_symbol".}: SymbolType
    minimize_symbol* {.importc: "minimize_symbol".}: SymbolType
    maximize_symbol* {.importc: "maximize_symbol".}: SymbolType ## title
    label_normal* {.importc: "label_normal".}: Color
    label_hover* {.importc: "label_hover".}: Color
    label_active* {.importc: "label_active".}: Color ## properties
    align* {.importc: "align".}: StyleHeaderAlign
    padding* {.importc: "padding".}: Vec2
    label_padding* {.importc: "label_padding".}: Vec2
    spacing* {.importc: "spacing".}: Vec2

  StyleWindow* {.importc: "struct nk_style_window", header: "src/nuklear.h".} = object
    header* {.importc: "header".}: StyleWindowHeader
    fixed_background* {.importc: "fixed_background".}: StyleItem
    background* {.importc: "background".}: Color
    border_color* {.importc: "border_color".}: Color
    combo_border_color* {.importc: "combo_border_color".}: Color
    contextual_border_color* {.importc: "contextual_border_color".}: Color
    menu_border_color* {.importc: "menu_border_color".}: Color
    group_border_color* {.importc: "group_border_color".}: Color
    tooltip_border_color* {.importc: "tooltip_border_color".}: Color
    scaler* {.importc: "scaler".}: StyleItem
    border* {.importc: "border".}: cfloat
    combo_border* {.importc: "combo_border".}: cfloat
    contextual_border* {.importc: "contextual_border".}: cfloat
    menu_border* {.importc: "menu_border".}: cfloat
    group_border* {.importc: "group_border".}: cfloat
    tooltip_border* {.importc: "tooltip_border".}: cfloat
    rounding* {.importc: "rounding".}: cfloat
    spacing* {.importc: "spacing".}: Vec2
    scrollbar_size* {.importc: "scrollbar_size".}: Vec2
    min_size* {.importc: "min_size".}: Vec2
    padding* {.importc: "padding".}: Vec2
    group_padding* {.importc: "group_padding".}: Vec2
    popup_padding* {.importc: "popup_padding".}: Vec2
    combo_padding* {.importc: "combo_padding".}: Vec2
    contextual_padding* {.importc: "contextual_padding".}: Vec2
    menu_padding* {.importc: "menu_padding".}: Vec2
    tooltip_padding* {.importc: "tooltip_padding".}: Vec2

  Style* {.importc: "struct nk_style", header: "src/nuklear.h".} = object
    font* {.importc: "font".}: ptr UserFont
    cursors* {.importc: "cursors".}: array[CURSOR_COUNT, ptr Cursor]
    cursor_active* {.importc: "cursor_active".}: ptr Cursor
    cursor_last* {.importc: "cursor_last".}: ptr Cursor
    cursor_visible* {.importc: "cursor_visible".}: cint
    text* {.importc: "text".}: StyleText
    button* {.importc: "button".}: StyleButton
    contextual_button* {.importc: "contextual_button".}: StyleButton
    menu_button* {.importc: "menu_button".}: StyleButton
    option* {.importc: "option".}: StyleToggle
    checkbox* {.importc: "checkbox".}: StyleToggle
    selectable* {.importc: "selectable".}: StyleSelectable
    slider* {.importc: "slider".}: StyleSlider
    progress* {.importc: "progress".}: StyleProgress
    property* {.importc: "property".}: StyleProperty
    edit* {.importc: "edit".}: StyleEdit
    chart* {.importc: "chart".}: StyleChart
    scrollh* {.importc: "scrollh".}: StyleScrollbar
    scrollv* {.importc: "scrollv".}: StyleScrollbar
    tab* {.importc: "tab".}: StyleTab
    combo* {.importc: "combo".}: StyleCombo
    window* {.importc: "window".}: StyleWindow

{.push cdecl, header: "src/nuklear.h".}
proc styleItemImage*(img: Image): StyleItem {.importc: "nk_style_item_image".}
proc styleItemColor*(a2: Color): StyleItem {.importc: "nk_style_item_color".}
proc styleItemHide*(): StyleItem {.importc: "nk_style_item_hide".}
{.pop.}
