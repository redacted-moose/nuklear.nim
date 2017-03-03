{.pragma: nuklear, cdecl, header: "src/nuklear.h".}

import nuklear_api, nuklear_gui, nuklear_font

const
  buttonBehaviorStackSize* {.intdefine.}: int = 8
  fontStackSize* {.intdefine.}: int = 8
  styleItemStackSize* {.intdefine.}: int = 16
  floatStackSize* {.intdefine.}: int = 32
  vectorStackSize* {.intdefine.}: int = 16
  flagsStackSize* {.intdefine.}: int = 32
  colorStackSize* {.intdefine.}: int = 32

when (buttonBehaviorStackSize != 8):
  {.passC: "-DNK_BUTTON_BEHAVIOR_STACK_SIZE=" & $buttonBehaviorStackSize.}

when (fontStackSize != 8):
  {.passC: "-DNK_FONT_STACK_SIZE=" & $fontStackSize.}

when (styleItemStackSize != 16):
  {.passC: "-DNK_STYLE_ITEM_STACK_SIZE=" & $styleItemStackSize.}

when (floatStackSize != 32):
  {.passC: "-DNK_FLOAT_STACK_SIZE=" & $floatStackSize.}

when (vectorStackSize != 16):
  {.passC: "-DNK_VECTOR_STACK_SIZE=" & $vectorStackSize.}

when (flagsStackSize != 32):
  {.passC: "-DNK_FLAGS_STACK_SIZE=" & $flagsStackSize.}

when (colorStackSize != 32):
  {.passC: "-DNK_COLOR_STACK_SIZE=" & $colorStackSize.}

type
  ConfigStackStyleItemElement* {.importc: "struct nk_config_stack_style_item_element", header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr StyleItem
    old_value* {.importc: "old_value".}: StyleItem

  ConfigStackFloatElement* {.importc: "struct nk_config_stack_float_element", header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr float
    old_value* {.importc: "old_value".}: float

  ConfigStackVec2Element* {.importc: "struct nk_config_stack_vec2_element", header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr Vec2
    old_value* {.importc: "old_value".}: Vec2

  ConfigStackFlagsElement* {.importc: "struct nk_config_stack_flags_element", header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr Flags
    old_value* {.importc: "old_value".}: Flags

  ConfigStackColorElement* {.importc: "struct nk_config_stack_color_element", header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr Color
    old_value* {.importc: "old_value".}: Color

  ConfigStackUserFontElement* {.importc: "struct nk_config_stack_user_font_element", header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr ptr UserFont
    old_value* {.importc: "old_value".}: ptr UserFont

  ConfigStackButtonBehaviorElement* {.importc: "struct nk_config_stack_button_behavior_element", header: "src/nuklear.h".} = object
    address* {.importc: "address".}: ptr ButtonBehavior
    old_value* {.importc: "old_value".}: ButtonBehavior

  ConfigStackStyleItem* {.importc: "struct nk_config_stack_style_item", header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[styleItemStackSize, ConfigStackStyleItemElement]

  ConfigStackFloat* {.importc: "struct nk_config_stack_float", header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[floatStackSize, ConfigStackFloatElement]

  ConfigStackVec2* {.importc: "struct nk_config_stack_vec2", header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[vectorStackSize, ConfigStackVec2Element]

  ConfigStackFlags* {. importc: "struct nk_config_stack_flags", header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[flagsStackSize, ConfigStackFlagsElement]

  ConfigStackColor* {. importc: "struct nk_config_stack_color", header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[colorStackSize, ConfigStackColorElement]

  ConfigStackUserFont* {. importc: "struct nk_config_stack_user_font", header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[fontStackSize, ConfigStackUserFontElement]

  ConfigStackButtonBehavior* {.importc: "struct nk_config_stack_button_behavior", header: "src/nuklear.h".} = object
    head* {.importc: "head".}: cint
    elements* {.importc: "elements".}: array[buttonBehaviorStackSize, ConfigStackButtonBehaviorElement]

  ConfigurationStacks* {.importc: "struct nk_configuration_stacks", header: "src/nuklear.h".} = object
    style_items* {.importc: "style_items".}: ConfigStackStyleItem
    floats* {.importc: "floats".}: ConfigStackFloat
    vectors* {.importc: "vectors".}: ConfigStackVec2
    flags* {.importc: "flags".}: ConfigStackFlags
    colors* {.importc: "colors".}: ConfigStackColor
    fonts* {.importc: "fonts".}: ConfigStackUserFont
    button_behaviors* {.importc: "button_behaviors".}: ConfigStackButtonBehavior
