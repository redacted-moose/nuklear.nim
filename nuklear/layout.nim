import core/nuklear_context, core/nuklear_api

{.push cdecl, header: "src/nuklear.h".}

## Layout
proc row_dynamic*(a2: ptr Context; height: cfloat; cols: cint) {.importc: "nk_layout_row_dynamic".}
proc row_static*(a2: ptr Context; height: cfloat; item_width: cint; cols: cint) {.importc: "nk_layout_row_static".}
proc row_begin*(a2: ptr Context; a3: LayoutFormat; row_height: cfloat;
                      cols: cint) {.importc: "nk_layout_row_begin".}
proc row_push*(a2: ptr Context; value: cfloat) {.importc: "nk_layout_row_push".}
proc row_end*(a2: ptr Context) {.importc: "nk_layout_row_end".}
proc row*(a2: ptr Context; a3: LayoutFormat; height: cfloat; cols: cint;
                ratio: ptr cfloat) {.importc: "nk_layout_row".}
proc ratio_from_pixel*(a2: ptr Context; pixel_width: cfloat): cfloat {.importc: "nk_layout_ratio_from_pixel".}

{.pop.}
