structure GameUpdate =
struct
  open GameTypes

  (* Record update functions which just change the value of
   * a couple of fields in a record. *)
  local
    fun invertBlockType (blockType: block_type) =
      case blockType of
        LIGHT => DARK
      | DARK => LIGHT
  in
    fun invertBlock (block: block) : block =
      let val {block = oldBlockType, vertexData} = block
      in {block = invertBlockType oldBlockType, vertexData = vertexData}
      end
  end

  fun ballWithXMove (ball: ball, newXMove) : ball =
    let
      val {player, xPos, yPos, xMove = _, yMove} = ball
    in
      { xMove = newXMove
      , player = player
      , xPos = xPos
      , yPos = yPos
      , yMove = yMove
      }
    end

  fun ballWithYMove (ball: ball, newYMove) =
    let
      val {player, xPos, yPos, xMove, yMove = _} = ball
    in
      { yMove = newYMove
      , player = player
      , xPos = xPos
      , yPos = yPos
      , xMove = xMove
      }
    end

  datatype collision_side =
    BALL_ON_LEFT_SIDE
  | BALL_ON_TOP_SIDE
  | BALL_ON_RIGHT_SIDE
  | BALL_ON_BOTTOM_SIDE
  | NO_COLLIDE

  datatype collision_result = RESULT of ball * block | NO_RESULT

  local
    fun help (min, pos, max) = pos > min andalso pos < max
  in
    fun isBetween (min, pos1, pos2, max) =
      help (min, pos1, max) orelse help (min, pos2, max)
  end

  fun areOnDifferentSides (ball, block) =
    case (#player ball, #block block) of
      (DAY, DARK) => true
    | (NIGHT, LIGHT) => true
    | (_, _) => false

  local
    fun getCollisionSide (ball: ball, block: block, colIdx, rowIdx) =
      let
        (* Calculate rectangle area. *)
        val ballStartX = #xPos ball
        val ballEndX = ballStartX + 50
        val ballStartY = #yPos ball
        val ballEndY = ballStartY + 50

        val blockStartX = colIdx * 50
        val blockEndX = blockStartX + 50
        val blockStartY = rowIdx * 50
        val blockEndY = blockStartY * 50

        val isInHorizontalRange =
          isBetween (blockStartX, ballStartX, ballEndX, blockEndX)

        val isInVerticalRange =
          isBetween (blockStartY, ballStartY, ballEndY, blockEndY)
      in
        if ballEndX = blockStartX andalso isInHorizontalRange then
          BALL_ON_LEFT_SIDE
        else if ballStartX = blockEndX andalso isInVerticalRange then
          BALL_ON_RIGHT_SIDE
        else if ballEndY = blockStartY andalso isInHorizontalRange then
          BALL_ON_TOP_SIDE
        else if ballStartY = blockEndY then
          BALL_ON_BOTTOM_SIDE
        else
          NO_COLLIDE
      end


    fun hitLeftSideOfBlock (ball: ball, block: block) =
      let
        val newBlock = invertBlock block
        val newBall = ballWithXMove (ball, ~1)
      in
        RESULT (newBall, newBlock)
      end

    fun hitRightSideOfBLock (ball: ball, block: block) =
      let
        val newBlock = invertBlock block
        val newBall = ballWithXMove (ball, 1)
      in
        RESULT (newBall, newBlock)
      end

    fun hitTopSideOfBlock (ball: ball, block: block) =
      let
        val newBlock = invertBlock block
        val newBall = ballWithYMove (ball, ~1)
      in
        RESULT (newBall, newBlock)
      end

    fun hitBottomSideOfBLock (ball: ball, block: block) =
      let
        val newBlock = invertBlock block
        val newBall = ballWithYMove (ball, 1)
      in
        RESULT (newBall, newBlock)
      end
  in
    fun updateOnCollision (ball: ball, block: block, colIdx, rowIdx) =
      if areOnDifferentSides (ball, block) then
        case getCollisionSide (ball, block, colIdx, rowIdx) of
          BALL_ON_LEFT_SIDE => hitLeftSideOfBlock (ball, block)
        | BALL_ON_TOP_SIDE => hitTopSideOfBlock (ball, block)
        | BALL_ON_RIGHT_SIDE => hitRightSideOfBLock (ball, block)
        | BALL_ON_BOTTOM_SIDE => hitBottomSideOfBLock (ball, block)
        | NO_COLLIDE => NO_RESULT
      else
        NO_RESULT
  end

  fun invertBlocks (blocks: block vector vector) =
    Vector.mapi
      (fn (idx, line) =>
         if idx = 1 then
           Vector.mapi
             (fn (idx, block) => if idx = 7 then invertBlock block else block)
             line
         else
           line) blocks

  fun update (game: game_board) : game_board =
    let
      val
        { dayBall
        , nightBall
        , blocks

        , dr
        , dg
        , db

        , nr
        , ng
        , nb

        , dayVertexBuffer
        , dayVertexShader
        , dayFragmentBuffer
        , dayFragmentShader
        , dayProgram

        , nightVertexBuffer
        , nightVertexShader
        , nightFragmentBuffer
        , nightFragmentShader
        , nightProgram

        , ballVertexBuffer
        , ballVertexShader
        , ballFragmentBuffer
        , ballFragmentShader
        , ballProgram
        } = game

      val blocks = invertBlocks blocks
    in
      { dayBall = dayBall
      , nightBall = nightBall
      , blocks = blocks

      , dr = dr
      , dg = dg
      , db = db

      , nr = nr
      , ng = ng
      , nb = nb

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
