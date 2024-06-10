#include "export.h"
#include "glad.h"
#include <GLFW/glfw3.h>
#include <stdbool.h>

// OpenGL constants used below
unsigned int VERTEX_SHADER = GL_VERTEX_SHADER;
unsigned int FRAGMENT_SHADER = GL_FRAGMENT_SHADER;
unsigned int TRIANGLES = GL_TRIANGLES;
unsigned int STATIC_DRAW = GL_STATIC_DRAW;
unsigned int DYNAMIC_DRAW = GL_DYNAMIC_DRAW;

// OpenGL functions used below
void loadGlad() {
  gladLoadGLLoader((GLADloadproc)glfwGetProcAddress);
}

void viewport(int width, int height) {
  glViewport(0, 0, width, height);
}

void clearColor(float r, float g, float b, float a) {
  glClearColor(r, g, b, a);
}

void clear() {
  glClear(GL_COLOR_BUFFER_BIT);
}

unsigned int createBuffer() {
  unsigned int buffer;
  glGenBuffers(GL_ARRAY_BUFFER, &buffer);
  return buffer;
}

void bindBuffer(unsigned int buffer) {
  glBindBuffer(GL_ARRAY_BUFFER, buffer);
}

void bufferData(float* vector, int vectorLength, unsigned int updateMode) {
  glBufferData(GL_ARRAY_BUFFER, sizeof(float) * vectorLength, vector, updateMode);
}

unsigned int createShader(unsigned int shaderType) {
  return glCreateShader(shaderType);
}

void shaderSource(unsigned int shader, const char *sourceString) {
  glShaderSource(shader, 1, &sourceString, NULL);
}

void compileShader(unsigned int shader) {
  glCompileShader(shader);
}

void deleteShader(unsigned int shader) {
  glDeleteShader(shader);
}

void vertexAttribPointer(int location, int numVecComponents) {
  glVertexAttribPointer(location, numVecComponents, GL_FLOAT, GL_FALSE, numVecComponents * sizeof(float), (void*) 0);
}

void enableVertexAttribArray(int location) {
  glEnableVertexAttribArray(location);
}

unsigned int createProgram() {
  return glCreateProgram();
}

void attachShader(unsigned int program, unsigned int shader) {
  glAttachShader(program, shader);
}

void linkProgram(unsigned int program) {
  glLinkProgram(program);
}

void useProgram(unsigned int program) {
  glUseProgram(program);
}

void deleteProgram(unsigned int program) {
  glDeleteProgram(program);
}

void drawArrays(unsigned int drawMode, int startIndex, int numVertices) {
  glDrawArrays(drawMode, startIndex, numVertices);
}
