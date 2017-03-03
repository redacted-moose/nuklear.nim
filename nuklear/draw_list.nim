import core/nuklear_memory_buffer, core/nuklear_context, core/nuklear_draw_list

## Drawing
when defined(vertexBufferOutput):
  proc convert*(a2: ptr Context; cmds: ptr Buffer; vertices: ptr Buffer;
               elements: ptr Buffer; a6: ptr ConvertConfig) {.cdecl,
      importc: "nk_convert", header: "src/nuklear.h".}
  proc drawBegin*(a2: ptr Context; a3: ptr Buffer): ptr DrawCommand {.cdecl,
      importc: "nk__draw_begin", header: "src/nuklear.h".}
  proc drawEnd*(a2: ptr Context; a3: ptr Buffer): ptr DrawCommand {.cdecl,
      importc: "nk__draw_end", header: "src/nuklear.h".}
  proc drawNext*(a2: ptr DrawCommand; a3: ptr Buffer; a4: ptr Context): ptr DrawCommand {.
      cdecl, importc: "nk__draw_next", header: "src/nuklear.h".}
