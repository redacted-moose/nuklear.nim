{.pragma: nuklear, cdecl, header: "src/nuklear.h".}

import nuklear_api, nuklear_allocator

when defined(vertexBufferOutput):
  type
    UserFontGlyph* {.importc: "struct nk_user_font_glyph", header: "src/nuklear.h".} = object
      uv* {.importc: "uv".}: array[2, Vec2] ## # texture coordinates
      offset* {.importc: "offset".}: Vec2 ## # offset between top left and glyph
      width* {.importc: "width".}: cfloat
      height* {.importc: "height".}: cfloat ## # size of the glyph
      xadvance* {.importc: "xadvance".}: cfloat ## # offset to the next glyph
else:
  type
    UserFontGlyph* {.importc: "struct nk_user_font_glyph", header: "src/nuklear.h".} = object

type
  TextWidthF* = proc (a2: Handle; h: cfloat; a4: cstring; len: cint): cfloat {.cdecl.}
  QueryFontGlyphF* = proc (handle: Handle; font_height: cfloat;
                           glyph: ptr UserFontGlyph; codepoint: Rune;
                           next_codepoint: Rune) {.cdecl.}

when defined(vertexBufferOutput):
  type
    UserFont* {.importc: "struct nk_user_font", header: "src/nuklear.h".} = object
      userdata* {.importc: "userdata".}: Handle ## # user provided font handle
      height* {.importc: "height".}: cfloat ## # max height of the font
      width* {.importc: "width".}: TextWidthF ## # font string width in pixel callback
      query* {.importc: "query".}: QueryFontGlyphF ## # font glyph callback to query drawing info
      texture* {.importc: "texture".}: Handle ## # texture handle to the used font atlas or texture

else:
  type
    UserFont* {.importc: "struct nk_user_font", header: "src/nuklear.h".} = object
      userdata* {.importc: "userdata".}: Handle ## # user provided font handle
      height* {.importc: "height".}: cfloat ## # max height of the font
      width* {.importc: "width".}: TextWidthF ## # font string width in pixel callback

