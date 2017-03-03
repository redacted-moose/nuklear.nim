import core/nuklear_context, core/nuklear_api

type
  TreeType* {.size: sizeof(cint).} = enum
    TREE_NODE, TREE_TAB


## Layout: Tree
template tree_push*(ctx: ptr Context, typ: TreeType, title: string, state: CollapseStates): cint =
  let
    pos = instantiationInfo()
    fileLine = pos.filename & ":" & $pos.line

  tree_push_hashed(ctx, typ, title, state, fileLine, strlen(fileLine), pos.line.cint)

template tree_push_id*(ctx: ptr Context, typ: TreeType, title: string, state: CollapseStates, id: cint): cint =
  let
    pos = instantiationInfo()
    fileLine = pos.filename & ":" & $pos.line

  tree_push_hashed(ctx, typ, title, state, fileLine, strlen(fileLine), id)

proc tree_push_hashed*(a2: ptr Context; a3: TreeType; title: cstring;
                      initial_state: CollapseStates; hash: cstring; len: cint;
                      seed: cint): cint {.cdecl, importc: "nk_tree_push_hashed",
                                       header: "src/nuklear.h".}

template tree_image_push*(ctx: ptr Context, typ: TreeType, img: Image, title: string, state: CollapseStates): cint =
  let
    pos = instantiationInfo()
    fileLine = pos.filename & ":" & $pos.line

  tree_image_push_hashed(ctx, typ, img, title, state, fileLine, strlen(fileLine), pos.line)

template tree_image_push_id*(ctx: ptr Context, typ: TreeType, img: Image, title: string, state: CollapseStates, id: cint): cint =
  let
    pos = instantiationInfo()
    fileLine = pos.filename & ":" & $pos.line

  tree_image_push_hashed(ctx, typ, img, title, state, fileLine, strlen(fileLine), id)

{.push cdecl, header: "src/nuklear.h".}

proc tree_image_push_hashed*(a2: ptr Context; a3: TreeType; a4: Image; title: cstring;
                            initial_state: CollapseStates; hash: cstring;
                            len: cint; seed: cint): cint {.importc: "nk_tree_image_push_hashed".}

proc tree_pop*(a2: ptr Context) {.importc: "nk_tree_pop".}

{.pop.}
