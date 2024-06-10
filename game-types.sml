signature GAME_TYPES =
sig
  datatype player_type = DAY | NIGHT
  datatype block_type = LIGHT | DARK

  type ball =
    { player: player_type
    , xPos: int
    , yPos: int
    , xMove: int
    , yMove: int
    , vertexData: Real32.real vector
    , vertexBuffer: Gles3.buffer
    , vertexShdaer: Gles3.shader
    , fragmentBuffer: Gles3.buffer
    , fragmentShader: Gles3.shader
    , program: Gles3.program
    }

  type block =
    { block: block_type
    , vertexData: Real32.real vector
    , vertexBuffer: Gles3.buffer
    , vertexShdaer: Gles3.shader
    , changedColour: bool
    , fragmentBuffer: Gles3.buffer
    , fragmentShader: Gles3.shader
    , program: Gles3.program
    }

  type game_board =
    { dayBall: ball
    , nightBall: ball
    , blocks: block vector vector
    , dayFragmentData: Real32.real vector
    , nightFragmentData: Real32.real vector
    }
end

structure GameTypes: GAME_TYPES =
struct
  datatype player_type = DAY | NIGHT
  datatype block_type = LIGHT | DARK

  type ball =
    { player: player_type
    , xPos: int
    , (* top left x coordinate *)
      yPos: int
    , (* top right y coordinate *)

      (* How the ball is moving in a particular direction. *)
      xMove: int
    , yMove: int
    ,
      (* OpenGL types/data for ball. 
       * Vertex data (position) is expected to be update many times 
       * and be reused many times.
       * times too. *)
      (** Data that is/should be uploaded to the GPU. *)
      vertexData: Real32.real vector
    , (** References/handles to data on GPU. **)
      vertexBuffer: Gles3.buffer
    , vertexShdaer: Gles3.shader
    ,
      (* fragmentData doesn't need to be defined here: it's always 
       * either the dayFragmentData in the game board or the nightFragmentData
       * in the game board. *)
      fragmentBuffer: Gles3.buffer
    , fragmentShader: Gles3.shader
    ,
      (** Handle to compiled program. *)
      program: Gles3.program
    }

  type block =
    { block: block_type
      (* row and column are implicitly implied
       * by position in block vector vector. 
        row: int,
        column: int, 
      
        Outer vector indicates column number,
        while inner vector indicates row number.
      *)

      (* OpenGL types/data for blocks.
       * Vertex data (size/position) is expected to stay mostly the same, except
       * when resizing if that is supported. *
       * Fragment data (colour) is expected to change only rarely. *)
    , vertexData: Real32.real vector
    , vertexBuffer: Gles3.buffer
    , vertexShdaer: Gles3.shader
    
      (* changedColour bool indicates if the block was inverted;
       * if it was, need to uplodate new fragment data to CPU. *)
    , changedColour: bool
    , fragmentBuffer: Gles3.buffer
    , fragmentShader: Gles3.shader
    , program: Gles3.program
    }

  type game_board =
    { dayBall: ball
    , nightBall: ball
    , (* Vector containing vectors of blocks. *)
      blocks: block vector vector
    , (* Reusable day/night fragment data; no need to reallocate. 
       * This is stored in the game_board object and not as a global immutable
       * variable because we may want allow changing the colour at some point. *)
      dayFragmentData: Real32.real vector
    , nightFragmentData: Real32.real vector
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

     (*
  fun initBlock (block, col, row) =
    { block = block
    , vertexData = posToBoxVertexData (row * 50, col * 50)
    , changeColour = false
    , vertexBuffer = NONE
    , vertexShdaer = NONE
    , program = NONE
    }

  (* Creates a 10x10 grid of blocks, with initial state. *)
  fun initBlocks () =
    Vector.tabulate (10, fn colIdx =>
      Vector.tabulate (10, fn rowIdx =>
        initBlock (if colIdx < 5 then LIGHT else DARK, colIdx, rowIdx)))

  fun initBoard () =
    { dayBall = initBall (DAY, 100, 200, 1, 1)
    , nightBall = initBall (NIGHT, 100, 250, ~1, ~1)
    , blocks = initBlocks ()
    , dayFragmentData = dayFragmentData
    , nightFragmentData = nightFragmentData
    , dayBuffer = NONE
    , nightBuffer = NONE
    , dayShader = NONE
    , nightShader = NONE
    }
    *)
end
