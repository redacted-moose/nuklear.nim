## nuklear - v1.00 - public domain
## This is a simple node editor just to show a simple implementation and that
##  it is possible to achieve it with this library. While all nodes inside this
##  example use a simple color modifier as content you could change them
##  to have your custom content depending on the node time.
##  Biggest difference to most usual implementation is that this example does
##  not have connectors on the right position of the property that it links.
##  This is mainly done out of laziness and could be implemented as well but
##  requires calculating the position of all rows and add connectors.
##  In addition adding and removing nodes is quite limited at the
##  moment since it is based on a simple fixed array. If this is to be converted
##  into something more serious it is probably best to extend it.

import ../nuklear, math

type
  Node = object
    id: int
    name: string
    bounds: Rect
    value: float
    color: Color
    inputCount: int
    outputCount: int
    next: ptr Node
    prev: ptr Node

  NodeLink = object
    inputId: int
    inputSlot: int
    outputId: int
    outputSlot: int
    input: Vec2
    output: Vec2

  NodeLinking = object
    active: bool
    node: ptr Node
    inputId: int
    inputSlot: int

  NodeEditor = object
    initialized: bool
    nodeBuf: array[32, Node]
    # nodeBuf: seq[Node]
    # links: array[64, NodeLink]
    links: seq[NodeLink]
    begin: ptr Node
    `end`: ptr Node
    nodeCount: int
    # link_count: int
    bounds: Rect
    selected: ptr Node
    showGrid: bool
    scrolling: Vec2
    linking: NodeLinking


var nk_nodeEditor: NodeEditor

proc push(editor: ptr NodeEditor; node: ptr Node) =
  if editor.begin == nil:
    node.next = nil
    node.prev = nil
    editor.begin = node
    editor.`end` = node
  else:
    node.prev = editor.`end`
    if editor.`end` != nil: editor.`end`.next = node
    node.next = nil
    editor.`end` = node

proc pop(editor: ptr NodeEditor; node: ptr Node) =
  if node.next != nil: node.next.prev = node.prev
  if node.prev != nil: node.prev.next = node.next
  if editor.`end` == node: editor.`end` = node.prev
  if editor.begin == node: editor.begin = node.next
  node.next = nil
  node.prev = nil

proc find(editor: ptr NodeEditor; id: int): ptr Node =
  var iter: ptr Node = editor.begin
  while iter != nil:
    if iter.id == id: return iter
    iter = iter.next
  return nil


proc add(editor: ptr NodeEditor; name: string; bounds: Rect; col: Color; inCount: int; outCount: int) =
  var ids {.global.}: int = 0

  assert(editor.nodeCount < len(editor.nodeBuf))

  let node: ptr Node = addr(editor.nodeBuf[editor.nodeCount])
  inc editor.nodeCount

  # var node: Node

  node.id = ids
  inc ids

  node.value = 0
  node.color = rgb(255, 0, 0)
  node.inputCount = inCount
  node.outputCount = outCount
  node.color = col
  node.bounds = bounds
  # strcpy(node.name, name)
  # Strings are copied on assignment
  node.name = name
  # editor.nodeBuf.add(node)
  editor.push(node)

proc link(editor: ptr NodeEditor; inId: int; inSlot: int; outId: int; outSlot: int) =
  if editor.links == nil: editor.links = @[]
  # assert(editor.link_count < len(editor.links))

  # let link: ptr NodeLink = addr(editor.links[editor.link_count])
  # inc editor.link_count

  var link: NodeLink

  link.inputId = inId
  link.inputSlot = inSlot

  link.outputId = outId
  link.outputSlot = outSlot
  editor.links.add(link)

proc init(editor: ptr NodeEditor) =
  zeroMem(editor, sizeof(editor[]))

  editor.begin = nil
  editor.`end` = nil

  editor.add("Source", rect(40, 10, 180, 220), rgb(255, 0, 0), 0, 1)
  editor.add("Source", rect(40, 260, 180, 220), rgb(0, 255, 0), 0, 1)
  editor.add("Combine", rect(400, 100, 180, 220), rgb(0, 0, 255), 2, 2)

  editor.link(0, 0, 2, 0)
  editor.link(1, 0, 2, 1)

  editor.showGrid = true

