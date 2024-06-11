structure GameDraw =
struct
  open GameTypes

  fun drawBlock (block: block) =
    let
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
