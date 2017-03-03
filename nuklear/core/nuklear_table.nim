type
  Table* {.importc: "struct nk_table", header: "src/nuklear.h".} = object
    seq* {.importc: "seq".}: cuint
    # keys* {.importc: "keys".}: array[((sizeof(Window) div sizeof(uint)) div 2), Hash]
    # values* {.importc: "values".}: array[((sizeof(Window) div sizeof(uint)) div 2), uint]
    next* {.importc: "next".}: ptr Table
    prev* {.importc: "prev".}: ptr Table

