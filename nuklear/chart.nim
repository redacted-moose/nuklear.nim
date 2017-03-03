import core/nuklear_context, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}
## Chart
proc begin*(a2: ptr Context; a3: ChartType; num: cint; min: cfloat; max: cfloat): cint {.importc: "nk_chart_begin".}
proc begin_colored*(a2: ptr Context; a3: ChartType; a4: Color; active: Color;
                         num: cint; min: cfloat; max: cfloat): cint {.importc: "nk_chart_begin_colored".}
proc add_slot*(ctx: ptr Context; a3: ChartType; count: cint; min_value: cfloat;
                    max_value: cfloat) {.importc: "nk_chart_add_slot".}
proc add_slot_colored*(ctx: ptr Context; a3: ChartType; a4: Color; active: Color;
                            count: cint; min_value: cfloat; max_value: cfloat) {.importc: "nk_chart_add_slot_colored".}
proc push*(a2: ptr Context; a3: cfloat): Flags {.importc: "nk_chart_push".}
proc push_slot*(a2: ptr Context; a3: cfloat; a4: cint): Flags {.importc: "nk_chart_push_slot".}
proc `end`*(a2: ptr Context) {.importc: "nk_chart_end".}
{.pop.}
