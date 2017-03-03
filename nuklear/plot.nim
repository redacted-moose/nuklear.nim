import core/nuklear_context, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}
proc plot*(a2: ptr Context; a3: ChartType; values: ptr cfloat; count: cint; offset: cint) {.importc: "nk_plot".}

{.pop.}

proc function*(a2: ptr Context; a3: ChartType; userdata: pointer; value_getter: proc (
    user: pointer; index: cint): cfloat {.cdecl.}; count: cint; offset: cint) {.cdecl,
    importc: "nk_plot_function", header: "src/nuklear.h".}

