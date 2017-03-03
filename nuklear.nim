{.deadCodeElim: on, passC: "-Inuklear/core/", compile: "nuklear/core/nuklear.c".}

import
  nuklear.core.nuklear_allocator as nk_allocator,
  nuklear.core.nuklear_api as nk_api,
  nuklear.core.nuklear_constants as nk_constants,
  nuklear.core.nuklear_context as nk_context,
  nuklear.core.nuklear_draw_list as nk_draw_list,
  nuklear.core.nuklear_drawing as nk_drawing,
  nuklear.core.nuklear_font as nk_font,
  nuklear.core.nuklear_gui as nk_gui,
  nuklear.core.nuklear_input as nk_input,
  nuklear.core.nuklear_memory_buffer as nk_memory_buffer,
  nuklear.core.nuklear_panel as nk_panel,
  nuklear.core.nuklear_stack as nk_stack,
  nuklear.core.nuklear_string as nk_string,
  nuklear.core.nuklear_table as nk_table,
  nuklear.core.nuklear_text_edit as nk_text_edit,
  nuklear.core.nuklear_window as nk_window

import
  nuklear.drawing,
  nuklear.draw_list

export
  nk_allocator,
  nk_api,
  nk_constants,
  nk_context,
  nk_draw_list,
  nk_drawing,
  nk_font,
  nk_gui,
  nk_input,
  nk_memory_buffer,
  nk_panel,
  nk_stack,
  nk_string,
  nk_table,
  nk_text_edit,
  nk_window

type
  PContext* = ptr Context
  PHandle* = ptr Handle
  PVec2* = ptr Vec2
  PVec2i* = ptr Vec2i
  PRune* = ptr Rune
  PColor* = ptr Color
  # PColorf = ptr Colorf
  PRect* = ptr Rect
  PRecti* = ptr Recti
  PImage* = ptr Image
  PCursor* = ptr Cursor
  PScroll* = ptr Scroll
  PButtonBehavior* = ptr ButtonBehavior
  PPanel* = ptr Panel

proc initColor*(r: int, g: int, b: int): Color {.inline.} = rgb(r.cint, g.cint, b.cint)
proc initColor*(r: int, g: int, b: int, a: int): Color {.inline.} = rgba(r.cint, g.cint, b.cint, a.cint)
proc initColor*(rgba: uint): Color {.inline.} = rgbaU32(rgba)
proc initColor*(r: float, g: float, b: float): Color {.inline.} = rgbF(r.cfloat, g.cfloat, b.cfloat)
proc initColor*(r: float, g: float, b: float, a: float): Color {.inline.} = rgbaF(r.cfloat, g.cfloat, b.cfloat, a.cfloat)
# proc initColor*(h: int, s: int, v: int): Color = hsv(h.cint, s.cint, v.cint)

converter toUint*(color: Color): uint {.inline.} = colorU32(color)

proc initVec2*(x: float, y: float): Vec2 {.inline.} = vec2(x.cfloat, y.cfloat)
proc initVec2*(x: int, y: int): Vec2 {.inline.} = vec2i(x.cint, y.cint)

when defined(vertexBufferOutput):
  proc initDrawVertexLayoutElement*(attribute: DrawVertexLayoutAttribute, format: DrawVertexLayoutFormat, offset: csize): DrawVertexLayoutElement =
    result.attribute = attribute
    result.format = format
    result.offset = offset

template vec2_sub*(a, b: Vec2): untyped =
  vec2((a).x - (b).x, (a).y - (b).y)

template vec2_add*(a, b: Vec2): untyped =
  vec2((a).x + (b).x, (a).y + (b).y)

template vec2_len_sqr*(a: Vec2): untyped =
  ((a).x * (a).x + (a).y * (a).y)

template vec2_muls*(a: Vec2, t: untyped): untyped =
  vec2((a).x * (t), (a).y * (t))

template ptr_add*(t, p, i: untyped): untyped =
  (cast[ptr t]((cast[pointer]((cast[ptr byte]((p)) + (i))))))

