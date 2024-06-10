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
     * Fragment data (colour) is expected to be created/updated once and used
     * many times.
     * Vertex data (position) is expected to be update many times and used many
     * times too. *)
    (** References/handles to data on GPU. **)
    vertexBuffer: Gles3.buffer option,
    vertexShdaer: Gles3.shader option,
    fragmentBuffer: Gles3.buffer option,
    fragmentShader: Gles3.shader option,
    (** Data that is/should be uploaded to the GPU. *)
    vertexData: Real32.real vecctor, 
    fragmentData: Real32.real vecctor,
    (** Compiled program data. *)
    program: Gles3.program option
  }

  type block = {
    block: block_type,

    (* row and column are implicitly implied
     * by position in block vector vector. 
      row: int,
      column: int, 
    *)

    (* OpenGL types/data for blocks.
     * Vertex data (size/position) is expected to stay mostly the same, except
     * when resizing.
     * Fragment data (colour) is expected to change though, when other side's
     * ball hits this ball. *)
     vertexBuffer: Gles3.buffer option,
     vertexShdaer: Gles3.shader option,
     fragmentBuffer: Gles3.buffer option,
     fragmentShader: Gles3.buffer option,

     vertexData: Real32.real vector,
     fragmentData: Real32.real vector

     program: Gles3.program option
  }

  type game_board = {
    dayBall: ball,
    nightBall: ball,
    (* Vector containing vectors of blocks. *)
    blocks: block vector vector
  }

  fun posToBoxVertexData (x, y) =
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

  val dayFragmentData = #[]

  fun initBall (player, xPos, yPos, xMove, yMove): ball =
    {
      player = player,
      xPos = xPos,
      yPos = yPos,
      xMove = xMove,
      yMove = yMove,
      vertexData = posToBoxVertexData(xPos, yPos)
    }
end
