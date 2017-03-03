## nuklear - v1.00 - public domain

import ../nuklear

proc calculator*(ctx: PContext) =
  var layout: Panel

  let windowFlags = WINDOW_BORDER or WINDOW_NO_SCROLLBAR or WINDOW_MOVABLE

  begin(ctx, layout, "Calculator", newRect(10, 10, 180, 250), windowFlags):
    var
      set: cint = 0
      prev: cint = 0
      op: cint = 0
    var numbers: string = "789456123"
    var ops: string = "+-*/"
    var
      a: cdouble = 0
      b: cdouble = 0
    var current: ptr cdouble = addr(a)
    # var i: csize = 0
    var solve: bool = false
    var len: cint
    # var buffer: array[256, char]

    layoutRowDynamic(ctx, 35, 1)
    len = len($current[]).cint
    discard editString(ctx, Flags(EDIT_SIMPLE), $current[], addr(len), 255, filter_float)
    # buffer[len] = 0.char
    # current[] = atof(buffer)

    layoutRowDynamic(ctx, 35, 4)

    # i = 0
    # while i < 16:
    for i in 0..15:
      if i >= 12 and i < 15:
        if i > 12:
          continue

        if buttonLabel(ctx, "C") != 0:
          a = 0
          b = 0
          op = 0
          current = addr(a)
          set = 0

        if buttonLabel(ctx, "0") != 0:
          current[] = current[] * 10.0
          set = 0

        if buttonLabel(ctx, "=") != 0:
          solve = true
          prev = op
          op = 0

      elif ((i + 1) mod 4) != 0:
        if button_text(ctx, addr(numbers[(i div 4) * 3 + i mod 4]), 1) != 0:
          current[] = current[] * 10.0 + (numbers[(i div 4) * 3 + i mod 4].int - '0'.int).float
          set = 0

      elif button_text(ctx, addr(ops[i div 4]), 1) != 0:
        if set == 0:
          if current != addr(b):
            current = addr(b)

          else:
            prev = op
            solve = true

        op = ops[i div 4].cint
        set = 1

      # inc(i)

    if solve:
      if prev == '+'.cint: a = a + b
      if prev == '-'.cint: a = a - b
      if prev == '*'.cint: a = a * b
      if prev == '/'.cint: a = a / b

      current = addr(a)

      if set != 0: current = addr(b)

      b = 0
      set = 0
