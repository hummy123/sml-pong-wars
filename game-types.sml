signature GAME_TYPES =
sig
  datatype player_type = DAY | NIGHT
  datatype block_type = LIGHT | DARK

  type ball =
    {player: player_type, xPos: int, yPos: int, xMove: int, yMove: int}

  type block = {block: block_type, vertexData: Real32.real vector}

  type game_board =
    { dayBall: ball
    , nightBall: ball
    (* Vector containing vectors of blocks. *)
    , blocks: block vector vector

    (* RGB values for day side. *)
    , dr: Real32.real
    , dg: Real32.real
    , db: Real32.real

    (* RGB values for night side. *)
    , nr: Real32.real
    , ng: Real32.real
    , nb: Real32.real

    , dayVertexBuffer: Gles3.buffer
    , dayVertexShader: Gles3.shader
    , dayFragmentBuffer: Gles3.buffer
    , dayFragmentShader: Gles3.shader
    , dayProgram: Gles3.program

    , nightVertexBuffer: Gles3.buffer
    , nightVertexShader: Gles3.shader
    , nightFragmentBuffer: Gles3.buffer
    , nightFragmentShader: Gles3.shader
    , nightProgram: Gles3.program

    , ballVertexBuffer: Gles3.buffer
    , ballVertexShader: Gles3.shader
    , ballFragmentBuffer: Gles3.buffer
    , ballFragmentShader: Gles3.shader
    , ballProgram: Gles3.program
    }
end

structure GameTypes: GAME_TYPES =
struct
  datatype player_type = DAY | NIGHT
  datatype block_type = LIGHT | DARK

  type ball =
    { player: player_type
    (* top left x coordinate *)
    , xPos: int
    (* top left y coordinate *)
    , yPos: int

    (* How the ball is moving in a particular direction. *)
    , xMove: int
    , yMove: int
    }

  type block =
    { block: block_type
    (* block's position is implicitly implied
     * by position in block vector vector. 
    
      Outer vector indicates line/row number,
      while inner vector indicates position of block in individual line/row.
    *)

    (* Vertex data (size/position) is expected to stay mostly the same, except
     * when resizing if that is supported. *)
    , vertexData: Real32.real vector
    }

  type game_board =
    { dayBall: ball
    , nightBall: ball
    (* Vector containing vectors of blocks. *)
    , blocks: block vector vector

    , dr: Real32.real
    , dg: Real32.real
    , db: Real32.real

    , nr: Real32.real
    , ng: Real32.real
    , nb: Real32.real

    , dayVertexBuffer: Gles3.buffer
    , dayVertexShader: Gles3.shader
    , dayFragmentBuffer: Gles3.buffer
    , dayFragmentShader: Gles3.shader
    , dayProgram: Gles3.program

    , nightVertexBuffer: Gles3.buffer
    , nightVertexShader: Gles3.shader
    , nightFragmentBuffer: Gles3.buffer
    , nightFragmentShader: Gles3.shader
    , nightProgram: Gles3.program

    , ballVertexBuffer: Gles3.buffer
    , ballVertexShader: Gles3.shader
    , ballFragmentBuffer: Gles3.buffer
    , ballFragmentShader: Gles3.shader
    , ballProgram: Gles3.program
    }
end
