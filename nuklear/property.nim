import core/nuklear_context

{.push cdecl, header: "src/nuklear.h".}

## Widgets: Property
proc propertyInt*(layout: ptr Context; name: cstring; min: cint; val: ptr cint; max: cint;
                  step: cint; inc_per_pixel: cfloat) {.importc: "nk_property_int".}
proc propertyFloat*(layout: ptr Context; name: cstring; min: cfloat; val: ptr cfloat;
                    max: cfloat; step: cfloat; inc_per_pixel: cfloat) {.importc: "nk_property_float".}
proc propertyDouble*(layout: ptr Context; name: cstring; min: cdouble;
                     val: ptr cdouble; max: cdouble; step: cdouble;
                     inc_per_pixel: cfloat) {.importc: "nk_property_double".}
proc propertyi*(layout: ptr Context; name: cstring; min: cint; val: cint; max: cint;
               step: cint; inc_per_pixel: cfloat): cint {.importc: "nk_propertyi".}
proc propertyf*(layout: ptr Context; name: cstring; min: cfloat; val: cfloat; max: cfloat;
               step: cfloat; inc_per_pixel: cfloat): cfloat {.importc: "nk_propertyf".}
proc propertyd*(layout: ptr Context; name: cstring; min: cdouble; val: cdouble;
               max: cdouble; step: cdouble; inc_per_pixel: cfloat): cdouble {.importc: "nk_propertyd".}

{.pop.}
