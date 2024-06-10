mlton -link-opt "$(pkg-config --cflags glfw3) $(pkg-config --static --libs glfw3)" -export-header export.h shell.mlb glad.c glfw-export.c gles3-export.c
