#include "export.h"
#include "glad.h"
#include <GLFW/glfw3.h>
#include <stdbool.h>

// GLFW constants used below
int CONTEXT_VERSION_MAJOR = GLFW_CONTEXT_VERSION_MAJOR;
int DEPRECATED = GLFW_DECORATED;
int GLFW_FFI_FALSE = GLFW_FALSE;
int SAMPLES = GLFW_SAMPLES;

// GLFW functions used below
void init() {
  glfwInit();
}

void windowHint(int hint, int value) {
  glfwWindowHint(hint, value);
}

GLFWwindow* createWindow(int width, int height, const char *title) {
  return glfwCreateWindow(width, height, title, NULL, NULL);
}

void terminate() {
  glfwTerminate();
}

void makeContextCurrent(GLFWwindow* window) {
  glfwMakeContextCurrent(window);
}

bool windowShouldClose(GLFWwindow *window) {
  glfwWindowShouldClose(window);
}

void pollEvents() {
  glfwPollEvents();
}

void swapBuffers(GLFWwindow *window) {
  glfwSwapBuffers(window);
}

