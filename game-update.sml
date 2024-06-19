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
    fun help (min, pos, max) = pos >= min andalso pos <= max
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
    fun getCollisionSide (ball: ball, block: block, lineNum, rowIdx) =
      let
        (* Calculate rectangle area. *)
        val ballStartX = #xPos ball
        val ballEndX = ballStartX + 50
        val ballStartY = #yPos ball
        val ballEndY = ballStartY + 50

        val blockStartX = (rowIdx - 10) * 50
        val blockEndX = blockStartX + 50
        val blockStartY = (~(lineNum - 10)) * 50
        val blockEndY = blockStartY + 50

        val isInHorizontalRange =
          isBetween (blockStartX, ballStartX, ballEndX, blockEndX)

        val isInVerticalRange =
          isBetween (blockStartY, ballStartY, ballEndY, blockEndY)
      in
        if ballEndX = blockStartX andalso isInVerticalRange then
          BALL_ON_LEFT_SIDE
        else if ballStartX = blockEndX andalso isInVerticalRange then
          BALL_ON_RIGHT_SIDE
        else if ballEndY = blockStartY andalso isInHorizontalRange then
          BALL_ON_TOP_SIDE
        else if ballStartY = blockEndY andalso isInHorizontalRange then
          BALL_ON_BOTTOM_SIDE
        else
          NO_COLLIDE
      end

    fun hitLeftSideOfBlock (ball: ball, block: block) =
      let
        val newBlock = invertBlock block
        val newBall = ballWithXMove (ball, ~5)
      in
        RESULT (newBall, newBlock)
      end

    fun hitRightSideOfBLock (ball: ball, block: block) =
      let
        val newBlock = invertBlock block
        val newBall = ballWithXMove (ball, 5)
      in
        RESULT (newBall, newBlock)
      end

    fun hitTopSideOfBlock (ball: ball, block: block) =
      let
        val newBlock = invertBlock block
        val newBall = ballWithYMove (ball, 5)
      in
        RESULT (newBall, newBlock)
      end

    fun hitBottomSideOfBLock (ball: ball, block: block) =
      let
        val newBlock = invertBlock block
        val newBall = ballWithYMove (ball, ~5)
      in
        RESULT (newBall, newBlock)
      end
  in
    fun updateOnCollision (ball: ball, block: block, lineNum, rowIdx) =
      if areOnDifferentSides (ball, block) then
        case getCollisionSide (ball, block, lineNum, rowIdx) of
          BALL_ON_LEFT_SIDE => hitLeftSideOfBlock (ball, block)
        | BALL_ON_TOP_SIDE => hitTopSideOfBlock (ball, block)
        | BALL_ON_RIGHT_SIDE => hitRightSideOfBLock (ball, block)
        | BALL_ON_BOTTOM_SIDE => hitBottomSideOfBLock (ball, block)
        | NO_COLLIDE => NO_RESULT
      else
        NO_RESULT
  end

  local
    fun helpFoldBlockRow
      (pos, row, lineNum, dayBall, nightBall, newBlocks: block list) =
      if pos < 0 then
        (dayBall, nightBall, Vector.fromList newBlocks)
      else
        let
          val block = Vector.sub (row, pos)

          val dayBlockCollisionResult =
            updateOnCollision (dayBall, block, lineNum, pos)
          val (block, dayBall) =
            case dayBlockCollisionResult of
              NO_RESULT => (block, dayBall)
            | RESULT (dayBall, block) => (block, dayBall)

          val nightBlockCollisionResult =
            updateOnCollision (nightBall, block, lineNum, pos)
          val (block, nightBall) =
            (case nightBlockCollisionResult of
               NO_RESULT => (block, nightBall)
             | RESULT (nightBall, block) => (block, nightBall))

          val newBlocks = block :: newBlocks
        in
          helpFoldBlockRow
            (pos - 1, row, lineNum, dayBall, nightBall, newBlocks)
        end

    fun helpFoldBlockLines
      (pos, blocks, dayBall, nightBall, newBlocks: block vector list) :
      ball * ball * block vector vector =
      if pos < 0 then
        (dayBall, nightBall, Vector.fromList newBlocks)
      else
        let
          val row = Vector.sub (blocks, pos)

          val (dayBall, nightBall, lineBlocks) = helpFoldBlockRow
            (Vector.length row - 1, row, pos, dayBall, nightBall, [])

          val newBlocks = lineBlocks :: newBlocks
        in
          helpFoldBlockLines (pos - 1, blocks, dayBall, nightBall, newBlocks)
        end
  in
    fun updateBlocks (blocks: block vector vector, dayBall, nightBall) =
      helpFoldBlockLines
        (Vector.length blocks - 1, blocks, dayBall, nightBall, [])
  end

  fun checkLeftWallCollision (ball: ball) =
    if #xPos ball = ~500 then ballWithXMove (ball, 5) else ball

  fun checkTopWallCollision (ball: ball) =
    if #yPos ball = 500 then ballWithYMove (ball, ~5) else ball

  fun checkRightWallCollision (ball: ball) =
    if #xPos ball + 50 = 500 then ballWithXMove (ball, ~5) else ball

  fun checkBottomWallCollision (ball: ball) =
    if #yPos ball - 50 = ~500 then ballWithYMove (ball, 5) else ball

  fun checkWallCollisions (ball: ball) =
    let
      val ball = checkLeftWallCollision ball
      val ball = checkRightWallCollision ball
      val ball = checkTopWallCollision ball
    in
      checkBottomWallCollision ball
    end

  fun updateBall (ball: ball) : ball =
    let
      val {player, xPos, yPos, xMove, yMove} = ball
      val xPos = xPos + xMove
      val yPos = yPos + yMove
    in
      {player = player, xPos = xPos, yPos = yPos, xMove = xMove, yMove = yMove}
    end

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

      val dayBall = updateBall dayBall
      val nightBall = updateBall nightBall
      val (dayBall, nightBall, blocks) =
        updateBlocks (blocks, dayBall, nightBall)

      val dayBall = checkWallCollisions dayBall
      val nightBall = checkWallCollisions nightBall
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
