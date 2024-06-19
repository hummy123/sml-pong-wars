# sml-pong-wars

## What is this?

This is a Standard ML implementation of the Pong Wars animation that became somewhat popular this year, in 2024.

It uses GLFW and OpenGL 3/3.0 ES, although it may work with older versions too.

This is the first program I made on my journey of learning OpenGL as I decided it would be a small and fun project.

## Running

### Prerequisites

The following must be installed in order to build:
- The MLton compiler for Standard ML
- The pkg-config utility to find system libraries
- The GLFW library for window management

### Building

**Unix (BSD, Linux)**

Clone the repository and run `./build-unix.sh`. 

A file called `shell` will be generated and you can enter `./shell` to run the program.

**OSX**

Clone the repository and run `./build-osx.sh`.

Afterwards, run `./shell` to run the generated `shell` file.

Note: Untested (don't have a Mac I can run on) but I assume the `build-osx.sh` file works.

**Windows**

I don't have a Windows computer with me, but MLton (either via Cygwin or MinGW) and GLFW both run on Windows. There should be a way to run this program on Windows too.

Since I don't know and can't test, I would suggest anyone interested uses the Windows Subsystem for Linux and follows the instructions there.

## Portability across SML compiters

There are some reasons a minimal amount of code will need to be written in order to run using a different Standard ML compiler.

**FFI**

First, there are FFI bindings to a very small subset of GLFW (in `glfw-import.sml`) and OpenGL 3 (in `gles3-import.sml`). 

As there's no standardised FFI across Standard ML compilers, that will need to be rewritten.

**Syntax extensions**

Secondly, `game-init.sml` and `game-draw.sml` both use a syntax extension supported at least by MLton and SML/NJ.

That syntax extension is for vector (immutable array) literals, which can be written using `#[my, vector, elements]`.

There are only two uses of this syntax extension across the whole project. 

These uses can be rewritten using the `Vector.fromList` function (`Vector.fromList [my, vector, elements]`) but I didn't see a reason to avoid it.

**MLton-exclusive types**

There is a third reason that limits the portability of the code here, which is the use of the `Real32.real` type (the 32-bit `float` type in C). 

This just specifies the number of bits used by the type. OpenGL typically uses 32-bit floats, but MLton's `real` type defaults to 64-bit (the `double` type in C). 

The exact C type represented by a `real` might vary by the Standard ML compiler used, but I wasn't planning on using a different compiler anyway.