template ptr_add_const*(t, p, i: untyped): untyped =
  (cast[ptr t]((cast[pointer]((cast[ptr byte]((p)) + (i))))))

template zero_struct*(s: untyped): untyped =
  zeroMem(addr(s), sizeof((s)))

template offsetof*(typ, field): untyped =
  (var dummy: typ; cast[int](addr(dummy.field)) - cast[int](addr(dummy)))

proc `-`*(a, b: Vec2): Vec2 =
  return vec2_sub(a, b)

proc `+`*(a, b: Vec2): Vec2 =
  return vec2_add(a, b)

proc `or`*(a, b: PanelFlags): Flags =
  return Flags(a) or Flags(b)

proc `or`*(a: Flags, b: PanelFlags): Flags =
  return a or Flags(b)

proc `or`*(a: PanelFlags, b: Flags): Flags =
  return Flags(a) or b

proc newRect*(x: float, y: float, w: float, h: float): Rect {.inline.} =
  rect(x.cfloat, y.cfloat, w.cfloat, h.cfloat)

proc newRect*(x: int, y: int, w: int, h: int): Rect {.inline.} =
  recti(x.cint, y.cint, w.cint, h.cint)

proc newRect*(pos: Vec2, size: Vec2): Rect {.inline.} =
  recta(pos, size)

template begin*(ctx: PContext, layout: var Panel, title: string, rect: Rect, flags: Flags, body: untyped) =
  if begin(ctx, addr(layout), title, rect, flags) != 0:
    body
  `end`(ctx)

proc offset*[A](some: ptr A; b: int): ptr A =
  result = cast[ptr A](cast[int](some) + (b * sizeof(A)))

proc `+`*[A](some: ptr A, b: int): ptr A {.inline.} = some.offset(b)

proc inc*[A](some: var ptr A, b = 1) =
  some = some.offset(b)

proc `++`*[A](some: var ptr A): ptr A =
  ## prefix inc
  result = some
  inc some

when defined(fontBaking):
  proc bake*(atlas: var FontAtlas, width: var cint, height: var cint, format: FontAtlasFormat): pointer {.inline.} =
    bake(addr(atlas), addr(width), addr(height), format)

proc alloc* [A](num = 1): ptr A {.inline.} =
  cast[ptr A](alloc0(sizeof(A) * num))

proc `[]`*[A](some: ptr A; idx: int): var A {.inline.} =
  ## use offset() for tuple or array ptrs, this will not works
  some.offset(idx)[]

proc `[]=`*[A](some: ptr A; idx: int; val: A) {.inline.} =
  (some[idx]) = val

iterator iterPtr*[A](some: ptr A; num: int): ptr A =
  for i in 0.. <num:
    yield some.offset(i)

iterator commands*(ctx: PContext): ptr Command =
  var cmd = begin(ctx)
  while cmd != nil:
    yield cmd
    cmd = ctx.next(cmd)

when defined(vertexBufferOutput):
  iterator drawCommands*(ctx: PContext, b: ptr Buffer): ptr DrawCommand =
    var cmd = draw_begin(ctx, b)
    while cmd != nil:
      yield cmd
      cmd = draw_next(cmd, b, ctx)

  template draw_foreach_bounded*(cmd: untyped, `from`: typed, to: typed, body: untyped): untyped =
    var cmd = `from`
    while cmd != 0 and to != 0 && cmd >= to:
      body
      dec(cmd)

  # const
  #   VERTEX_LAYOUT_END* =
  #     VERTEX_ATTRIBUTE_COUNT
  #     FORMAT_COUNT
  #     0
  # const VERTEX_LAYOUT_END* = [nkVertexAttributeCount.cuint, FORMAT_COUNT.cuint, cuint(0)]
  const VERTEX_LAYOUT_END* = initDrawVertexLayoutElement(nkVertexAttributeCount, FORMAT_COUNT, 0)
