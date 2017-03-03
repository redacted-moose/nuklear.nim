{.pragma: nuklear, header: "src/nuklear.h".}

import nuklear_allocator

##  ==============================================================
##
##                           MEMORY BUFFER
##
##  ==============================================================
##  A basic (double)-buffer with linear allocation and resetting as only
##    freeing policy. The buffer's main purpose is to control all memory management
##    inside the GUI toolkit and still leave memory control as much as possible in
##    the hand of the user while also making sure the library is easy to use if
##    not as much control is needed.
##    In general all memory inside this library can be provided from the user in
##    three different ways.
##
##    The first way and the one providing most control is by just passing a fixed
##    size memory block. In this case all control lies in the hand of the user
##    since he can exactly control where the memory comes from and how much memory
##    the library should consume. Of course using the fixed size API removes the
##    ability to automatically resize a buffer if not enough memory is provided so
##    you have to take over the resizing. While being a fixed sized buffer sounds
##    quite limiting, it is very effective in this library since the actual memory
##    consumption is quite stable and has a fixed upper bound for a lot of cases.
##
##    If you don't want to think about how much memory the library should allocate
##    at all time or have a very dynamic UI with unpredictable memory consumption
##    habits but still want control over memory allocation you can use the dynamic
##    allocator based API. The allocator consists of two callbacks for allocating
##    and freeing memory and optional userdata so you can plugin your own allocator.
##
##    The final and easiest way can be used by defining
##    defaultAllocator which uses the standard library memory
##    allocation functions malloc and free and takes over complete control over
##    memory in this library.
##


type
  AllocationType* {.size: sizeof(cint).} = enum
    BUFFER_FIXED, BUFFER_DYNAMIC

  BufferAllocationType* {.size: sizeof(cint).} = enum
    BUFFER_FRONT, BUFFER_BACK, BUFFER_MAX

  MemoryStatus* {.nuklear, importc: "struct nk_memory_status".} = object
    memory* {.importc: "memory".}: pointer
    `type`* {.importc: "type".}: cuint
    size* {.importc: "size".}: csize
    allocated* {.importc: "allocated".}: csize
    needed* {.importc: "needed".}: csize
    calls* {.importc: "calls".}: csize

  BufferMarker* {.nuklear, importc: "struct nk_buffer_marker".} = object
    active* {.importc: "active".}: cint
    offset* {.importc: "offset".}: csize

  Memory* {.nuklear, importc: "struct nk_memory".} = object
    `ptr`* {.importc: "ptr".}: pointer
    size* {.importc: "size".}: csize

  Buffer* {.nuklear, importc: "struct nk_buffer".} = object
    marker* {.importc: "marker".}: array[BUFFER_MAX, BufferMarker] ## buffer marker to free a buffer to a certain offset
    pool* {.importc: "pool".}: Allocator                           ## allocator callback for dynamic buffers
    `type`* {.importc: "type".}: AllocationType                    ## memory management type
    memory* {.importc: "memory".}: Memory                          ## memory and size of the current memory block
    grow_factor* {.importc: "grow_factor".}: cfloat                ## growing factor for dynamic memory management
    allocated* {.importc: "allocated".}: csize                     ## total amount of memory allocated
    needed* {.importc: "needed".}: csize                           ## totally consumed memory given that enough memory is present
    calls* {.importc: "calls".}: csize                             ## number of allocation calls
    size* {.importc: "size".}: csize                               ## current size of the buffer


when defined(defaultAllocator):
  proc bufferInitDefault*(a2: ptr Buffer) {.nuklear, importc: "nk_buffer_init_default".}
proc bufferInit*(a2: ptr Buffer; a3: ptr Allocator; size: csize) {.nuklear, importc: "nk_buffer_init".}
proc bufferInitFixed*(a2: ptr Buffer; memory: pointer; size: csize) {.nuklear, importc: "nk_buffer_init_fixed".}
proc bufferInfo*(a2: ptr MemoryStatus; a3: ptr Buffer) {.nuklear, importc: "nk_buffer_info".}
proc push*(a2: ptr Buffer; kind: BufferAllocationType; memory: pointer; size: csize; align: csize) {.nuklear, importc: "nk_buffer_push".}
proc mark*(a2: ptr Buffer; kind: BufferAllocationType) {.nuklear, importc: "nk_buffer_mark".}
proc reset*(a2: ptr Buffer; kind: BufferAllocationType) {.nuklear, importc: "nk_buffer_reset".}
proc clear*(a2: ptr Buffer) {.nuklear, importc: "nk_buffer_clear".}
proc free*(a2: ptr Buffer) {.nuklear, importc: "nk_buffer_free".}
proc memory*(a2: ptr Buffer): pointer {.nuklear, importc: "nk_buffer_memory".}
proc memoryConst*(a2: ptr Buffer): pointer {.nuklear, importc: "nk_buffer_memory_const".}
proc total*(a2: ptr Buffer): csize {.nuklear, importc: "nk_buffer_total".}