proc initNodeEditor*(ctx: PContext): int =
  let
    input: ptr Input = addr(ctx.input)
    nodedit: ptr NodeEditor = addr(nk_nodeEditor)

  var
    # n: cint = 0
    updated: ptr Node = nil

  if not nodedit.initialized:
    nodedit.init()
    nodedit.initialized = true

  var
    layout: Panel

  let windowFlags = WINDOW_BORDER or WINDOW_NO_SCROLLBAR or WINDOW_MOVABLE or WINDOW_CLOSABLE

  begin(ctx, layout, "NodeEdit", rect(0, 0, 800, 600), windowFlags):
    ## allocate complete window space
    let
      size: Rect = ctx.layoutSpaceBounds()
      canvas: ptr CommandBuffer = ctx.getWindowCanvas()
      totalSpace: Rect = ctx.getWindowContentRegion()

    ctx.layoutSpaceBegin(STATIC, totalSpace.h, nodedit.nodeCount.cint)

    var
      it: ptr Node = nodedit.begin

    var
      node: Panel
      menu: Panel

    if nodedit.showGrid:
      ## display grid
      let
        gridSize: float = 32.0
        gridColor: Color = rgb(50, 50, 50)

      var
        x: float = fmod(size.x - nodedit.scrolling.x, gridSize)
        y: float = fmod(size.y - nodedit.scrolling.y, gridSize)

      while x < size.w:
        canvas.strokeLine(x + size.x, size.y, x + size.x, size.y + size.h, 1.0, gridColor)
        x += gridSize

      while y < size.h:
        canvas.strokeLine(size.x, y + size.y, size.x + size.w, y + size.y, 1.0, gridColor)
        y += gridSize

    while it != nil:
      ## calculate scrolled node window position and size
      ctx.layoutSpacePush(rect(it.bounds.x - nodedit.scrolling.x,
                               it.bounds.y - nodedit.scrolling.y,
                               it.bounds.w, it.bounds.h))

      ## execute node window
      let nodeWindowFlags = WINDOW_MOVABLE or WINDOW_NO_SCROLLBAR or WINDOW_BORDER or WINDOW_TITLE

      if ctx.groupBegin(addr(node), it.name, nodeWindowFlags) != 0:
        ## always have last selected node on top
        if input.mouseClicked(BUTTON_LEFT, node.bounds) != 0 and
            (not (it.prev != nil and
            input.mouseClicked(BUTTON_LEFT, ctx.layoutSpaceRectToScreen(
            node.bounds)) != 0)) and nodedit.`end` != it:
          updated = it

        ctx.layoutRowDynamic(25, 1)
        discard ctx.buttonColor(it.color)
        it.color.r = ctx.propertyi("#R:", 0, it.color.r.cint, 255, 1, 1.0).byte
        it.color.g = ctx.propertyi("#G:", 0, it.color.g.cint, 255, 1, 1.0).byte
        it.color.b = ctx.propertyi("#B:", 0, it.color.b.cint, 255, 1, 1.0).byte
        it.color.a = ctx.propertyi("#A:", 0, it.color.a.cint, 255, 1, 1.0).byte

        ## ====================================================

        ctx.groupEnd()

      ## node connector and linking
      var bounds: Rect = ctx.layoutSpaceRectToLocal(node.bounds)
      bounds.x += nodedit.scrolling.x
      bounds.y += nodedit.scrolling.y
      it.bounds = bounds

      ## output connector
      var space: float = node.bounds.h / float(it.outputCount + 1)

      for n in 0..<it.outputCount:
        var circle: Rect

        circle.x = node.bounds.x + node.bounds.w - 4
        circle.y = node.bounds.y + space * float(n + 1)
        circle.w = 8
        circle.h = 8

        canvas.fillCircle(circle, rgb(100, 100, 100))

        ## start linking process
        if input.hasMouseClickDownInRect(BUTTON_LEFT, circle, true.cint) != 0:
          nodedit.linking.active = true
          nodedit.linking.node = it
          nodedit.linking.inputId = it.id
          nodedit.linking.inputSlot = n

        if nodedit.linking.active and nodedit.linking.node == it and nodedit.linking.inputSlot == n:
          let
            l0: Vec2 = vec2(circle.x + 3, circle.y + 3)
            l1: Vec2 = input.mouse.pos

          canvas.strokeCurve(l0.x, l0.y, l0.x + 50.0, l0.y, l1.x - 50.0, l1.y, l1.x,
                             l1.y, 1.0, rgb(100, 100, 100))

      ## input connector
      space = node.bounds.h / float(it.inputCount + 1)

      for n in 0..<it.inputCount:
        var circle: Rect

        circle.x = node.bounds.x - 4
        circle.y = node.bounds.y + space * float(n + 1)
        circle.w = 8
        circle.h = 8

        canvas.fillCircle(circle, rgb(100, 100, 100))

        if input.isMouseReleased(BUTTON_LEFT) != 0 and
            input.isMouseHoveringRect(circle) != 0 and
            nodedit.linking.active and nodedit.linking.node != it:
          nodedit.linking.active = false
          nodedit.link(nodedit.linking.inputId,
                       nodedit.linking.inputSlot, it.id, n)

      it = it.next

    ## reset linking connection
    if nodedit.linking.active and input.isMouseReleased(BUTTON_LEFT) != 0:
      nodedit.linking.active = false
      nodedit.linking.node = nil
      stdout.write("linking failed\n")

    # for n in 0..nodedit.link_count - 1:
    for link in nodedit.links:
      let
        # link: ptr NodeLink = addr(nodedit.links[n])
        ni: ptr Node = nodedit.find(link.inputId)
        no: ptr Node = nodedit.find(link.outputId)
        spacei: float = node.bounds.h / float(ni.outputCount + 1)
        spaceo: float = node.bounds.h / float(no.inputCount + 1)

      var
        l0: Vec2 = ctx.layoutSpaceToScreen(vec2(ni.bounds.x + ni.bounds.w,
          3.0 + ni.bounds.y + spacei * float(link.inputSlot + 1)))
        l1: Vec2 = ctx.layoutSpaceToScreen(vec2(no.bounds.x,
          3.0 + no.bounds.y + spaceo * float(link.outputSlot + 1)))

      l0.x -= nodedit.scrolling.x
      l0.y -= nodedit.scrolling.y
      l1.x -= nodedit.scrolling.x
      l1.y -= nodedit.scrolling.y
      canvas.strokeCurve(l0.x, l0.y, l0.x + 50.0, l0.y, l1.x - 50.0, l1.y, l1.x, l1.y, 1.0, rgb(100, 100, 100))

    if updated != nil:
      ## reshuffle nodes to have least recently selected node on top
      nodedit.pop(updated)
      nodedit.push(updated)

    if input.mouseClicked(BUTTON_LEFT, ctx.layoutSpaceBounds()) != 0:
      it = nodedit.begin
      nodedit.selected = nil
      nodedit.bounds = newRect(input.mouse.pos.x, input.mouse.pos.y, 100, 200)
      while it != nil:
        var b: Rect = ctx.layoutSpaceRectToScreen(it.bounds)

        b.x -= nodedit.scrolling.x
        b.y -= nodedit.scrolling.y

        if input.isMouseHoveringRect(b) != 0:
          nodedit.selected = it

        it = it.next

    if ctx.contextualBegin(addr(menu), 0, vec2(100, 220), ctx.getWindowBounds()) != 0:
      let gridOption = ["Show Grid", "Hide Grid"]

      ctx.layoutRowDynamic(25, 1)
      if ctx.contextualItemLabel("New", Flags(TEXT_CENTERED)) != 0:
        nodedit.add("New", rect(400, 260, 180, 220), rgb(255, 255, 255), 1, 2)

      if ctx.contextualItemLabel(gridOption[nodedit.showGrid.int], Flags(TEXT_CENTERED)) != 0:
        nodedit.showGrid = not nodedit.showGrid

      ctx.contextualEnd()

    ctx.layoutSpaceEnd()

    ## window content scrolling
    if input.isMouseHoveringRect(ctx.getWindowBounds()) != 0 and input.isMouseDown(BUTTON_MIDDLE) != 0:
      nodedit.scrolling.x += input.mouse.delta.x
      nodedit.scrolling.y += input.mouse.delta.y

  return not ctx.windowIsClosed("NodeEdit")
