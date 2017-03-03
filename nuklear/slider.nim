import core/nuklear_context

{.push cdecl, header: "src/nuklear.h".}

## Widgets: Slider
proc sliderFloat*(a2: ptr Context; min: cfloat; val: cfloat; max: cfloat; step: cfloat): cfloat {.importc: "nk_slide_float".}
proc sliderInt*(a2: ptr Context; min: cint; val: cint; max: cint; step: cint): cint {.importc: "nk_slide_int".}
proc sliderFloat*(a2: ptr Context; min: cfloat; val: ptr cfloat; max: cfloat; step: cfloat): cint {.importc: "nk_slider_float".}
proc sliderInt*(a2: ptr Context; min: cint; val: ptr cint; max: cint; step: cint): cint {.importc: "nk_slider_int".}

{.pop.}
