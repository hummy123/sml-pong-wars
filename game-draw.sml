structure GameDraw =
struct
  open GameTypes

  fun drawBlock (block: block) =
    let
      val vertexBuffer = #vertexBuffer block
      val _ = Gles3.bindBuffer vertexBuffer
      val _ = Gles3.vertexAttribPointer (0, 2)
      val _ = Gles3.enableVertexAttribArray 0

      val fragmentBuffer = #fragmentBuffer block
      val _ = Gles3.bindBuffer fragmentBuffer
      val _ = Gles3.vertexAttribPointer (1, 3)
      val _ = Gles3.enableVertexAttribArray 1

      val program = #program block
      val _ = Gles3.useProgram program
      val _ = Gles3.drawArrays (Gles3.TRIANGLES(), 0, 6)
    in
      ()
    end

  local
    fun helpDrawBlocksRow (vec: block vector, pos: int) =
      if pos < 0 then
        ()
      else
        let
          val block = Vector.sub (vec, pos)
          val _ = drawBlock block
        in
          helpDrawBlocksRow (vec, pos - 1)
        end
  in
    fun drawBlocksRow vec =
      helpDrawBlocksRow (vec, Vector.length vec - 1)
  end

  local
    fun helpDrawBlocksColumn (vec: block vector vector, pos: int) =
      if pos < 0 then
        ()
      else
        let
          val row = Vector.sub (vec, pos)
          val _ = drawBlocksRow row
        in
          helpDrawBlocksColumn (vec, pos - 1)
        end
  in
    fun drawBlocksColumn (vec: block vector vector) =
      helpDrawBlocksColumn (vec, Vector.length vec - 1)
  end


  fun draw (game: game_board) =
    drawBlocksColumn (#blocks game)
end
