# Nuklear.nim
A wrapper around vurtun's excellent [nuklear](https://github.com/vurtun/nuklear) library, an immediate mode windowing library.

Embedded version of nuklear: 1.14 (commit cc9d6f3)

# Usage
```nim
import nuklear
```
You may want to add some of the nuklear defines in a `.cfg` file; look in the demo apps `nim.cfg` files to see examples.

# Docs
Look in the `example` and `demo` directory to see some sample apps.  This is a pretty raw wrapper right now; expect changes in the future.

# Installation
This library isn't yet available through the main nimble repos.  However, you can clone this repo and simply `nimble install nuklear` to start playing with it now.

# License
In the spirit of vurtun's original project, this wrapper is licensed as follows:

This software is dual-licensed to the public domain and under the following license: you are granted a perpetual, irrevocable license to copy, modify, publish and distribute this file as you see fit.