when defined(fontBaking):
  type
    FontCoordType* {.size: sizeof(cint).} = enum
      COORD_UV,               ## texture coordinates inside font glyphs are clamped between 0-1
      COORD_PIXEL             ## texture coordinates inside font glyphs are in absolute pixel
  type
    BakedFont* {.importc: "struct nk_baked_font", header: "src/nuklear.h".} = object
      height* {.importc: "height".}: cfloat ## height of the font
      ascent* {.importc: "ascent".}: cfloat
      descent* {.importc: "descent".}: cfloat ## font glyphs ascent and descent
      glyph_offset* {.importc: "glyph_offset".}: Rune ## glyph array offset inside the font glyph baking output array
      glyph_count* {.importc: "glyph_count".}: Rune ## number of glyphs of this font inside the glyph baking array output
      ranges* {.importc: "ranges".}: ptr Rune ## font codepoint ranges as pairs of (from/to) and 0 as last element

  type
    FontConfig* {.importc: "struct nk_font_config", header: "src/nuklear.h".} = object
      next* {.importc: "next".}: ptr FontConfig ## NOTE: only used internally
      ttf_blob* {.importc: "ttf_blob".}: pointer ## pointer to loaded TTF file memory block.
                                             ##      NOTE: not needed for nk_font_atlas_add_from_memory and nk_font_atlas_add_from_file.
      ttf_size* {.importc: "ttf_size".}: csize ## size of the loaded TTF file memory block
                                          ##      NOTE: not needed for nk_font_atlas_add_from_memory and nk_font_atlas_add_from_file.
      ttf_data_owned_by_atlas* {.importc: "ttf_data_owned_by_atlas".}: cuchar ## used inside font atlas:
                                                                          ## default to: 0
      merge_mode* {.importc: "merge_mode".}: cuchar ## merges this font into the last font
      pixel_snap* {.importc: "pixel_snap".}: cuchar ## align very character to pixel boundary (if true set oversample (1,1))
      oversample_v* {.importc: "oversample_v".}: cuchar
      oversample_h* {.importc: "oversample_h".}: cuchar ## rasterize at hight quality for sub-pixel position
      padding* {.importc: "padding".}: array[3, cuchar]
      size* {.importc: "size".}: cfloat ## baked pixel height of the font
      coord_type* {.importc: "coord_type".}: FontCoordType ## texture coordinate format with either pixel or UV coordinates
      spacing* {.importc: "spacing".}: Vec2 ## extra pixel spacing between glyphs
      range* {.importc: "range".}: ptr Rune ## list of unicode ranges (2 values per range, zero terminated)
      font* {.importc: "font".}: ptr BakedFont ## font to setup in the baking process: NOTE: not needed for font atlas
      fallback_glyph* {.importc: "fallback_glyph".}: Rune ## fallback glyph to use if a given rune is not found

  type
    FontGlyph* {.importc: "struct nk_font_glyph", header: "src/nuklear.h".} = object
      codepoint* {.importc: "codepoint".}: Rune
      xadvance* {.importc: "xadvance".}: cfloat
      x0* {.importc: "x0".}: cfloat
      y0* {.importc: "y0".}: cfloat
      x1* {.importc: "x1".}: cfloat
      y1* {.importc: "y1".}: cfloat
      w* {.importc: "w".}: cfloat
      h* {.importc: "h".}: cfloat
      u0* {.importc: "u0".}: cfloat
      v0* {.importc: "v0".}: cfloat
      u1* {.importc: "u1".}: cfloat
      v1* {.importc: "v1".}: cfloat

  type
    Font* {.importc: "struct nk_font", header: "src/nuklear.h".} = object
      next* {.importc: "next".}: ptr Font
      handle* {.importc: "handle".}: UserFont
      info* {.importc: "info".}: BakedFont
      scale* {.importc: "scale".}: cfloat
      glyphs* {.importc: "glyphs".}: ptr FontGlyph
      fallback* {.importc: "fallback".}: ptr FontGlyph
      fallback_codepoint* {.importc: "fallback_codepoint".}: Rune
      texture* {.importc: "texture".}: Handle
      config* {.importc: "config".}: ptr FontConfig

  type
    FontAtlasFormat* {.size: sizeof(cint).} = enum
      FONT_ATLAS_ALPHA8, FONT_ATLAS_RGBA32
  type
    FontAtlas* {.importc: "struct nk_font_atlas", header: "src/nuklear.h".} = object
      pixel* {.importc: "pixel".}: pointer
      tex_width* {.importc: "tex_width".}: cint
      tex_height* {.importc: "tex_height".}: cint
      permanent* {.importc: "permanent".}: Allocator
      temporary* {.importc: "temporary".}: Allocator
      custom* {.importc: "custom".}: Recti
      cursors* {.importc: "cursors".}: array[CURSOR_COUNT, Cursor]
      glyph_count* {.importc: "glyph_count".}: cint
      glyphs* {.importc: "glyphs".}: ptr FontGlyph
      default_font* {.importc: "default_font".}: ptr Font
      fonts* {.importc: "fonts".}: ptr Font
      config* {.importc: "config".}: ptr FontConfig
      font_num* {.importc: "font_num".}: cint

  {.push cdecl, header: "src/nuklear.h".}

  proc font_default_glyph_ranges*(): ptr Rune {.importc: "nk_font_default_glyph_ranges".}
  proc font_chinese_glyph_ranges*(): ptr Rune {.importc: "nk_font_chinese_glyph_ranges".}
  proc font_cyrillic_glyph_ranges*(): ptr Rune {.importc: "nk_font_cyrillic_glyph_ranges".}
  proc font_korean_glyph_ranges*(): ptr Rune {.importc: "nk_font_korean_glyph_ranges".}
  when defined(defaultAllocator):
    proc initDefault*(a2: ptr FontAtlas) {.importc: "nk_font_atlas_init_default".}
  proc init*(a2: ptr FontAtlas; a3: ptr Allocator) {.importc: "nk_font_atlas_init".}
  proc initCustom*(a2: ptr FontAtlas; persistent: ptr Allocator;
                              transient: ptr Allocator) {.importc: "nk_font_atlas_init_custom".}
  proc begin*(a2: ptr FontAtlas) {.importc: "nk_font_atlas_begin".}
  proc font_config*(pixel_height: cfloat): FontConfig {.importc: "nk_font_config".}
  proc add*(a2: ptr FontAtlas; a3: ptr FontConfig): ptr Font {.importc: "nk_font_atlas_add".}
  when defined(defaultFont):
    proc addDefault*(a2: ptr FontAtlas; height: cfloat;
                     a4: ptr FontConfig = nil): ptr Font {.importc: "nk_font_atlas_add_default".}
  proc addFromMemory*(atlas: ptr FontAtlas; memory: pointer; size: csize;
                      height: cfloat; config: ptr FontConfig = nil): ptr Font {.importc: "nk_font_atlas_add_from_memory".}
  when defined(standardIO):
    proc addFromFile*(atlas: ptr FontAtlas; file_path: cstring;
                      height: cfloat; a5: ptr FontConfig = nil): ptr Font {.importc: "nk_font_atlas_add_from_file".}
  proc addCompressed*(a2: ptr FontAtlas; memory: pointer; size: csize;
                      height: cfloat; a6: ptr FontConfig = nil): ptr Font {.importc: "nk_font_atlas_add_compressed".}
  proc addCompressedBase85*(a2: ptr FontAtlas; data: cstring;
                            height: cfloat; config: ptr FontConfig = nil): ptr Font {.importc: "nk_font_atlas_add_compressed_base85".}
  proc bake*(a2: ptr FontAtlas; width: ptr cint; height: ptr cint;
             a5: FontAtlasFormat): pointer {.importc: "nk_font_atlas_bake".}
  proc `end`*(a2: ptr FontAtlas; tex: Handle; a4: ptr DrawNullTexture) {.importc: "nk_font_atlas_end".}
  proc clear*(a2: ptr FontAtlas) {.importc: "nk_font_atlas_clear".}
  proc findGlyph*(a2: ptr Font; unicode: Rune): ptr FontGlyph {.importc: "nk_font_find_glyph".}

  {.pop.}
