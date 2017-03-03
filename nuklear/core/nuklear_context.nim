{.pragma: nuklear, cdecl, header: "src/nuklear.h".}
import
  nuklear_allocator,
  nuklear_api,
  nuklear_drawing,
  nuklear_draw_list,
  nuklear_font,
  nuklear_gui,
  nuklear_input,
  nuklear_memory_buffer,
  nuklear_stack,
  nuklear_table,
  nuklear_text_edit,
  nuklear_window

type
  PageData* {.importc: "union nk_page_data", header: "src/nuklear.h".} = object {.union.}
    tbl* {.importc: "tbl".}: Table
    win* {.importc: "win".}: Window

  PageElement* {.importc: "struct nk_page_element", header: "src/nuklear.h".} = object
    data* {.importc: "data".}: PageData
    next* {.importc: "next".}: ptr PageElement
    prev* {.importc: "prev".}: ptr PageElement

  Page* {.importc: "struct nk_page", header: "src/nuklear.h".} = object
    size* {.importc: "size".}: cuint
    next* {.importc: "next".}: ptr Page
    win* {.importc: "win".}: array[1, PageElement]

  Pool* {.importc: "struct nk_pool", header: "src/nuklear.h".} = object
    alloc* {.importc: "alloc".}: Allocator
    `type`* {.importc: "type".}: AllocationType
    page_count* {.importc: "page_count".}: cuint
    pages* {.importc: "pages".}: ptr Page
    freelist* {.importc: "freelist".}: ptr PageElement
    capacity* {.importc: "capacity".}: cuint
    size* {.importc: "size".}: csize
    cap* {.importc: "cap".}: csize

when defined(vertexBufferOutput):
  when defined(commandUserdata):
    type
      Context* {.importc: "struct nk_context", header: "src/nuklear.h".} = object
        input* {.importc: "input".}: Input
        ## public: can be accessed freely
        style* {.importc: "style".}: Style
        memory* {.importc: "memory".}: Buffer
        clip* {.importc: "clip".}: Clipboard
        last_widget_state* {.importc: "last_widget_state".}: Flags
        delta_time_seconds* {.importc: "delta_time_seconds".}: cfloat
        button_behavior* {.importc: "button_behavior".}: ButtonBehavior
        stacks* {.importc: "stacks".}: ConfigurationStacks
        ## private:
        ##    should only be accessed if you
        ##    know what you are doing
        draw_list* {.importc: "draw_list".}: DrawList
        userdata* {.importc: "userdata".}: Handle
        ## text editor objects are quite big because of an internal
        ##      undo/redo stack. Therefore does not make sense to have one for
        ##      each window for temporary use cases, so I only provide *one* instance
        ##      for all windows. This works because the content is cleared anyway
        text_edit* {.importc: "text_edit".}: TextEdit ## draw buffer used for overlay drawing operation like cursor
        overlay* {.importc: "overlay".}: CommandBuffer ## windows
        build* {.importc: "build".}: cint
        use_pool* {.importc: "use_pool".}: cint
        pool* {.importc: "pool".}: Pool
        begin* {.importc: "begin".}: ptr Window
        `end`* {.importc: "end".}: ptr Window
        active* {.importc: "active".}: ptr Window
        current* {.importc: "current".}: ptr Window
        freelist* {.importc: "freelist".}: ptr PageElement
        count* {.importc: "count".}: cuint
        seq* {.importc: "seq".}: cuint

  else:
    type
      Context* {.importc: "struct nk_context", header: "src/nuklear.h".} = object
        input* {.importc: "input".}: Input
        ## public: can be accessed freely
        style* {.importc: "style".}: Style
        memory* {.importc: "memory".}: Buffer
        clip* {.importc: "clip".}: Clipboard
        last_widget_state* {.importc: "last_widget_state".}: Flags
        delta_time_seconds* {.importc: "delta_time_seconds".}: cfloat
        button_behavior* {.importc: "button_behavior".}: ButtonBehavior
        stacks* {.importc: "stacks".}: ConfigurationStacks
        ## private:
        ##    should only be accessed if you
        ##    know what you are doing
        draw_list* {.importc: "draw_list".}: DrawList
        ## text editor objects are quite big because of an internal
        ##      undo/redo stack. Therefore does not make sense to have one for
        ##      each window for temporary use cases, so I only provide *one* instance
        ##      for all windows. This works because the content is cleared anyway
        text_edit* {.importc: "text_edit".}: TextEdit
        ## draw buffer used for overlay drawing operation like cursor
        overlay* {.importc: "overlay".}: CommandBuffer
        ## windows
        build* {.importc: "build".}: cint
        use_pool* {.importc: "use_pool".}: cint
        pool* {.importc: "pool".}: Pool
        begin* {.importc: "begin".}: ptr Window
        `end`* {.importc: "end".}: ptr Window
        active* {.importc: "active".}: ptr Window
        current* {.importc: "current".}: ptr Window
        freelist* {.importc: "freelist".}: ptr PageElement
        count* {.importc: "count".}: cuint
        seq* {.importc: "seq".}: cuint

