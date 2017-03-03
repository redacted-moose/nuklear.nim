import core/nuklear_context, core/nuklear_drawing

{.push cdecl, header: "src/nuklear.h".}

proc next*(a2: ptr Context; a3: ptr Command): ptr Command {.importc: "nk__next".}
proc begin*(a2: ptr Context): ptr Command {.importc: "nk__begin".}

{.pop.}
