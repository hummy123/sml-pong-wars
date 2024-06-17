structure Constants =
struct
  val boxVertexShaderString =
    "#version 300 es\n\
    \layout (location = 0) in vec2 apos;\n\
    \void main()\n\
    \{\n\
    \   gl_Position = vec4(apos.x, apos.y, 0.0f, 1.0f);\n\
    \}"

  val dayBoxFragmentShaderString =
    "#version 300 es\n\
    \precision mediump float;\n\
    \out vec4 FragColor;\n\
    \void main()\n\
    \{\n\
    \   FragColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);\n\
    \}";

  val nightBoxFragmentShaderString =
    "#version 300 es\n\
    \precision mediump float;\n\
    \out vec4 FragColor;\n\
    \void main()\n\
    \{\n\
    \   FragColor = vec4(0.0f, 0.0f, 0.0f, 0.0f);\n\
    \}";

  val initialDayFragmentData: Real32.real vector =
    #[
        1.0, 
        1.0,
        1.0
     ]

  val initialNightFragmentData: Real32.real vector =
    #[
        17.0 / 255.0, 
        77.0 / 255.0, 
        91.0 / 255.0
     ]
end
