structure GameDraw =
struct
  open GameTypes

  type block_build_result =
    {lightBlocks: Real32.real vector list, darkBlocks: Real32.real vector list}

  local
    fun helpBuildBlocks (vec: block vector, pos: int, lightAcc, darkAcc) :
      block_build_result =
      if pos < 0 then
        {lightBlocks = lightAcc, darkBlocks = darkAcc}
      else
        let
          val {block = blockType, vertexData = blockVertex} =
            Vector.sub (vec, pos)

          (* Repeat case branch twice to avoid tuple allocation of 
           * (lightAcc, darkAcc) which I would guess is more expensive.*)
          val lightAcc =
            case blockType of
              LIGHT => blockVertex :: lightAcc
            | DARK => lightAcc

          val darkAcc =
            case blockType of
              DARK => blockVertex :: darkAcc
            | LIGHT => darkAcc
        in
          helpBuildBlocks (vec, pos - 1, lightAcc, darkAcc)
        end
  in
    fun buildBlocks (vec, lightAcc, darkAcc) =
      helpBuildBlocks (vec, Vector.length vec - 1, lightAcc, darkAcc)
  end

  local
    fun helpDrawBlocksLine
      (vec: block vector vector, pos: int, lightAcc, darkAcc) =
      if pos < 0 then
        {lightBlocks = lightAcc, darkBlocks = darkAcc}
      else
        let
          val row = Vector.sub (vec, pos)
          val {lightBlocks = lightAcc, darkBlocks = darkAcc} =
            buildBlocks (row, lightAcc, darkAcc)
        in
          helpDrawBlocksLine (vec, pos - 1, lightAcc, darkAcc)
        end
  in
    fun drawBlocksLine (vec: block vector vector) =
      helpDrawBlocksLine (vec, Vector.length vec - 1, [], [])
  end

  fun drawBlocks (game: game_board) =
    let
      val {lightBlocks, darkBlocks} = drawBlocksLine (#blocks game)

      (* Bind and draw light blocks. *)
      val lightBlocks = Vector.concat lightBlocks
      val dayVertexBuffer = #dayVertexBuffer game
      val _ = Gles3.bindBuffer dayVertexBuffer
      val _ =
        Gles3.bufferData
          (lightBlocks, Vector.length lightBlocks, Gles3.DYNAMIC_DRAW ())
      val _ = Gles3.vertexAttribPointer (0, 2)
      val _ = Gles3.enableVertexAttribArray 0
      val dayProgram = #dayProgram game
      val dayUniformLocation = Gles3.getUniformLocation (dayProgram, "col")
      val _ = Gles3.useProgram dayProgram
      val _ = Gles3.uniform4f
        (dayUniformLocation, #dr game, #dg game, #db game, 1.0)
      val _ = Gles3.drawArrays
        (Gles3.TRIANGLES (), 0, Vector.length lightBlocks div 2)

      val darkBlocks = Vector.concat darkBlocks
      val nightVertexBuffer = #nightVertexBuffer game
      val _ = Gles3.bindBuffer nightVertexBuffer
      val _ =
        Gles3.bufferData
          (darkBlocks, Vector.length lightBlocks, Gles3.DYNAMIC_DRAW ())
      val _ = Gles3.vertexAttribPointer (0, 2)
      val _ = Gles3.enableVertexAttribArray 0
      val nightProgram = #nightProgram game
      val nightUniformLocation = Gles3.getUniformLocation (nightProgram, "col")
      val _ = Gles3.useProgram (#nightProgram game)
      val _ = Gles3.uniform4f
        (nightUniformLocation, #nr game, #ng game, #nb game, 1.0)
      val _ = Gles3.drawArrays
        (Gles3.TRIANGLES (), 0, Vector.length darkBlocks div 2)
    in
      ()
    end

  local
    fun ballToVertexData ({xPos, yPos, ...}: ball) : Real32.real vector =
      let
        val left = Real32.fromInt xPos / 500.0
        val right = left + 0.1
        val top = Real32.fromInt yPos / 500.0
        val bottom = top - 0.1
      in
        #[
          right, bottom, (* bottom right *)
          right, top, (* top right *)
          left, top, (* top left *)
          left, bottom (* bottom left *)
        ]
      end
  in
    fun drawBalls (game: game_board) =
      let
        val
          { dayBall
          , nightBall
          , ballVertexBuffer
          , ballVertexShader
          , ballFragmentBuffer
          , ballFragmentShader
          , ballProgram
          , dr
          , dg
          , db
          , nr
          , ng
          , nb
          , ...
          } = game

        val dayVertexData = ballToVertexData dayBall
        val nightVertexData = ballToVertexData nightBall

        (* Drawing code. *)
        val _ = Gles3.bindBuffer ballVertexBuffer
        val _ =
          Gles3.bufferData
            (dayVertexData, Vector.length dayVertexData, Gles3.DYNAMIC_DRAW ())
        val _ = Gles3.vertexAttribPointer (0, 2)
        val _ = Gles3.enableVertexAttribArray 0
        val ballUniformLocation = Gles3.getUniformLocation (ballProgram, "col")
        val _ = Gles3.useProgram ballProgram
        val _ = Gles3.uniform4f (ballUniformLocation, 0.0, 0.0, 0.0, 1.0)
        val _ = Gles3.drawArrays
          (Gles3.TRIANGLE_FAN (), 0, Vector.length dayVertexData div 2)

        val _ =
          Gles3.bufferData
            ( nightVertexData
            , Vector.length dayVertexData
            , Gles3.DYNAMIC_DRAW ()
            )
        val _ = Gles3.uniform4f (ballUniformLocation, 0.0, 0.0, 0.0, 1.0)
        val _ = Gles3.drawArrays
          (Gles3.TRIANGLE_FAN (), 0, Vector.length nightVertexData div 2)
      in
        ()
      end
  end

  fun draw (game: game_board) =
    (drawBlocks game; drawBalls game)
end
