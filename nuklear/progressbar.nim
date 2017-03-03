import core/nuklear_context

{.push cdecl, header: "src/nuklear.h".}

## Widgets: Progressbar
proc progress*(a2: ptr Context; cur: ptr csize; max: csize; modifyable: cint): cint {.importc: "nk_progress".}
proc prog*(a2: ptr Context; cur: csize; max: csize; modifyable: cint): csize {.importc: "nk_prog".}

{.pop.}
