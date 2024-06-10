structure Constants =
struct
  val boxVertexShaderString =
    "layout (location = 0) in vec2 apos;\n\
    \layout (location = 1) in vec3 acol;\n\
    \out vec3 vcolour;\n\
    \void main()\n\
    \{\n\
    \   vcolour = acol;\n\
    \   gl_position = vec4(apos.x, apos.y, 0.0f, 1.0f);\n\
    \}"

  val boxFragmentShaderString =
    "#version 300 es\n\
    \precision mediump float;\n\
    \in vec3 vcolour;\n\
    \out vec4 FragColor;\n\
    \void main()\n\
    \{\n\
    \   FragColor = vec4(vcolour.x, vcolour.y, vcolour.z, 1.0f);\n\
    \}";
end