else:
  when defined(commandUserdata):
    type
      Context* {.importc: "struct nk_context", header: "src/nuklear.h".} = object
        input* {.importc: "input".}: Input
        ## public: can be accessed freely
        style* {.importc: "style".}: Style
        memory* {.importc: "memory".}: Buffer
        clip* {.importc: "clip".}: Clipboard
        last_widget_state* {.importc: "last_widget_state".}: Flags
        delta_time_seconds* {.importc: "delta_time_seconds".}: cfloat
        button_behavior* {.importc: "button_behavior".}: ButtonBehavior
        stacks* {.importc: "stacks".}: ConfigurationStacks
        ## private:
        ##    should only be accessed if you
        ##    know what you are doing
        userdata* {.importc: "userdata".}: Handle
        ## text editor objects are quite big because of an internal
        ##      undo/redo stack. Therefore does not make sense to have one for
        ##      each window for temporary use cases, so I only provide *one* instance
        ##      for all windows. This works because the content is cleared anyway
        text_edit* {.importc: "text_edit".}: TextEdit
        ## draw buffer used for overlay drawing operation like cursor
        overlay* {.importc: "overlay".}: CommandBuffer
        ## windows
        build* {.importc: "build".}: cint
        use_pool* {.importc: "use_pool".}: cint
        pool* {.importc: "pool".}: Pool
        begin* {.importc: "begin".}: ptr Window
        `end`* {.importc: "end".}: ptr Window
        active* {.importc: "active".}: ptr Window
        current* {.importc: "current".}: ptr Window
        freelist* {.importc: "freelist".}: ptr PageElement
        count* {.importc: "count".}: cuint
        seq* {.importc: "seq".}: cuint

  else:
    type
      Context* {.importc: "struct nk_context", header: "src/nuklear.h".} = object
        input* {.importc: "input".}: Input
        ## public: can be accessed freely
        style* {.importc: "style".}: Style
        memory* {.importc: "memory".}: Buffer
        clip* {.importc: "clip".}: Clipboard
        last_widget_state* {.importc: "last_widget_state".}: Flags
        delta_time_seconds* {.importc: "delta_time_seconds".}: cfloat
        button_behavior* {.importc: "button_behavior".}: ButtonBehavior
        stacks* {.importc: "stacks".}: ConfigurationStacks
        ## private:
        ##    should only be accessed if you
        ##    know what you are doing
        ## text editor objects are quite big because of an internal
        ##      undo/redo stack. Therefore does not make sense to have one for
        ##      each window for temporary use cases, so I only provide *one* instance
        ##      for all windows. This works because the content is cleared anyway
        text_edit* {.importc: "text_edit".}: TextEdit ## draw buffer used for overlay drawing operation like cursor
        overlay* {.importc: "overlay".}: CommandBuffer ## windows
        build* {.importc: "build".}: cint
        use_pool* {.importc: "use_pool".}: cint
        pool* {.importc: "pool".}: Pool
        begin* {.importc: "begin".}: ptr Window
        `end`* {.importc: "end".}: ptr Window
        active* {.importc: "active".}: ptr Window
        current* {.importc: "current".}: ptr Window
        freelist* {.importc: "freelist".}: ptr PageElement
        count* {.importc: "count".}: cuint
        seq* {.importc: "seq".}: cuint

{.push cdecl, header: "src/nuklear.h".}
when defined(defaultAllocator):
  proc init_default*(a2: ptr Context; a3: ptr UserFont): cint {.importc: "nk_init_default".}
proc init_fixed*(a2: ptr Context; memory: pointer; size: csize; a5: ptr UserFont): cint {.importc: "nk_init_fixed".}
proc init_custom*(a2: ptr Context; cmds: ptr Buffer; pool: ptr Buffer; a5: ptr UserFont): cint {.importc: "nk_init_custom".}
proc init*(a2: ptr Context; a3: ptr Allocator; a4: ptr UserFont): cint {.importc: "nk_init".}
proc clear*(a2: ptr Context) {.importc: "nk_clear".}
proc free*(a2: ptr Context) {.importc: "nk_free".}
when defined(commandUserdata):
  proc set_user_data*(a2: ptr Context; handle: Handle) {.importc: "nk_set_user_data".}
{.pop.}
