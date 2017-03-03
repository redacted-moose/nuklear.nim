# Package

version       = "0.1.0"
author        = "Chris Sadler"
description   = "Nim bindings for nuklear, an ANSI C header-only graphics library"
license       = "Public Domain"

# Dependencies

requires "nim >= 0.15.0"


task sdl_opengl2, "build and run SDL2 (OpenGL 2) example":
  exec "nim c --listFullPaths -r demo/sdl_opengl2/main.nim"

task glfw_opengl2, "build and run GLFW (OpenGL 2) example":
  exec "nim c -r demo/glfw_opengl2/main.nim"
