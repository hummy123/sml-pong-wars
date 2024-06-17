structure Constants =
struct
  val boxVertexShaderString =
    "#version 300 es\n\
    \layout (location = 0) in vec2 apos;\n\
    \void main()\n\
    \{\n\
    \   gl_Position = vec4(apos.x, apos.y, 0.0f, 1.0f);\n\
    \}"

  val boxFragmentShaderString =
    "#version 300 es\n\
    \precision mediump float;\n\
    \out vec4 FragColor;\n\
    \uniform vec4 col;\n\
    \void main()\n\
    \{\n\
    \   FragColor = col;\n\
    \}";

  val initialDr: Real32.real = 217.0 / 255.0
  val initialDg: Real32.real = 233.0 / 255.0
  val initialDb: Real32.real = 227.0 / 255.0

  val initialNr: Real32.real = 17.0 / 255.0
  val initialNg: Real32.real = 77.0 / 255.0
  val initialNb: Real32.real = 91.0 / 255.0
end
