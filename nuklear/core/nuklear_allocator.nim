{.pragma: nuklear, cdecl, header: "src/nuklear.h".}

import nuklear_api

type
  PluginAlloc* = proc (a2: Handle; old: pointer; a4: csize): pointer {.cdecl.}
  PluginFree* = proc (a2: Handle; old: pointer) {.cdecl.}
  Allocator* {.importc: "struct nk_allocator", header: "src/nuklear.h".} = object
    userdata* {.importc: "userdata".}: Handle
    alloc* {.importc: "alloc".}: PluginAlloc
    free* {.importc: "free".}: PluginFree
