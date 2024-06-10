structure GameInit =
struct
  open GameTypes

  fun posToBoxVertexData (x, y) =
    let
      val x = Real32.fromInt x
      val y = Real32.fromInt y
    in
      #[
         (* first triangle making up square *)
         x / 500.0, y / 500.0,                          (* top left     *)
         (x + 50.0) / 500.0, y / 500.0,                 (* top right    *)
         x / 500.0, (y + 50.0) / 500.0,                 (* bottom left  *)

         (* second triangle *)
         x / 500.0, (y + 50.0) / 500.0,                 (* bottom left  *)
         (x + 50.0) / 500.0, (y + 50.0) / 500.0,        (* bottom right *)
         (x + 50.0) / 500.0, y / 500.0                  (* top right    *)
       ]
    end

  fun initBall (player, xPos, yPos, xMove, yMove, dayData, nightData): ball =
    let
      (* Initialise vertex buffer and shader. *)
      val vertexData = posToBoxVertexData (xPos, yPos)
      val vertexBuffer = Gles3.createBuffer ()
      val _ = Gles3.bindBuffer vertexBuffer
      val _ = Gles3.bufferData (vertexData, Vector.length vertexData, Gles3.DYNAMIC_DRAW())
      val vertexShdaer = Gles3.createShader (Gles3.VERTEX_SHADER ())
      val _ = Gles3.shaderSource (vertexShdaer, Constants.boxVertexShaderString)
      val _ = Gles3.compileShader vertexShdaer
      val _ = Gles3.vertexAttribPointer (0, 2)
      val _ = Gles3.enableVerttexAttribArray 0

      (* Ball in day area has night data, and ball in night area has day data.
       * We only have two colours: if ball was same colour as area, 
       * then ball would be invisible. *)
      let fragmentData = 
        case player of 
          DAY => nightData
        | NIGHT => dayData

      (* Initialise fragment buffer and shader. *)
      val fragmentBuffer = Gles3.createBuffer ()
      val _ = Gles3.bindBuffer fragmentBuffer
      val _ = Gles3.bufferData (fragmentData, Vector.length fragmentData, Gles3.STATIC_DRAW ())
      val fragmentShader = Gles3.createShader (Gles3.FRAGMENT_SHADER ())
      val _ = Gles3.shaderSource (fragmentShader, Constant.boxFragmentShaderString)
      val _ = Gles3.compileShader fragmentShader
      val _ = Gles3.vertexAttribPointer (1, 3)
      val _ = Gles3.enableVerttexAttribArray 1

      (* Create and compile program. *)
      val program = Gles3.createProgram ()
      val _ = Gles3.attachShader (program, vertexShdaer)
      val _ = Gles3.attachShader (program, fragmentShader)
      val _ = Gles3.linkProgram program
    in
      {
        player = player,
        xPos = xPos,
        yPos = yPos,
        xMove = xMove,
        yMove = yMove,
        vertexData = posToBoxVertexData (xPos, yPos),
        vertexBuffer = vertexBuffer,
        vertexShdaer = vertexShdaer,
        fragmentBuffer = fragmentBuffer,
        fragmentShader = fragmentShader,
        program = program
      }
    end
end
