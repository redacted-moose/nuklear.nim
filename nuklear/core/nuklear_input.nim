{.pragma: nuklear, cdecl, header: "src/nuklear.h".}

import nuklear_api

const
  inputMax* {.intdefine.}: int = 16

when (inputMax != 16):
  {.passC: "-DNK_INPUT_MAX=" & $inputMax.}


type
  MouseButton* {.importc: "struct nk_mouse_button", header: "src/nuklear.h".} = object
    down* {.importc: "down".}: cint
    clicked* {.importc: "clicked".}: cuint
    clicked_pos* {.importc: "clicked_pos".}: Vec2

  Mouse* {.importc: "struct nk_mouse", header: "src/nuklear.h".} = object
    buttons* {.importc: "buttons".}: array[BUTTON_MAX, MouseButton]
    pos* {.importc: "pos".}: Vec2
    prev* {.importc: "prev".}: Vec2
    delta* {.importc: "delta".}: Vec2
    scroll_delta* {.importc: "scroll_delta".}: cfloat
    grab* {.importc: "grab".}: cuchar
    grabbed* {.importc: "grabbed".}: cuchar
    ungrab* {.importc: "ungrab".}: cuchar

  Key* {.importc: "struct nk_key", header: "src/nuklear.h".} = object
    down* {.importc: "down".}: cint
    clicked* {.importc: "clicked".}: cuint

  Keyboard* {.importc: "struct nk_keyboard", header: "src/nuklear.h".} = object
    keys* {.importc: "keys".}: array[KEY_MAX, Key]
    text* {.importc: "text".}: array[inputMax, char]
    text_len* {.importc: "text_len".}: cint

  Input* {.importc: "struct nk_input", header: "src/nuklear.h".} = object
    keyboard* {.importc: "keyboard".}: Keyboard
    mouse* {.importc: "mouse".}: Mouse

{.push cdecl, header: "src/nuklear.h".}

proc hasMouseClick*(a2: ptr Input; a3: Buttons): cint {.importc: "nk_input_has_mouse_click".}
proc hasMouseClickInRect*(a2: ptr Input; a3: Buttons; a4: Rect): cint {.importc: "nk_input_has_mouse_click_in_rect".}
proc hasMouseClickDownInRect*(a2: ptr Input; a3: Buttons; a4: Rect;
                                        down: cint): cint {.importc: "nk_input_has_mouse_click_down_in_rect".}
proc isMouseClickInRect*(a2: ptr Input; a3: Buttons; a4: Rect): cint {.importc: "nk_input_is_mouse_click_in_rect".}
proc isMouseClickDownInRect*(i: ptr Input; id: Buttons; b: Rect; down: cint): cint {.
    importc: "nk_input_is_mouse_click_down_in_rect".}
proc anyMouseClickInRect*(a2: ptr Input; a3: Rect): cint {.importc: "nk_input_any_mouse_click_in_rect".}
proc isMousePrevHoveringRect*(a2: ptr Input; a3: Rect): cint {.importc: "nk_input_is_mouse_prev_hovering_rect".}
proc isMouseHoveringRect*(a2: ptr Input; a3: Rect): cint {.importc: "nk_input_is_mouse_hovering_rect".}
proc mouseClicked*(a2: ptr Input; a3: Buttons; a4: Rect): cint {.importc: "nk_input_mouse_clicked".}
proc isMouseDown*(a2: ptr Input; a3: Buttons): cint {.importc: "nk_input_is_mouse_down".}
proc isMousePressed*(a2: ptr Input; a3: Buttons): cint {.importc: "nk_input_is_mouse_pressed".}
proc isMouseReleased*(a2: ptr Input; a3: Buttons): cint {.importc: "nk_input_is_mouse_released".}
proc isKeyPressed*(a2: ptr Input; a3: Keys): cint {.importc: "nk_input_is_key_pressed".}
proc isKeyReleased*(a2: ptr Input; a3: Keys): cint {.importc: "nk_input_is_key_released".}
proc isKeyDown*(a2: ptr Input; a3: Keys): cint {.importc: "nk_input_is_key_down".}

{.pop.}
