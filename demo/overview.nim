import ../nuklear, math

proc overview*(ctx: PContext): cint =
  var menu: Panel

  ## window flags
  var show_menu: cint = true.cint
  var titlebar: cint = true.cint
  var border: cint = true.cint
  var resize: cint = true.cint
  var movable: cint = true.cint
  var no_scrollbar: cint = false.cint
  var windowFlags: Flags = 0
  var minimizable: cint = true.cint

  ## popups
  var header_align: StyleHeaderAlign = HEADER_RIGHT
  var show_app_about: bool = false
  var layout: Panel

  ## window flags
  windowFlags = 0
  ctx.style.window.header.align = header_align

  if border != 0: windowFlags = windowFlags or WINDOW_BORDER
  if resize != 0: windowFlags = windowFlags or WINDOW_SCALABLE
  if movable != 0: windowFlags = windowFlags or WINDOW_MOVABLE
  if no_scrollbar != 0: windowFlags = windowFlags or WINDOW_NO_SCROLLBAR
  if minimizable != 0: windowFlags = windowFlags or WINDOW_MINIMIZABLE

  begin(ctx, layout, "Overview", newRect(10, 10, 400, 600), windowFlags):
    if show_menu != 0:
      ## menubar
      type
        menu_states = enum
          MENU_DEFAULT, MENU_WINDOWS
      var mprog: csize = 60
      var mslider: cint = 10
      var mcheck: cint = true.cint

      menubarBegin(ctx)
      layoutRowBegin(ctx, STATIC, 25, 2)
      layoutRowPush(ctx, 45)

      if menuBeginLabel(ctx, addr(menu), "MENU", Flags(TEXT_LEFT), 120) != 0:
        var prog: csize = 40
        var slider: cint = 10
        var check: cint = true.cint

        layoutRowDynamic(ctx, 25, 1)
        if menuItemLabel(ctx, "Hide", Flags(TEXT_LEFT)) != 0: show_menu = false.cint
        if menuItemLabel(ctx, "About", Flags(TEXT_LEFT)) != 0: show_app_about = true
        discard progress(ctx, addr(prog), 100, MODIFIABLE.cint)
        discard sliderInt(ctx, 0, addr(slider), 16, 1)
        discard checkboxLabel(ctx, "check", addr(check))
        menuEnd(ctx)

      layoutRowPush(ctx, 70)
      discard progress(ctx, addr(mprog), 100, MODIFIABLE.cint)
      discard sliderInt(ctx, 0, addr(mslider), 16, 1)
      discard checkboxLabel(ctx, "check", addr(mcheck))
      menubarEnd(ctx)

    if show_app_about:
      ## about popup
      var popup: Panel
      var s: Rect = newRect(20, 100, 300, 190)

      if popupBegin(ctx, addr(popup), POPUP_STATIC, "About", Flags(WINDOW_CLOSABLE), s) != 0:
        layoutRowDynamic(ctx, 20, 1)
        label(ctx, "Nuklear", Flags(TEXT_LEFT))
        label(ctx, "By Micha Mettke", Flags(TEXT_LEFT))
        label(ctx, "nuklear is licensed under the public domain License.", Flags(TEXT_LEFT))
        ctx.popupEnd()

      else:
        show_app_about = false

    if tree_push(ctx, TREE_TAB, "Window", MINIMIZED) != 0:
      layoutRowDynamic(ctx, 30, 2)
      discard checkboxLabel(ctx, "Titlebar", addr(titlebar))
      discard checkboxLabel(ctx, "Menu", addr(show_menu))
      discard checkboxLabel(ctx, "Border", addr(border))
      discard checkboxLabel(ctx, "Resizable", addr(resize))
      discard checkboxLabel(ctx, "Movable", addr(movable))
      discard checkboxLabel(ctx, "No Scrollbar", addr(no_scrollbar))
      discard checkboxLabel(ctx, "Minimizable", addr(minimizable))
      tree_pop(ctx)

    if tree_push(ctx, TREE_TAB, "Widgets", MINIMIZED) != 0:
      type
        options = enum
          A, B, C
      var checkbox: cint
      var option: options

      if tree_push(ctx, TREE_NODE, "Text", MINIMIZED) != 0:
        ## Text Widgets
        layoutRowDynamic(ctx, 20, 1)
        label(ctx, "Label aligned left", Flags(TEXT_LEFT))
        label(ctx, "Label aligned centered", Flags(TEXT_CENTERED))
        label(ctx, "Label aligned right", Flags(TEXT_RIGHT))
        labelColored(ctx, "Blue text", Flags(TEXT_LEFT), rgb(0, 0, 255))
        labelColored(ctx, "Yellow text", Flags(TEXT_LEFT), rgb(255, 255, 0))
        text(ctx, "Text without /0", 15, Flags(TEXT_RIGHT))

        layoutRowStatic(ctx, 100, 200, 1)
        labelWrap(ctx, "This is a very long line to hopefully get this text to be wrapped into multiple lines to show line wrapping")

        layoutRowDynamic(ctx, 100, 1)
        labelWrap(ctx, "This is another long text to show dynamic window changes on multiline text")
        tree_pop(ctx)

      if tree_push(ctx, TREE_NODE, "Button", MINIMIZED) != 0:
        ## Buttons Widgets
        layoutRowStatic(ctx, 30, 100, 3)
        if buttonLabel(ctx, "Button") != 0: stdout.write("Button pressed!\n")
        buttonSetBehavior(ctx, BUTTON_REPEATER)
        if buttonLabel(ctx, "Repeater") != 0:
          # fprintf(stdout, "Repeater is being pressed!\x0A")
          stdout.write("Repeater is being pressed!\n")
        buttonSetBehavior(ctx, BUTTON_DEFAULT)
        discard buttonColor(ctx, rgb(0, 0, 255))

        layoutRowStatic(ctx, 25, 25, 8)
        discard buttonSymbol(ctx, SYMBOL_CIRCLE_SOLID)
        discard buttonSymbol(ctx, SYMBOL_CIRCLE_OUTLINE)
        discard buttonSymbol(ctx, SYMBOL_RECT_SOLID)
        discard buttonSymbol(ctx, SYMBOL_RECT_OUTLINE)
        discard buttonSymbol(ctx, SYMBOL_TRIANGLE_UP)
        discard buttonSymbol(ctx, SYMBOL_TRIANGLE_DOWN)
        discard buttonSymbol(ctx, SYMBOL_TRIANGLE_LEFT)
        discard buttonSymbol(ctx, SYMBOL_TRIANGLE_RIGHT)

        layoutRowStatic(ctx, 30, 100, 2)
        discard buttonSymbolLabel(ctx, SYMBOL_TRIANGLE_LEFT, "prev", Flags(TEXT_RIGHT))
        discard buttonSymbolLabel(ctx, SYMBOL_TRIANGLE_RIGHT, "next", Flags(TEXT_LEFT))
        tree_pop(ctx)

      if tree_push(ctx, TREE_NODE, "Basic", MINIMIZED) != 0:
        ## Basic widgets
        var intSlider: cint = 5
        var floatSlider: cfloat = 2.5
        var progValue: csize = 40
        var propertyFloat: cfloat = 2
        var propertyInt: cint = 10
        var propertyNeg: cint = 10
        var range_float_min: cfloat = 0
        var range_float_max: cfloat = 100
        var range_float_value: cfloat = 50
        var range_int_min: cint = 0
        var range_int_value: cint = 2048
        var range_int_max: cint = 4096
        var ratio: array[2, cfloat] = [120.cfloat, 150]

        layoutRowStatic(ctx, 30, 100, 1)
        discard checkboxLabel(ctx, "Checkbox", addr(checkbox))

        layoutRowStatic(ctx, 30, 80, 3)
        option = if option_label(ctx, "optionA", (option == A).cint) != 0: A else: option
        option = if option_label(ctx, "optionB", (option == B).cint) != 0: B else: option
        option = if option_label(ctx, "optionC", (option == C).cint) != 0: C else: option

        layoutRow(ctx, STATIC, 30, 2, ratio[0].addr)
        labelf(ctx, Flags(TEXT_LEFT), "Slider int")
        discard sliderInt(ctx, 0, addr(intSlider), 10, 1)
        label(ctx, "Slider float", Flags(TEXT_LEFT))
        discard slider_float(ctx, 0, addr(floatSlider), 5.0, 0.5)
        labelf(ctx, Flags(TEXT_LEFT), "Progressbar", progValue)
        discard progress(ctx, addr(progValue), 100, MODIFIABLE.cint)

        layoutRow(ctx, STATIC, 25, 2, ratio[0].addr)
        label(ctx, "Property float:", Flags(TEXT_LEFT))
        propertyFloat(ctx, "Float:", 0, addr(propertyFloat), 64.0, 0.1, 0.2)
        label(ctx, "Property int:", Flags(TEXT_LEFT))
        propertyInt(ctx, "Int:", 0, addr(propertyInt), 100.0, 1, 1)
        label(ctx, "Property neg:", Flags(TEXT_LEFT))
        propertyInt(ctx, "Neg:", - 10, addr(propertyNeg), 10, 1, 1)

        layoutRowDynamic(ctx, 25, 1)
        label(ctx, "Range:", Flags(TEXT_LEFT))

        layoutRowDynamic(ctx, 25, 3)
        propertyFloat(ctx, "#min:", 0, addr(range_float_min), range_float_max,
                          1.0, 0.2)
        propertyFloat(ctx, "#float:", range_float_min, addr(range_float_value),
                          range_float_max, 1.0, 0.2)
        propertyFloat(ctx, "#max:", range_float_min, addr(range_float_max), 100,
                          1.0, 0.2)
        propertyInt(ctx, "#min:", INT_MIN, addr(range_int_min), range_int_max, 1,
                        10)
        propertyInt(ctx, "#neg:", range_int_min, addr(range_int_value),
                        range_int_max, 1, 10)
        propertyInt(ctx, "#max:", range_int_min, addr(range_int_max), INT_MAX, 1,
                        10)
        tree_pop(ctx)

      if tree_push(ctx, TREE_NODE, "Selectable", MINIMIZED) != 0:
        if tree_push(ctx, TREE_NODE, "List", MINIMIZED) != 0:
          var selected: array[4, cint] = [false.cint, false.cint, true.cint, false.cint]
          layoutRowStatic(ctx, 18, 100, 1)
          discard selectableLabel(ctx, "Selectable", Flags(TEXT_LEFT), addr(selected[0]))
          discard selectableLabel(ctx, "Selectable", Flags(TEXT_LEFT), addr(selected[1]))
          label(ctx, "Not Selectable", Flags(TEXT_LEFT))
          discard selectableLabel(ctx, "Selectable", Flags(TEXT_LEFT), addr(selected[2]))
          discard selectableLabel(ctx, "Selectable", Flags(TEXT_LEFT), addr(selected[3]))
          tree_pop(ctx)

        if tree_push(ctx, TREE_NODE, "Grid", MINIMIZED) != 0:
          var i: cint
          var selected: array[16, cint] = [1.cint, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]

          layoutRowStatic(ctx, 50, 50, 4)

          i = 0
          while i < 16:
            if selectableLabel(ctx, "Z", Flags(TEXT_CENTERED), addr(selected[i])) != 0:
              var
                x: cint = (i mod 4)
                y: cint = i div 4
              if x > 0: selected[i - 1] = selected[i - 1] xor 1
              if x < 3: selected[i + 1] = selected[i + 1] xor 1
              if y > 0: selected[i - 4] = selected[i - 4] xor 1
              if y < 3: selected[i + 4] = selected[i + 4] xor 1

            inc(i)

          tree_pop(ctx)

        tree_pop(ctx)

      if tree_push(ctx, TREE_NODE, "Combo", MINIMIZED) != 0:
        ## Combobox Widgets
        ##                  In this library comboboxes are not limited to being a popup
        ##                  list of selectable text. Instead it is a abstract concept of
        ##                  having something that is *selected* or displayed, a popup window
        ##                  which opens if something needs to be modified and the content
        ##                  of the popup which causes the *selected* or displayed value to
        ##                  change or if wanted close the combobox.
        ##
        ##                  While strange at first handling comboboxes in a abstract way
        ##                  solves the problem of overloaded window content. For example
        ##                  changing a color value requires 4 value modifier (slider, property,...)
        ##                  for RGBA then you need a label and ways to display the current color.
        ##                  If you want to go fancy you even add rgb and hsv ratio boxes.
        ##                  While fine for one color if you have a lot of them it because
        ##                  tedious to look at and quite wasteful in space. You could add
        ##                  a popup which modifies the color but this does not solve the
        ##                  fact that it still requires a lot of cluttered space to do.
        ##
        ##                  In these kind of instance abstract comboboxes are quite handy. All
        ##                  value modifiers are hidden inside the combobox popup and only
        ##                  the color is shown if not open. This combines the clarity of the
        ##                  popup with the ease of use of just using the space for modifiers.
        ##
        ##                  Other instances are for example time and especially date picker,
        ##                  which only show the currently activated time/data and hide the
        ##                  selection logic inside the combobox popup.
        ##
        var
          chartSelection: cfloat = 8.0
          currentWeapon: cint = 0
          checkValues: array[5, cint]
          position: array[3, cfloat]
          comboColor: Color = rgba(130, 50, 50, 255)
          comboColor2: Color = rgba(130, 180, 50, 255)
          prog_a: csize = 20
          prog_b: csize = 40
          prog_c: csize = 10
          prog_d: csize = 90
          weapons: array[5, cstring] = ["Fist".cstring, "Pistol", "Shotgun", "Plasma", "BFG"]
          buffer: array[64, char]
          sum: csize = 0
          comboPanel: Panel

        ## default combobox
        layoutRowStatic(ctx, 25, 200, 1)
        currentWeapon = combo(ctx, weapons, len(weapons), currentWeapon, 25, 200)

        ## slider color combobox
        if comboBeginColor(ctx, addr(comboPanel), comboColor, 200) != 0:
          var ratios: array[2, cfloat] = [0.15.cfloat, 0.85]

          layoutRow(ctx, DYNAMIC, 30, 2, addr(ratios[0]))
          label(ctx, "R:", Flags(TEXT_LEFT))
          comboColor.r = cast[byte](slide_int(ctx, 0, comboColor.r.cint, 255, 5))
          label(ctx, "G:", Flags(TEXT_LEFT))
          comboColor.g = cast[byte](slide_int(ctx, 0, comboColor.g.cint, 255, 5))
          label(ctx, "B:", Flags(TEXT_LEFT))
          comboColor.b = cast[byte](slide_int(ctx, 0, comboColor.b.cint, 255, 5))
          label(ctx, "A:", Flags(TEXT_LEFT))
          comboColor.a = cast[byte](slide_int(ctx, 0, comboColor.a.cint, 255, 5))
          comboEnd(ctx)

        if comboBeginColor(ctx, addr(comboPanel), comboColor2, 400) != 0:
          type
            color_mode = enum
              COL_RGB, COL_HSV

          var col_mode: color_mode = COL_RGB

          when not defined(DEMO_DO_NOT_USE_COLOR_PICKER):
            layoutRowDynamic(ctx, 120, 1)
            comboColor2 = color_picker(ctx, comboColor2, RGBA)

          layoutRowDynamic(ctx, 25, 2)
          col_mode = if option_label(ctx, "RGB", (col_mode == COL_RGB).cint) != 0: COL_RGB else: col_mode
          col_mode = if option_label(ctx, "HSV", (col_mode == COL_HSV).cint) != 0: COL_HSV else: col_mode

          layoutRowDynamic(ctx, 25, 1)
          if col_mode == COL_RGB:
            comboColor2.r = cast[byte](propertyi(ctx, "#R:", 0,
                comboColor2.r.cint, 255, 1, 1))
            comboColor2.g = cast[byte](propertyi(ctx, "#G:", 0,
                comboColor2.g.cint, 255, 1, 1))
            comboColor2.b = cast[byte](propertyi(ctx, "#B:", 0,
                comboColor2.b.cint, 255, 1, 1))
            comboColor2.a = cast[byte](propertyi(ctx, "#A:", 0,
                comboColor2.a.cint, 255, 1, 1))

          else:
            var tmp: array[4, byte]

            color_hsva_bv(addr(tmp[0]), comboColor2)
            tmp[0] = cast[byte](propertyi(ctx, "#H:", 0, tmp[0].cint, 255, 1, 1))
            tmp[1] = cast[byte](propertyi(ctx, "#S:", 0, tmp[1].cint, 255, 1, 1))
            tmp[2] = cast[byte](propertyi(ctx, "#V:", 0, tmp[2].cint, 255, 1, 1))
            tmp[3] = cast[byte](propertyi(ctx, "#A:", 0, tmp[3].cint, 255, 1, 1))
            comboColor2 = hsva_bv(addr(tmp[0]))

          comboEnd(ctx)

        sum = prog_a + prog_b + prog_c + prog_d
        # sprintf(buffer, "%lu", sum)

        if combo_begin_label(ctx, addr(comboPanel), buffer, 200) != 0:
          layoutRowDynamic(ctx, 30, 1)
          discard progress(ctx, addr(prog_a), 100, MODIFIABLE.cint)
          discard progress(ctx, addr(prog_b), 100, MODIFIABLE.cint)
          discard progress(ctx, addr(prog_c), 100, MODIFIABLE.cint)
          discard progress(ctx, addr(prog_d), 100, MODIFIABLE.cint)
          comboEnd(ctx)

        sum = checkValues[0] + checkValues[1] + checkValues[2] +
            checkValues[3] + checkValues[4]
        # sprintf(buffer, "%lu", sum)

        if combo_begin_label(ctx, addr(comboPanel), buffer, 200) != 0:
          layoutRowDynamic(ctx, 30, 1)
          discard checkboxLabel(ctx, $weapons[0], addr(checkValues[0]))
          discard checkboxLabel(ctx, $weapons[1], addr(checkValues[1]))
          discard checkboxLabel(ctx, $weapons[2], addr(checkValues[2]))
          discard checkboxLabel(ctx, $weapons[3], addr(checkValues[3]))
          comboEnd(ctx)

        # sprintf(buffer, "%.2f, %.2f, %.2f", position[0], position[1], position[2])

        if combo_begin_label(ctx, addr(comboPanel), buffer, 200) != 0:
          layoutRowDynamic(ctx, 25, 1)
          propertyFloat(ctx, "#X:", - 1024.0, addr(position[0]), 1024.0, 1, 0.5)
          propertyFloat(ctx, "#Y:", - 1024.0, addr(position[1]), 1024.0, 1, 0.5)
          propertyFloat(ctx, "#Z:", - 1024.0, addr(position[2]), 1024.0, 1, 0.5)
          comboEnd(ctx)

        # sprintf(buffer, "%.1f", chartSelection)

        if combo_begin_label(ctx, addr(comboPanel), buffer, 250) != 0:
          var i: csize = 0
          var values: array[13, cfloat] = [26.0.cfloat, 13.0, 30.0, 15.0, 25.0, 10.0, 20.0, 40.0, 12.0, 8.0,
                               22.0, 28.0, 5.0]

          layoutRowDynamic(ctx, 150, 1)
          discard chart_begin(ctx, CHART_COLUMN, len(values).cint, 0.0, 50.0)

          i = 0
          while i < len(values):
            var res: Flags = chart_push(ctx, values[i])
            if res and Flags(CHART_CLICKED):
              chartSelection = values[i]
              combo_close(ctx)

            inc(i)

          chart_end(ctx)
          comboEnd(ctx)

        var time_selected: cint = 0
        var date_selected: cint = 0
        var sel_time: tm
        var sel_date: tm

        if not time_selected or not date_selected:
          ## keep time and date updated if nothing is selected
          var cur_time: time_t = time(0)
          var n: ptr tm = localtime(addr(cur_time))
          if not time_selected: memcpy(addr(sel_time), n, sizeof(tm))
          if not date_selected: memcpy(addr(sel_date), n, sizeof(tm))

        sprintf(buffer, "%02d:%02d:%02d", sel_time.tm_hour, sel_time.tm_min,
                sel_time.tm_sec)

        if combo_begin_label(ctx, addr(combo), buffer, 250):
          time_selected = 1
          layoutRowDynamic(ctx, 25, 1)
          sel_time.tm_sec = propertyi(ctx, "#S:", 0, sel_time.tm_sec, 60, 1, 1)
          sel_time.tm_min = propertyi(ctx, "#M:", 0, sel_time.tm_min, 60, 1, 1)
          sel_time.tm_hour = propertyi(ctx, "#H:", 0, sel_time.tm_hour, 23, 1, 1)
          comboEnd(ctx)

        layoutRowStatic(ctx, 25, 350, 1)
        sprintf(buffer, "%02d-%02d-%02d", sel_date.tm_mday, sel_date.tm_mon + 1,
                sel_date.tm_year + 1900)

        if combo_begin_label(ctx, addr(combo), buffer, 400) != 0:
          var i: cint = 0
          var month: ptr cstring = ["January", "February", "March", "Apil", "May", "June",
                               "July", "August", "September", "Ocotober",
                               "November", "December"]
          var week_days: ptr cstring = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
          var month_days: ptr cint = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
          var year: cint = sel_date.tm_year + 1900
          var leap_year: cint = (not (year mod 4) and ((year mod 100))) or
              not (year mod 400)
          var days: cint = if (sel_date.tm_mon == 1): month_days[sel_date.tm_mon] +
              leap_year else: month_days[sel_date.tm_mon]

          ## header with month and year
          date_selected = 1
          layoutRowBegin(ctx, DYNAMIC, 20, 3)
          layoutRowPush(ctx, 0.05)
          if button_symbol(ctx, SYMBOL_TRIANGLE_LEFT):
            if sel_date.tm_mon == 0:
              sel_date.tm_mon = 11
              sel_date.tm_year = MAX(0, sel_date.tm_year - 1)

            else:
              dec(sel_date.tm_mon)

          layoutRowPush(ctx, 0.9)

          sprintf(buffer, "%s %d", month[sel_date.tm_mon], year)

          label(ctx, buffer, Flags(TEXT_CENTERED))
          layoutRowPush(ctx, 0.05)
          if button_symbol(ctx, SYMBOL_TRIANGLE_RIGHT) != 0:
            if sel_date.tm_mon == 11:
              sel_date.tm_mon = 0
              inc(sel_date.tm_year)

            else:
              inc(sel_date.tm_mon)

          layoutRow_end(ctx)

          ## good old week day formula (double because precision)
          var year_n: cint = if (sel_date.tm_mon < 2): year - 1 else: year
          var y: cint = year_n mod 100
          var c: cint = year_n div 100
          var y4: cint = (int)(cast[cfloat](y div 4))
          var c4: cint = (int)(cast[cfloat](c div 4))
          var m: cint = (int)(2.6 * (double)(((sel_date.tm_mon + 10) mod 12) + 1) - 0.2)
          var week_day: cint = (((1 + m + y + y4 + c4 - 2 * c) mod 7) + 7) mod 7

          ## weekdays
          layoutRowDynamic(ctx, 35, 7)

          i = 0
          while i < cast[cint](LEN(week_days)):
            label(ctx, week_days[i], Flags(TEXT_CENTERED))
            inc(i)

          ## days
          if week_day > 0: spacing(ctx, week_day)

          i = 1
          while i <= days:
            sprintf(buffer, "%d", i)

            if button_label(ctx, buffer) != 0:
              sel_date.tm_mday = i
              combo_close(ctx)

            inc(i)

          comboEnd(ctx)

        tree_pop(ctx)

      if tree_push(ctx, TREE_NODE, "Input", MINIMIZED) != 0:
        var ratio: array[2, cfloat] = [120.cfloat, 150]
        var field_buffer: array[64, char]
        var text: array[9, array[64, char]]
        var text_len: array[9, cint]
        var box_buffer: array[512, char]
        var field_len: cint
        var box_len: cint
        var active: Flags

        layoutRow(ctx, STATIC, 25, 2, addr(ratio[0]))
        label(ctx, "Default:", Flags(TEXT_LEFT))
        discard edit_string(ctx, Flags(EDIT_SIMPLE), text[0], addr(text_len[0]), 64,
                       filter_default)
        label(ctx, "Int:", Flags(TEXT_LEFT))
        discard edit_string(ctx, Flags(EDIT_SIMPLE), text[1], addr(text_len[1]), 64,
                       filter_decimal)
        label(ctx, "Float:", Flags(TEXT_LEFT))
        discard edit_string(ctx, Flags(EDIT_SIMPLE), text[2], addr(text_len[2]), 64,
                       filter_float)
        label(ctx, "Hex:", Flags(TEXT_LEFT))
        discard edit_string(ctx, Flags(EDIT_SIMPLE), text[4], addr(text_len[4]), 64,
                       filter_hex)
        label(ctx, "Octal:", Flags(TEXT_LEFT))
        discard edit_string(ctx, Flags(EDIT_SIMPLE), text[5], addr(text_len[5]), 64,
                       filter_oct)
        label(ctx, "Binary:", Flags(TEXT_LEFT))
        discard edit_string(ctx, Flags(EDIT_SIMPLE), text[6], addr(text_len[6]), 64,
                       filter_binary)
        label(ctx, "Password:", Flags(TEXT_LEFT))

        var i: cint = 0
        var old_len: cint = text_len[8]
        var buffer: array[64, char]

        i = 0
        while i < text_len[8]:
          buffer[i] = '*'
          inc(i)

        discard edit_string(ctx, Flags(EDIT_FIELD), buffer, addr(text_len[8]), 64,
                       filter_default)

        if old_len < text_len[8]:
          copyMem(addr(text[8][old_len]), addr(buffer[old_len]),
                 (csize)(text_len[8] - old_len))

        label(ctx, "Field:", Flags(TEXT_LEFT))
        discard edit_string(ctx, Flags(EDIT_FIELD), field_buffer, addr(field_len), 64,
                       filter_default)
        label(ctx, "Box:", Flags(TEXT_LEFT))
        layoutRowStatic(ctx, 180, 278, 1)
        discard edit_string(ctx, Flags(EDIT_BOX), box_buffer, addr(box_len), 512,
                       filter_default)
        layoutRow(ctx, STATIC, 25, 2, addr(ratio[0]))
        active = edit_string(ctx, Flags(EDIT_FIELD) or Flags(EDIT_SIG_ENTER), text[7],
                              addr(text_len[7]), 64, filter_ascii)

        if button_label(ctx, "Submit") or (active and EDIT_COMMITED):
          text[7][text_len[7]] = '\x0A'
          inc(text_len[7])
          copyMem(addr(box_buffer[box_len]), addr(text[7]),
                 cast[csize](text_len[7]))
          inc(box_len, text_len[7])
          text_len[7] = 0

        layoutRow_end(ctx)
        tree_pop(ctx)

      tree_pop(ctx)

    if tree_push(ctx, TREE_TAB, "Chart", MINIMIZED) != 0:
      ## Chart Widgets
      ##              This library has two different rather simple charts. The line and the
      ##              column chart. Both provide a simple way of visualizing values and
      ##              have a retained mode and immediate mode API version. For the retain
      ##              mode version `plot` and `plot_function` you either provide
      ##              an array or a callback to call to handle drawing the graph.
      ##              For the immediate mode version you start by calling `chart_begin`
      ##              and need to provide min and max values for scaling on the Y-axis.
      ##              and then call `chart_push` to push values into the chart.
      ##              Finally `chart_end` needs to be called to end the process.
      var id: cfloat = 0
      var col_index: cint = - 1
      var line_index: cint = - 1
      var step: cfloat = (2 * 3.141592654) / 32
      var i: cint
      var index: cint = - 1
      var bounds: Rect

      ## line chart
      id = 0
      index = - 1
      layoutRowDynamic(ctx, 100, 1)
      bounds = widget_bounds(ctx)

      if chart_begin(ctx, CHART_LINES, 32, - 1.0, 1.0) != 0:
        i = 0
        while i < 32:
          var res: Flags = chart_push(ctx, cast[cfloat](cos(id)))
          if res and CHART_HOVERING: index = cast[cint](i)
          if res and CHART_CLICKED: line_index = cast[cint](i)
          id += step
          inc(i)

        chart_end(ctx)

      if index != - 1:
        var buffer: array[maxNumberBuffer, char]
        var val: cfloat = cast[cfloat](cos(cast[cfloat](index * step)))
        sprintf(buffer, "Value: %.2f", val)
        tooltip(ctx, buffer)

      if line_index != - 1:
        layoutRowDynamic(ctx, 20, 1)
        labelf(ctx, TEXT_LEFT, "Selected value: %.2f",
                  cast[cfloat](cos(cast[cfloat](index * step))))

      layoutRowDynamic(ctx, 100, 1)
      bounds = widget_bounds(ctx)

      if chart_begin(ctx, CHART_COLUMN, 32, 0.0, 1.0) != 0:
        # i = 0
        # while i < 32:
        for i in 0..31:
          var res: Flags = chart_push(ctx, cast[cfloat](abs(sin(id))))
          if res and CHART_HOVERING: index = cast[cint](i)
          if res and CHART_CLICKED: col_index = cast[cint](i)
          id += step
          # inc(i)

        chart_end(ctx)

      if index != - 1:
        var buffer: array[maxNumberBuffer, char]
        sprintf(buffer, "Value: %.2f",
                cast[cfloat](abs(sin(step * cast[cfloat](index)))))
        tooltip(ctx, buffer)

      if col_index != - 1:
        layoutRowDynamic(ctx, 20, 1)
        labelf(ctx, TEXT_LEFT, "Selected value: %.2f",
                  cast[cfloat](abs(sin(step * cast[cfloat](col_index)))))

      layoutRowDynamic(ctx, 100, 1)
      bounds = widget_bounds(ctx)

      if chart_begin(ctx, CHART_COLUMN, 32, 0.0, 1.0) != 0:
        chart_add_slot(ctx, CHART_LINES, 32, - 1.0, 1.0)
        chart_add_slot(ctx, CHART_LINES, 32, - 1.0, 1.0)

        id = 0
        # i = 0
        # while i < 32:
        for i in 0..31:
          discard chart_push_slot(ctx, cast[cfloat](abs(sin(id))), 0)
          discard chart_push_slot(ctx, cast[cfloat](cos(id)), 1)
          discard chart_push_slot(ctx, cast[cfloat](sin(id)), 2)
          id += step
          # inc(i)

      chart_end(ctx)

      ## mixed colored chart
      layoutRowDynamic(ctx, 100, 1)
      bounds = widget_bounds(ctx)

      if chart_begin_colored(ctx, CHART_LINES, rgb(255, 0, 0),
                               rgb(150, 0, 0), 32, 0.0, 1.0) != 0:
        chart_add_slot_colored(ctx, CHART_LINES, rgb(0, 0, 255),
                                  rgb(0, 0, 150), 32, - 1.0, 1.0)
        chart_add_slot_colored(ctx, CHART_LINES, rgb(0, 255, 0),
                                  rgb(0, 150, 0), 32, - 1.0, 1.0)

        id = 0
        # i = 0
        # while i < 32:
        for i in 0..31:
          discard chart_push_slot(ctx, cast[cfloat](abs(sin(id))), 0)
          discard chart_push_slot(ctx, cast[cfloat](cos(id)), 1)
          discard chart_push_slot(ctx, cast[cfloat](sin(id)), 2)
          id += step
          # inc(i)

      chart_end(ctx)
      tree_pop(ctx)

    if tree_push(ctx, TREE_TAB, "Popup", MINIMIZED) != 0:
      var color: Color = Color(r:255, g:0, b:0, a:255)
      var select: array[4, cint]
      var popup_active: cint
      var `in`: ptr Input = addr(ctx.input)
      var bounds: Rect
      ## menu contextual
      layoutRowStatic(ctx, 30, 150, 1)
      bounds = widget_bounds(ctx)
      label(ctx, "Right click me for menu", TEXT_LEFT)
      if contextual_begin(ctx, addr(menu), 0, initVec2(100, 300), bounds) != 0:
        var prog: csize = 40
        var slider: cint = 10
        layoutRowDynamic(ctx, 25, 1)
        discard checkboxLabel(ctx, "Menu", addr(show_menu))
        discard progress(ctx, addr(prog), 100, MODIFIABLE.cint)
        discard sliderInt(ctx, 0, addr(slider), 16, 1)
        if contextual_item_label(ctx, "About", Flags(TEXT_CENTERED)) != 0:
          show_app_about = true
        selectableLabel(ctx, if select[0]: "Unselect" else: "Select",
                            TEXT_LEFT, addr(select[0]))
        selectableLabel(ctx, if select[1]: "Unselect" else: "Select",
                            TEXT_LEFT, addr(select[1]))
        selectableLabel(ctx, if select[2]: "Unselect" else: "Select",
                            TEXT_LEFT, addr(select[2]))
        selectableLabel(ctx, if select[3]: "Unselect" else: "Select",
                            TEXT_LEFT, addr(select[3]))
        contextual_end(ctx)
      layoutRowBegin(ctx, STATIC, 30, 2)
      layoutRowPush(ctx, 100)
      label(ctx, "Right Click here:", Flags(TEXT_LEFT))
      layoutRowPush(ctx, 50)
      bounds = widget_bounds(ctx)
      discard button_color(ctx, color)
      layoutRow_end(ctx)
      if contextual_begin(ctx, addr(menu), 0, initVec2(350, 60), bounds):
        layoutRowDynamic(ctx, 30, 4)
        color.r = cast[byte](propertyi(ctx, "#r", 0, color.r.cint, 255, 1, 1))
        color.g = cast[byte](propertyi(ctx, "#g", 0, color.g.cint, 255, 1, 1))
        color.b = cast[byte](propertyi(ctx, "#b", 0, color.b.cint, 255, 1, 1))
        color.a = cast[byte](propertyi(ctx, "#a", 0, color.a.cint, 255, 1, 1))
        contextual_end(ctx)
      layoutRowBegin(ctx, STATIC, 30, 2)
      layoutRowPush(ctx, 100)
      label(ctx, "Popup:", Flags(TEXT_LEFT))
      layoutRowPush(ctx, 50)
      if button_label(ctx, "Popup") != 0: popup_active = 1
      layoutRow_end(ctx)
      if popup_active != 0:
        var s: Rect = Rect(x: 20, y: 100, w: 220, h: 90)
        if popupBegin(ctx, addr(menu), POPUP_STATIC, "Error", 0, s) != 0:
          layoutRowDynamic(ctx, 25, 1)
          label(ctx, "A terrible error as occured", Flags(TEXT_LEFT))
          layoutRowDynamic(ctx, 25, 2)
          if button_label(ctx, "OK") != 0:
            popup_active = 0
            popup_close(ctx)
          if button_label(ctx, "Cancel") != 0:
            popup_active = 0
            popup_close(ctx)
          popupEnd(ctx)
        else:
          popup_active = false.cint
      layoutRowStatic(ctx, 30, 150, 1)
      bounds = widget_bounds(ctx)
      label(ctx, "Hover me for tooltip", Flags(TEXT_LEFT))
      if is_mouse_hovering_rect(`in`, bounds) != 0:
        tooltip(ctx, "This is a tooltip")
      tree_pop(ctx)
    if tree_push(ctx, TREE_TAB, "Layout", MINIMIZED) != 0:
      if tree_push(ctx, TREE_NODE, "Widget", MINIMIZED) != 0:
        var ratio_two: ptr cfloat = [0.2, 0.6, 0.2]
        var width_two: ptr cfloat = [100, 200, 50]
        layoutRowDynamic(ctx, 30, 1)
        label(ctx, "Dynamic fixed column layout with generated position and size:", Flags(TEXT_LEFT))
        layoutRowDynamic(ctx, 30, 3)
        button_label(ctx, "button")
        button_label(ctx, "button")
        button_label(ctx, "button")
        layoutRowDynamic(ctx, 30, 1)
        label(ctx, "static fixed column layout with generated position and size:",
                 TEXT_LEFT)
        layoutRowStatic(ctx, 30, 100, 3)
        button_label(ctx, "button")
        button_label(ctx, "button")
        button_label(ctx, "button")
        layoutRowDynamic(ctx, 30, 1)
        label(ctx, "Dynamic array-based custom column layout with generated position and custom size:",
                 TEXT_LEFT)
        layoutRow(ctx, DYNAMIC, 30, 3, ratio_two)
        button_label(ctx, "button")
        button_label(ctx, "button")
        button_label(ctx, "button")
        layoutRowDynamic(ctx, 30, 1)
        label(ctx, "Static array-based custom column layout with generated position and custom size:",
                 TEXT_LEFT)
        layoutRow(ctx, STATIC, 30, 3, width_two)
        button_label(ctx, "button")
        button_label(ctx, "button")
        button_label(ctx, "button")
        layoutRowDynamic(ctx, 30, 1)
        label(ctx, "Dynamic immediate mode custom column layout with generated position and custom size:",
                 TEXT_LEFT)
        layoutRowBegin(ctx, DYNAMIC, 30, 3)
        layoutRowPush(ctx, 0.2)
        button_label(ctx, "button")
        layoutRowPush(ctx, 0.6)
        button_label(ctx, "button")
        layoutRowPush(ctx, 0.2)
        button_label(ctx, "button")
        layoutRow_end(ctx)
        layoutRowDynamic(ctx, 30, 1)
        label(ctx, "Static immediate mode custom column layout with generated position and custom size:",
                 TEXT_LEFT)
        layoutRowBegin(ctx, STATIC, 30, 3)
        layoutRowPush(ctx, 100)
        button_label(ctx, "button")
        layoutRowPush(ctx, 200)
        button_label(ctx, "button")
        layoutRowPush(ctx, 50)
        button_label(ctx, "button")
        layoutRow_end(ctx)
        layoutRowDynamic(ctx, 30, 1)
        label(ctx, "Static free space with custom position and custom size:",
                 TEXT_LEFT)
        layout_space_begin(ctx, STATIC, 120, 4)
        layout_space_push(ctx, rect(100, 0, 100, 30))
        button_label(ctx, "button")
        layout_space_push(ctx, rect(0, 15, 100, 30))
        button_label(ctx, "button")
        layout_space_push(ctx, rect(200, 15, 100, 30))
        button_label(ctx, "button")
        layout_space_push(ctx, rect(100, 30, 100, 30))
        button_label(ctx, "button")
        layout_space_end(ctx)
        tree_pop(ctx)

      if tree_push(ctx, TREE_NODE, "Group", MINIMIZED) != 0:
        var group_titlebar: cint = false
        var group_border: cint = true
        var group_no_scrollbar: cint = false
        var group_width: cint = 320
        var group_height: cint = 200
        var tab: panel
        var group_flags: flags = 0

        if group_border: group_flags = group_flags or WINDOW_BORDER
        if group_no_scrollbar: group_flags = group_flags or WINDOW_NO_SCROLLBAR
        if group_titlebar: group_flags = group_flags or WINDOW_TITLE

        layoutRowDynamic(ctx, 30, 3)
        discard checkboxLabel(ctx, "Titlebar", addr(group_titlebar))
        discard checkboxLabel(ctx, "Border", addr(group_border))
        discard checkboxLabel(ctx, "No Scrollbar", addr(group_no_scrollbar))

        layoutRowBegin(ctx, STATIC, 22, 2)

        layoutRowPush(ctx, 50)
        label(ctx, "size:", TEXT_LEFT)

        layoutRowPush(ctx, 130)
        propertyInt(ctx, "#Width:", 100, addr(group_width), 500, 10, 1)

        layoutRowPush(ctx, 130)
        propertyInt(ctx, "#Height:", 100, addr(group_height), 500, 10, 1)

        layoutRow_end(ctx)

        layoutRowStatic(ctx, cast[cfloat](group_height), group_width, 2)
        if group_begin(ctx, addr(tab), "Group", group_flags):
          var i: cint = 0
          var selected: array[16, cint]
          layoutRowStatic(ctx, 18, 100, 1)

          i = 0
          while i < 16:
            selectableLabel(ctx, if (selected[i]): "Selected" else: "Unselected",
                                TEXT_CENTERED, addr(selected[i]))
            inc(i)

          group_end(ctx)

        tree_pop(ctx)

      if tree_push(ctx, TREE_NODE, "Notebook", MINIMIZED) != 0:
        var current_tab: cint = 0
        var group: panel
        var item_padding: vec2
        var bounds: rect
        var step: cfloat = (2 * 3.141592654) div 32
        type
          chart_type = enum
            CHART_LINE, CHART_HISTO, CHART_MIXED
        var names: ptr cstring = ["Lines", "Columns", "Mixed"]
        var rounding: cfloat
        var id: cfloat = 0
        var i: cint

        ## Header
        style_push_vec2(ctx, addr(ctx.style.window.spacing), vec2(0, 0))
        style_push_float(ctx, addr(ctx.style.button.rounding), 0)
        layoutRowBegin(ctx, STATIC, 20, 3)

        i = 0
        while i < 3:
          ## make sure button perfectly fits text
          var f: ptr user_font = ctx.style.font
          var text_width: cfloat = f.width(f.userdata, f.height, names[i],
                                       strlen(names[i]))
          var widget_width: cfloat = text_width + 3 * ctx.style.button.padding.x

          layoutRowPush(ctx, widget_width)
          if current_tab == i:
            ## active tab gets highlighted
            var button_color: style_item = ctx.style.button.normal
            ctx.style.button.normal = ctx.style.button.active
            current_tab = if button_label(ctx, names[i]): i else: current_tab
            ctx.style.button.normal = button_color

          else:
            current_tab = if button_label(ctx, names[i]): i else: current_tab

          inc(i)

        style_pop_float(ctx)

        ## Body
        layoutRowDynamic(ctx, 140, 1)
        if group_begin(ctx, addr(group), "Notebook", WINDOW_BORDER):
          style_pop_vec2(ctx)

          case current_tab
          of CHART_LINE:
            layoutRowDynamic(ctx, 100, 1)
            bounds = widget_bounds(ctx)
            if chart_begin_colored(ctx, CHART_LINES, rgb(255, 0, 0),
                                     rgb(150, 0, 0), 32, 0.0, 1.0):
              chart_add_slot_colored(ctx, CHART_LINES, rgb(0, 0, 255),
                                        rgb(0, 0, 150), 32, - 1.0, 1.0)
              i = 0
              id = 0
              while i < 32:
                chart_push_slot(ctx, cast[cfloat](fabs(sin(id))), 0)
                chart_push_slot(ctx, cast[cfloat](cos(id)), 1)
                inc(id, step)
                inc(i)

            chart_end(ctx)

          of CHART_HISTO:
            layoutRowDynamic(ctx, 100, 1)
            bounds = widget_bounds(ctx)
            if chart_begin_colored(ctx, CHART_COLUMN, rgb(255, 0, 0),
                                     rgb(150, 0, 0), 32, 0.0, 1.0):
              i = 0
              id = 0
              while i < 32:
                chart_push_slot(ctx, cast[cfloat](fabs(sin(id))), 0)
                inc(id, step)
                inc(i)

            chart_end(ctx)

          of CHART_MIXED:
            layoutRowDynamic(ctx, 100, 1)
            bounds = widget_bounds(ctx)

            if chart_begin_colored(ctx, CHART_LINES, rgb(255, 0, 0),
                                     rgb(150, 0, 0), 32, 0.0, 1.0):
              chart_add_slot_colored(ctx, CHART_LINES, rgb(0, 0, 255),
                                        rgb(0, 0, 150), 32, - 1.0, 1.0)
              chart_add_slot_colored(ctx, CHART_COLUMN, rgb(0, 255, 0),
                                        rgb(0, 150, 0), 32, 0.0, 1.0)

              i = 0
              id = 0
              while i < 32:
                chart_push_slot(ctx, cast[cfloat](fabs(sin(id))), 0)
                chart_push_slot(ctx, cast[cfloat](fabs(cos(id))), 1)
                chart_push_slot(ctx, cast[cfloat](fabs(sin(id))), 2)
                inc(id, step)
                inc(i)

            chart_end(ctx)

          group_end(ctx)

        else:
          style_pop_vec2(ctx)

        tree_pop(ctx)

      if tree_push(ctx, TREE_NODE, "Simple", MINIMIZED) != 0:
        var tab: panel

        layoutRowDynamic(ctx, 300, 2)
        if group_begin(ctx, addr(tab), "Group_Without_Border", 0):
          var i: cint = 0
          var buffer: array[64, char]
          layoutRowStatic(ctx, 18, 150, 1)

          i = 0
          while i < 64:
            sprintf(buffer, "0x%02x", i)
            labelf(ctx, TEXT_LEFT, "%s: scrollable region", buffer)
            inc(i)

          group_end(ctx)

        if group_begin(ctx, addr(tab), "Group_With_Border", WINDOW_BORDER):
          var i: cint = 0
          var buffer: array[64, char]
          layoutRowDynamic(ctx, 25, 2)

          i = 0
          while i < 64:
            sprintf(buffer, "%08d",
                    ((((i mod 7) * 10) xor 32)) + (64 + (i mod 2) * 2))
            button_label(ctx, buffer)
            inc(i)

          group_end(ctx)

        tree_pop(ctx)

      if tree_push(ctx, TREE_NODE, "Complex", MINIMIZED) != 0:
        var i: cint
        var tab: panel
        layout_space_begin(ctx, STATIC, 500, 64)
        layout_space_push(ctx, rect(0, 0, 150, 500))

        if group_begin(ctx, addr(tab), "Group_left", WINDOW_BORDER):
          var selected: array[32, cint]
          layoutRowStatic(ctx, 18, 100, 1)

          i = 0
          while i < 32:
            selectableLabel(ctx, if (selected[i]): "Selected" else: "Unselected",
                                TEXT_CENTERED, addr(selected[i]))
            inc(i)

          group_end(ctx)

        layout_space_push(ctx, rect(160, 0, 150, 240))
        if group_begin(ctx, addr(tab), "Group_top", WINDOW_BORDER):
          layoutRowDynamic(ctx, 25, 1)
          button_label(ctx, "#FFAA")
          button_label(ctx, "#FFBB")
          button_label(ctx, "#FFCC")
          button_label(ctx, "#FFDD")
          button_label(ctx, "#FFEE")
          button_label(ctx, "#FFFF")
          group_end(ctx)

        layout_space_push(ctx, rect(160, 250, 150, 250))
        if group_begin(ctx, addr(tab), "Group_buttom", WINDOW_BORDER):
          layoutRowDynamic(ctx, 25, 1)
          button_label(ctx, "#FFAA")
          button_label(ctx, "#FFBB")
          button_label(ctx, "#FFCC")
          button_label(ctx, "#FFDD")
          button_label(ctx, "#FFEE")
          button_label(ctx, "#FFFF")
          group_end(ctx)

        layout_space_push(ctx, rect(320, 0, 150, 150))
        if group_begin(ctx, addr(tab), "Group_right_top", WINDOW_BORDER):
          var selected: array[4, cint]
          layoutRowStatic(ctx, 18, 100, 1)

          i = 0
          while i < 4:
            selectableLabel(ctx, if (selected[i]): "Selected" else: "Unselected",
                                TEXT_CENTERED, addr(selected[i]))
            inc(i)

          group_end(ctx)

        layout_space_push(ctx, rect(320, 160, 150, 150))
        if group_begin(ctx, addr(tab), "Group_right_center", WINDOW_BORDER):
          var selected: array[4, cint]
          layoutRowStatic(ctx, 18, 100, 1)

          i = 0
          while i < 4:
            selectableLabel(ctx, if (selected[i]): "Selected" else: "Unselected",
                                TEXT_CENTERED, addr(selected[i]))
            inc(i)

          group_end(ctx)

        layout_space_push(ctx, rect(320, 320, 150, 150))

        if group_begin(ctx, addr(tab), "Group_right_bottom", WINDOW_BORDER):
          var selected: array[4, cint]
          layoutRowStatic(ctx, 18, 100, 1)

          i = 0
          while i < 4:
            selectableLabel(ctx, if (selected[i]): "Selected" else: "Unselected",
                                TEXT_CENTERED, addr(selected[i]))
            inc(i)

          group_end(ctx)

        layout_space_end(ctx)
        tree_pop(ctx)

      if tree_push(ctx, TREE_NODE, "Splitter", MINIMIZED) != 0:
        var `in`: ptr Input = addr(ctx.input)
        layoutRowStatic(ctx, 20, 320, 1)
        label(ctx, "Use slider and spinner to change tile size", TEXT_LEFT)
        label(ctx, "Drag the space between tiles to change tile ratio",
                 TEXT_LEFT)

        if tree_push(ctx, TREE_NODE, "Vertical", MINIMIZED) != 0:
          var
            a: cfloat = 100
            b: cfloat = 100
            c: cfloat = 100
          var bounds: Rect
          var sub: Panel
          var row_layout: array[5, cfloat]
          row_layout[0] = a
          row_layout[1] = 8
          row_layout[2] = b
          row_layout[3] = 8
          row_layout[4] = c

          ## header
          layoutRowStatic(ctx, 30, 100, 2)
          label(ctx, "left:", TEXT_LEFT)
          slider_float(ctx, 10.0, addr(a), 200.0, 10.0)
          label(ctx, "middle:", TEXT_LEFT)
          slider_float(ctx, 10.0, addr(b), 200.0, 10.0)
          label(ctx, "right:", TEXT_LEFT)
          slider_float(ctx, 10.0, addr(c), 200.0, 10.0)

          ## tiles
          layoutRow(ctx, STATIC, 200, 5, row_layout)

          ## left space
          if group_begin(ctx, addr(sub), "left", WINDOW_NO_SCROLLBAR or
              WINDOW_BORDER or WINDOW_NO_SCROLLBAR):
            layoutRowDynamic(ctx, 25, 1)
            button_label(ctx, "#FFAA")
            button_label(ctx, "#FFBB")
            button_label(ctx, "#FFCC")
            button_label(ctx, "#FFDD")
            button_label(ctx, "#FFEE")
            button_label(ctx, "#FFFF")
            group_end(ctx)

          bounds = widget_bounds(ctx)
          spacing(ctx, 1)

          if (input_is_mouse_hovering_rect(`in`, bounds) or
              input_is_mouse_prev_hovering_rect(`in`, bounds)) and
              input_is_mouse_down(`in`, BUTTON_LEFT):
            a = row_layout[0] + `in`.mouse.delta.x
            b = row_layout[2] - `in`.mouse.delta.x

          if group_begin(ctx, addr(sub), "center",
                           WINDOW_BORDER or WINDOW_NO_SCROLLBAR):
            layoutRowDynamic(ctx, 25, 1)
            button_label(ctx, "#FFAA")
            button_label(ctx, "#FFBB")
            button_label(ctx, "#FFCC")
            button_label(ctx, "#FFDD")
            button_label(ctx, "#FFEE")
            button_label(ctx, "#FFFF")
            group_end(ctx)

          bounds = widget_bounds(ctx)
          spacing(ctx, 1)

          if (input_is_mouse_hovering_rect(`in`, bounds) or
              input_is_mouse_prev_hovering_rect(`in`, bounds)) and
              input_is_mouse_down(`in`, BUTTON_LEFT):
            b = (row_layout[2] + `in`.mouse.delta.x)
            c = (row_layout[4] - `in`.mouse.delta.x)

          if group_begin(ctx, addr(sub), "right",
                           WINDOW_BORDER or WINDOW_NO_SCROLLBAR):
            layoutRowDynamic(ctx, 25, 1)
            button_label(ctx, "#FFAA")
            button_label(ctx, "#FFBB")
            button_label(ctx, "#FFCC")
            button_label(ctx, "#FFDD")
            button_label(ctx, "#FFEE")
            button_label(ctx, "#FFFF")
            group_end(ctx)

          tree_pop(ctx)

        if tree_push(ctx, TREE_NODE, "Horizontal", MINIMIZED) != 0:
          var
            a: cfloat = 100
            b: cfloat = 100
            c: cfloat = 100
          var sub: Panel
          var bounds: Rect

          ## header
          layoutRowStatic(ctx, 30, 100, 2)
          label(ctx, "top:", TEXT_LEFT)
          slider_float(ctx, 10.0, addr(a), 200.0, 10.0)
          label(ctx, "middle:", TEXT_LEFT)
          slider_float(ctx, 10.0, addr(b), 200.0, 10.0)
          label(ctx, "bottom:", TEXT_LEFT)
          slider_float(ctx, 10.0, addr(c), 200.0, 10.0)

          ## top space
          layoutRowDynamic(ctx, a, 1)
          if group_begin(ctx, addr(sub), "top",
                           WINDOW_NO_SCROLLBAR or WINDOW_BORDER):
            layoutRowDynamic(ctx, 25, 3)
            button_label(ctx, "#FFAA")
            button_label(ctx, "#FFBB")
            button_label(ctx, "#FFCC")
            button_label(ctx, "#FFDD")
            button_label(ctx, "#FFEE")
            button_label(ctx, "#FFFF")
            group_end(ctx)

          layoutRowDynamic(ctx, 8, 1)
          bounds = widget_bounds(ctx)
          spacing(ctx, 1)

          if (input_is_mouse_hovering_rect(`in`, bounds) or
              input_is_mouse_prev_hovering_rect(`in`, bounds)) and
              input_is_mouse_down(`in`, BUTTON_LEFT):
            a = a + `in`.mouse.delta.y
            b = b - `in`.mouse.delta.y

          layoutRowDynamic(ctx, b, 1)
          if group_begin(ctx, addr(sub), "middle",
                           WINDOW_NO_SCROLLBAR or WINDOW_BORDER):
            layoutRowDynamic(ctx, 25, 3)
            button_label(ctx, "#FFAA")
            button_label(ctx, "#FFBB")
            button_label(ctx, "#FFCC")
            button_label(ctx, "#FFDD")
            button_label(ctx, "#FFEE")
            button_label(ctx, "#FFFF")
            group_end(ctx)

          ## scaler
          layoutRowDynamic(ctx, 8, 1)
          bounds = widget_bounds(ctx)

          if (input_is_mouse_hovering_rect(`in`, bounds) or
              input_is_mouse_prev_hovering_rect(`in`, bounds)) and
              input_is_mouse_down(`in`, BUTTON_LEFT):
            b = b + `in`.mouse.delta.y
            c = c - `in`.mouse.delta.y

          ## bottom space
          layoutRowDynamic(ctx, c, 1)

          if group_begin(ctx, addr(sub), "bottom",
                           WINDOW_NO_SCROLLBAR or WINDOW_BORDER):
            layoutRowDynamic(ctx, 25, 3)
            button_label(ctx, "#FFAA")
            button_label(ctx, "#FFBB")
            button_label(ctx, "#FFCC")
            button_label(ctx, "#FFDD")
            button_label(ctx, "#FFEE")
            button_label(ctx, "#FFFF")
            group_end(ctx)

          tree_pop(ctx)

        tree_pop(ctx)

      tree_pop(ctx)

  return not window_is_closed(ctx, "Overview")
