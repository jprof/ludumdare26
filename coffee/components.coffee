#
# Enemy Component
# Chases after the player
#
Crafty.c "Enemy",
  init: () ->
    @requires 'Canvas, Color, 2D, Collision, Freezable'
    @speed = .25
    @color 'red'
    @targetX = 900
    @targetY = 900
    return

  # enemies move every frame
  _enterframeActive: () ->
    px = Window.playerEntity.getX()
    py = Window.playerEntity.getY()
    ang = Math.atan2((py-@y),(px-@x))
    
    @targetX += @speed * Math.cos(ang)
    @targetY += @speed * Math.sin(ang)

    @x += (@targetX - @x) * .2
    @y += (@targetY - @y) * .2
    return
  
  #position the enemy --use instead of attr
  position: (x,y) ->
    @targetX = @x = x
    @targetY = @y = y
    return

  easeTo: (x,y) ->
    @targetX = x
    @targetY = y
    return

  getX: () ->
    return @targetX
  
  getY: () ->
     return @targetY

Crafty.c 'GameMaster',
  init: () ->
    @bind "KeyDown", @_keydown
  
   _keydown: (e) ->
    #alert(e.key)
    switch e.key
      # e
      when 69 then @spawnEnemy()
      # o
      when 79 then @spawnObstacle()
      # r
      when 82 then @spawnRat()
      # b
      when 66 then Window.playerEntity.blowAway(1)


  spawnEnemy: () ->
    randX = 800 * Math.random()
    randY = 600 * Math.random()
    @enemySquare = Crafty.e 'Enemy'
    @enemySquare.attr w:20, h:20
    @enemySquare.position randX, randY

  spawnObstacle: () ->
    randX = 800 * Math.random()
    randY = 600 * Math.random()
    randW = 60 * Math.random() + 40
    randH = 60 * Math.random() + 40
    @obstacle = Crafty.e 'Obstacle'
    @obstacle.attr x: randX, y: randY, w:randW, h:randH

  spawnRat: () ->
    randX = 500 * Math.random()
    randY = 600 * Math.random()
    pathLength = 300 * Math.random()
    @rat = Crafty.e 'Rat'
    @rat.attr x: randX, y: randY, w: 20, h: 20
    @rat.setPathLength pathLength



    
#
# Rat Component
# Moves along a horizontal line
# you define a starting point and define its length
# (negative goes to left of starting point, positive to right
# if endX < start, config = 'left' i.e. intially goe from
# right to left

Crafty.c "Rat",
  init: () ->
    @requires 'Canvas, Color, 2D, Collision, Freezable'
    @color 'gray'
    @speed = 1
    @dir = 1
    @config = 'right'
    #how many frames to pause at ends of path
    @MAX_PAUSE = 20
    @pauseCounter = 0 #Fix this
  
  setPathLength: (dist) ->
    @startX = @x
    @endX = @startX + dist
    
    if @endX < @startX
      @dir = -1
      @config = 'left'

    return

  _boundCheck: () ->
    if @config == 'left' and @dir == -1 and @x <= @endX
      return 'left'
    else if @config == 'right' and @dir == -1 and @x <= @startX
      return 'left'
    else if @config == 'left' and @dir == 1 and @x >= @startX
      return 'right'
    else if @config == 'right' and @dir == 1 and @x >= @endX
      return 'right'

    return 'inbetween'

  _resetAndReverse: () ->
    #reverse direction and move a 'step'
    @color 'gray'
    @pauseCounter = 0
    @dir *= -1
    @x += @speed
    return



  _wait: (bound, color) ->
    @color color
    if @pauseCounter < @MAX_PAUSE
      @pauseCounter += 1
    else
      @_resetAndReverse()
    return


  _enterFrameActive: () ->
    b = @_boundCheck()

    switch b
      when 'left'  then @_wait('left','pink')
      when 'right' then @_wait('right','red')
      else @x += @dir * @speed
    return


Crafty.c 'Obstacle',
  init: () ->
    @requires 'Canvas, Color, 2D, Collision'
    @onHit "PlayerCharacter", @_onHit
    @onHit "Enemy", @_onHit
    @color 'yellow'
    return

  _onHit: (targets) ->
    for target in targets
      playerX = target.obj.x
      playerY = target.obj.y
      playerW = target.obj.w
      playerH = target.obj.h

      playerCenterX = playerX + playerW/2
      playerCenterY = playerY + playerH/2
      objCenterX = @x + @w/2
      objCenterY = @y + @h/2

      dx = playerCenterX - objCenterX
      dy = playerCenterY - objCenterY

      if playerCenterY < @h / @w * (playerCenterX - objCenterX) + objCenterY
        if playerCenterY < -@h / @w * (playerCenterX - objCenterX) + objCenterY
          # top
          target.obj.y = @y - playerH
          target.obj.targetY = @y - playerH
        else
          # right
          target.obj.x = @x + @w
          target.obj.targetX = @x + @w
      else
        if playerCenterY < -@h / @w * (playerCenterX - objCenterX) + objCenterY
          # left
          target.obj.x = @x - playerW
          target.obj.targetX = @x - playerW
        else
          # bottom
          target.obj.y = @y + @h
          target.obj.targetY = @y + @h

    return


Crafty.c 'Freezable',
  FreezableStates:
    frozen : 0
    idle : 1
    active : 2

  init: () ->
    @bind "KeyDown", @_keydown
    @bind "EnterFrame", @_enterframe
    @freezableState = @FreezableStates.idle
    return

  _keydown: (e) ->
    switch @freezableState
      when @FreezableStates.idle then @_keydownIdle && @_keydownIdle(e)
      when @FreezableStates.active then @_keydownActive && @_keydownActive(e)

  _enterframe: () ->
    switch @freezableState
      when @FreezableStates.idle then @_enterframeIdle && @_enterframeIdle()
      when @FreezableStates.active then @_enterframeActive && @_enterframeActive()
