structure GameTypes =
struct
  datatype player_type = DAY | NIGHT
  datatype block_type = LIGHT | DARK

  type ball = {
    player: player_type,
    xPos: int, (* top left x coordinate *)
    yPos: int, (* top right y coordinate *)

    (* How the ball is moving in a particular direction. *)
    xMove: int,
    yMove: int,

    (* OpenGL types/data for ball. 
     * Vertex data (position) is expected to be update many times and used many
     * times too. *)
    (** Data that is/should be uploaded to the GPU. *)
    vertexData: Real32.real vector, 
    (** References/handles to data on GPU. **)
    vertexBuffer: Gles3.buffer option,
    vertexShdaer: Gles3.shader option,
    (** Handle to compiled program. *)
    program: Gles3.program option
  }

  type block = {
    block: block_type,

    (* row and column are implicitly implied
     * by position in block vector vector. 
      row: int,
      column: int, 

      Outer vector indicates column number,
      while inner vector indicates row number.
    *)

    (* OpenGL types/data for blocks.
     * Vertex data (size/position) is expected to stay mostly the same, except
     * when resizing if that is supported. *)
     vertexData: Real32.real vector,
     vertexBuffer: Gles3.buffer option,
     vertexShdaer: Gles3.shader option,
     program: Gles3.program option
  }

  type game_board = {
    dayBall: ball,
    nightBall: ball,
    (* Vector containing vectors of blocks. *)
    blocks: block vector vector,

    (* OpenGL fragment/colour data, 
     * which can be shared by all blocks `and balls on one side. 
     *
     * Fragment data (colour) is expected to be created/updated once,
     * and used many times so should use GL_STATIC_DRAW. *)
    (** vbo **)
    dayBuffer: Gles3.buffer option,
    nightBuffer: Gles3.buffer option,
    (** fbo **)
    dayShader: Gles3.shader option,
    nightShader: Gles3.shader option,

    dayFragmentData: Real32.real vector,
    nightFragmentData: Real32.real vector
  }

  val dayFragmentData: Real32.real vector = 
    #[
       217.0 / 255.0,
       233.0 / 255.0,
       227.0 / 255.0
     ]

  val nightFragmentData: Real32.real vector =
    #[
       17.0 / 255.0,
       77.0 / 255.0,
       91.0 / 255.0
     ]

  fun posToBoxVertexData (x, y) =
  let
    val x = Real32.fromInt x
    val y = Real32.fromInt y
  in
    #[
      (* first triangle making up square *)
      x, y, (* top left *)
      x + 50.0, y, (* top right *)
      x, y + 50.0, (* bottom left *)

      (* second triangle *)
      x, y + 50.0, (* bottom left *)
      x + 5.0, y + 50.0, (* bottom right *)
      x + 50.0, y (* top right *)
     ]
  end


  fun initBall (player, xPos, yPos, xMove, yMove): ball =
    {
      player = player,
      xPos = xPos,
      yPos = yPos,
      xMove = xMove,
      yMove = yMove,
      vertexData = posToBoxVertexData(xPos, yPos),
      vertexBuffer = NONE,
      vertexShdaer = NONE,
      program = NONE
    }

  fun initBlock (block, col, row) = 
    {
      block = block,
      vertexData = posToBoxVertexData(row * 50, col * 50),
      vertexBuffer = NONE,
      vertexShdaer = NONE,
      program = NONE
    }

  fun initBlocks() =
    Vector.tabulate (10, 
      fn colIdx =>
        Vector.tabulate (10,
          fn rowIdx =>
            initBlock (
              if colIdx < 5 
              then LIGHT
              else DARK,
              colIdx, 
              rowIdx
            )
        )
    )

  fun initBoard () =
    {
      dayBall = initBall (DAY, 100, 200, 1, 1),
      nightBall = initBall (NIGHT, 100, 250, ~1, ~1),
      blocks = initBlocks(),

      dayFragmentData = dayFragmentData,
      nightFragmentData = nightFragmentData,
      dayBuffer = NONE,
      nightBuffer = NONE,
      dayShader = NONE,
      nightShader = NONE
    }
end
