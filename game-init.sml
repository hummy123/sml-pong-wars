structure GameInit =
struct
  open GameTypes

  fun posToBoxVertexData (x, y) =
    let
      val x = x - 10
      val x = Real32.fromInt x / 10.0
      val y = y - 10
      val y = ~(Real32.fromInt y / 10.0)
    in
      #[
          x, y, (* tl *)
          x + 0.1, y, (* tr *)
          x, y - 0.1, (* bl *) 

          x, y - 0.1, (* bl *) 
          x + 0.1, y, (* tr *)
          x + 0.1, y - 0.1 (* br *) 
       ]
    end

  fun initBall (player, xPos, yPos, xMove, yMove) : ball =
    {player = player, xPos = xPos, yPos = yPos, xMove = xMove, yMove = yMove}

  fun initBlock (curLine, positionInRow) : block =
    let
      val block = if positionInRow < 10 then LIGHT else DARK
      val vertexData = posToBoxVertexData (positionInRow, curLine)
    in
      {block = block, vertexData = vertexData}
    end

  (* Creates a 10x10 grid of blocks, with initial state. *)
  fun initBlocks () : block vector vector =
    Vector.tabulate (20, fn lineNum =>
      Vector.tabulate (20, fn positionInRow =>
        initBlock (lineNum, positionInRow)))

  fun initBoard () : game_board =
    let
      (* Initialise vertex buffers and shaders. *)
      val dayVertexBuffer = Gles3.createBuffer ()
      val dayVertexShader = Gles3.createShader (Gles3.VERTEX_SHADER ())
      val _ = Gles3.shaderSource
        (dayVertexShader, Constants.boxVertexShaderString)
      val _ = Gles3.compileShader dayVertexShader

      val nightVertexBuffer = Gles3.createBuffer ()
      val nightVertexShader = Gles3.createShader (Gles3.VERTEX_SHADER ())
      val _ = Gles3.shaderSource
        (nightVertexShader, Constants.boxVertexShaderString)
      val _ = Gles3.compileShader nightVertexShader

      val ballVertexBuffer = Gles3.createBuffer ()
      val ballVertexShader = Gles3.createShader (Gles3.VERTEX_SHADER ())
      val _ = Gles3.shaderSource
        (ballVertexShader, Constants.boxVertexShaderString)
      val _ = Gles3.compileShader ballVertexShader

      (* Initialise fragment buffer and shader. *)
      val dayFragmentBuffer = Gles3.createBuffer ()
      val dayFragmentShader = Gles3.createShader (Gles3.FRAGMENT_SHADER ())
      val _ = Gles3.shaderSource
        (dayFragmentShader, Constants.boxFragmentShaderString)
      val _ = Gles3.compileShader dayFragmentShader

      val nightFragmentBuffer = Gles3.createBuffer ()
      val nightFragmentShader = Gles3.createShader (Gles3.FRAGMENT_SHADER ())
      val _ = Gles3.shaderSource
        (nightFragmentShader, Constants.boxFragmentShaderString)
      val _ = Gles3.compileShader nightFragmentShader

      val ballFragmentBuffer = Gles3.createBuffer ()
      val ballFragmentShader = Gles3.createShader (Gles3.FRAGMENT_SHADER ())
      val _ = Gles3.shaderSource
        (ballFragmentShader, Constants.boxFragmentShaderString)
      val _ = Gles3.compileShader ballFragmentShader

      (* Create and compile programs. *)
      val dayProgram = Gles3.createProgram ()
      val _ = Gles3.attachShader (dayProgram, dayVertexShader)
      val _ = Gles3.attachShader (dayProgram, dayFragmentShader)
      val _ = Gles3.linkProgram dayProgram

      val nightProgram = Gles3.createProgram ()
      val _ = Gles3.attachShader (nightProgram, nightVertexShader)
      val _ = Gles3.attachShader (nightProgram, nightFragmentShader)
      val _ = Gles3.linkProgram nightProgram

      val ballProgram = Gles3.createProgram ()
      val _ = Gles3.attachShader (ballProgram, ballVertexShader)
      val _ = Gles3.attachShader (ballProgram, ballFragmentShader)
      val _ = Gles3.linkProgram ballProgram
    in
      { dayBall = initBall (DAY, ~275, 25, 1, 0)
      , nightBall = initBall (NIGHT, 275, 25, 0, 0)
      , blocks = initBlocks ()

      , dr = Constants.initialDr
      , dg = Constants.initialDg
      , db = Constants.initialDb

      , nr = Constants.initialNr
      , ng = Constants.initialNg
      , nb = Constants.initialNb

      (* OpenGL buffers/shaders/programs below. *)
      , dayVertexBuffer = dayVertexBuffer
      , dayVertexShader = dayVertexShader
      , dayFragmentBuffer = dayFragmentBuffer
      , dayFragmentShader = dayFragmentShader
      , dayProgram = dayProgram

      , nightVertexBuffer = nightVertexBuffer
      , nightVertexShader = nightVertexShader
      , nightFragmentBuffer = nightFragmentBuffer
      , nightFragmentShader = nightFragmentShader
      , nightProgram = nightProgram

      , ballVertexBuffer = ballVertexBuffer
      , ballVertexShader = ballVertexShader
      , ballFragmentBuffer = ballFragmentBuffer
      , ballFragmentShader = ballFragmentShader
      , ballProgram = ballProgram
      }
    end
end
