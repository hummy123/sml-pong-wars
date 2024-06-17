structure GameInit =
struct
  open GameTypes

  fun posToBoxVertexData (x, y) =
    let
      val x = x - 5
      val x = Real32.fromInt x / 5.0
      val y = y - 5
      val y = ~(Real32.fromInt y / 5.0)
    in
      #[
          x, y, (* tl *)
          x + 0.2, y, (* tr *)
          x, y - 0.2, (* bl *) 

          x, y - 0.2, (* bl *) 
          x + 0.2, y, (* tr *)
          x + 0.2, y - 0.2 (* br *) 
       ]
    end

  fun initBall (player, xPos, yPos, xMove, yMove, dayData, nightData) : ball =
    let
      (* Initialise vertex buffer and shader. *)
      val vertexData = posToBoxVertexData (xPos, yPos)
      val vertexBuffer = Gles3.createBuffer ()
      val _ = Gles3.bindBuffer vertexBuffer
      val _ =
        Gles3.bufferData
          (vertexData, Vector.length vertexData, Gles3.DYNAMIC_DRAW ())
      val vertexShdaer = Gles3.createShader (Gles3.VERTEX_SHADER ())
      val _ = Gles3.shaderSource (vertexShdaer, Constants.boxVertexShaderString)
      val _ = Gles3.compileShader vertexShdaer
      val _ = Gles3.vertexAttribPointer (0, 2)
      val _ = Gles3.enableVertexAttribArray 0

      (* Ball in day area has night data, and ball in night area has day data.
       * We only have two colours: if ball was same colour as area, 
       * then ball would be invisible. *)
      val fragmentData =
        case player of
          DAY => nightData
        | NIGHT => dayData

      val shaderString =
        case player of
          DAY => Constants.nightBoxFragmentShaderString
        | NIGHT => Constants.dayBoxFragmentShaderString

      (* Initialise fragment buffer and shader. *)
      val fragmentBuffer = Gles3.createBuffer ()
      val _ = Gles3.bindBuffer fragmentBuffer
      val _ =
        Gles3.bufferData
          (fragmentData, Vector.length fragmentData, Gles3.STATIC_DRAW ())
      val fragmentShader = Gles3.createShader (Gles3.FRAGMENT_SHADER ())
      val _ = Gles3.shaderSource (fragmentShader, shaderString)
      val _ = Gles3.compileShader fragmentShader
      val _ = Gles3.vertexAttribPointer (1, 3)
      val _ = Gles3.enableVertexAttribArray 1

      (* Create and compile program. *)
      val program = Gles3.createProgram ()
      val _ = Gles3.attachShader (program, vertexShdaer)
      val _ = Gles3.attachShader (program, fragmentShader)
      val _ = Gles3.linkProgram program
    in
      { player = player
      , xPos = xPos
      , yPos = yPos
      , xMove = xMove
      , yMove = yMove
      , vertexData = vertexData
      , vertexBuffer = vertexBuffer
      , vertexShdaer = vertexShdaer
      , fragmentBuffer = fragmentBuffer
      , fragmentShader = fragmentShader
      , program = program
      }
    end

  fun initBlock (curLine, positionInRow, dayData, nightData) : block =
    let
      val block = if positionInRow < 5 then LIGHT else DARK
      val vertexData = posToBoxVertexData (positionInRow, curLine)
    in
      {block = block, vertexData = vertexData}
    end

  (* Creates a 10x10 grid of blocks, with initial state. *)
  fun initBlocks (dayData, nightData) =
    Vector.tabulate (10, fn lineNum =>
      Vector.tabulate (10, fn positionInRow =>
        initBlock (lineNum, positionInRow, dayData, nightData)))

  fun initBoard () =
    let
      (* Initialise vertex buffers and shaders. *)
      val dayVertexBuffer = Gles3.createBuffer ()
      val dayVertexShdaer = Gles3.createShader (Gles3.VERTEX_SHADER ())
      val _ = Gles3.shaderSource (dayVertexShdaer, Constants.boxVertexShaderString)
      val _ = Gles3.compileShader dayVertexShdaer

      val nightVertexBuffer = Gles3.createBuffer ()
      val nightVertexShdaer = Gles3.createShader (Gles3.VERTEX_SHADER ())
      val _ = Gles3.shaderSource (nightVertexShdaer, Constants.boxVertexShaderString)
      val _ = Gles3.compileShader nightVertexShdaer

      (* Initialise fragment buffer and shader. *)
      val dayFragmentBuffer = Gles3.createBuffer ()
      val dayFragmentShader = Gles3.createShader (Gles3.FRAGMENT_SHADER ())
      val _ = Gles3.shaderSource
        (dayFragmentShader, Constants.dayBoxFragmentShaderString)
      val _ = Gles3.compileShader dayFragmentShader

      val nightFragmentBuffer = Gles3.createBuffer ()
      val nightFragmentShader = Gles3.createShader (Gles3.FRAGMENT_SHADER ())
      val _ = Gles3.shaderSource
        (nightFragmentShader, Constants.nightBoxFragmentShaderString)
      val _ = Gles3.compileShader nightFragmentShader

      (* Create and compile programs. *)
      val dayProgram = Gles3.createProgram ()
      val _ = Gles3.attachShader (dayProgram, dayVertexShdaer)
      val _ = Gles3.attachShader (dayProgram, dayFragmentShader)
      val _ = Gles3.linkProgram dayProgram

      val nightProgram = Gles3.createProgram ()
      val _ = Gles3.attachShader (nightProgram, nightVertexShdaer)
      val _ = Gles3.attachShader (nightProgram, nightFragmentShader)
      val _ = Gles3.linkProgram nightProgram
    in
      { dayBall = initBall
          ( DAY
          , 100
          , 200
          , 1
          , 1
          , Constants.initialDayFragmentData
          , Constants.initialNightFragmentData
          )
      , nightBall = initBall
          ( NIGHT
          , 100
          , 250
          , ~1
          , ~1
          , Constants.initialDayFragmentData
          , Constants.initialNightFragmentData
          )
      , blocks = initBlocks
          (Constants.initialDayFragmentData, Constants.initialNightFragmentData)
      , dayFragmentData = Constants.initialDayFragmentData
      , nightFragmentData = Constants.initialNightFragmentData

      (* OpenGL buffers/shaders/programs below. *)
      , dayVertexBuffer = dayVertexBuffer
      , dayVertexShdaer = dayVertexShdaer
      , dayFragmentBuffer = dayFragmentBuffer
      , dayFragmentShader = dayFragmentShader
      , dayProgram = dayProgram

      , nightVertexBuffer = nightVertexBuffer
      , nightVertexShdaer = nightVertexShdaer
      , nightFragmentBuffer = nightFragmentBuffer
      , nightFragmentShader = nightFragmentShader
      , nightProgram = nightProgram
      }
    end
end
