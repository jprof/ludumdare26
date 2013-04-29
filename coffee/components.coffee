#
# Enemy Component
# Chases after the player
#
Crafty.c "Enemy",
  init: () ->
    @requires 'Canvas, Color, 2D, Collision, ChasePlayer'
    @h = 20
    @w = 20

# Behavior to chase after the player
# You must set x,y,targetX,targetY for the entity 
# in order for this to work
Crafty.c 'ChasePlayer',
  init: () ->
    @requires '2D'
    @bind 'EnterFrameActive', @_enterframeActive
    @speed = .25
    @color 'red'
    return

  # enemies move every frame
  _enterframeActive: () ->
    px = Window.playerEntity.x + Window.playerEntity.w/2
    py = Window.playerEntity.y + Window.playerEntity.h/2

    ex = @x + @w/2
    ey = @y + @h/2

    ang = Math.atan2((py-ey),(px-ex))
    
    @targetX += @speed * Math.cos(ang)
    @targetY += @speed * Math.sin(ang)

    @x += (@targetX - @x) * .2
    @y += (@targetY - @y) * .2
    return
  

Crafty.c 'GameMaster',
  init: () ->
    @bind "KeyDown", @_keydown
  
   _keydown: (e) ->
    #alert(e.key)
    switch e.key
      # e
      when 69 then @spawnEnemy()
      # o
      when 79 then @spawnHighrise()
      # r
      when 82 then @spawnRat()
      # b
      when 66 then Window.playerEntity.blowAway(1)


  spawnEnemy: () ->
    randX = 800 * Math.random()
    randY = 600 * Math.random()
    @enemySquare = Crafty.e 'Enemy'
    @enemySquare.attr x:randX, y:randY, targetX: randX, targetY: randY, w:20, h:20

  spawnHighrise: () ->
    randX = 800 * Math.random()
    randY = 600 * Math.random()
    randW = 60 * Math.random() + 40
    randH = 60 * Math.random() + 40
    @obstacle = Crafty.e 'Highrise'
    @obstacle.attr x: randX, y: randY

  spawnRat: () ->
    randLeft = 750 * Math.random()
    randRight = Crafty.math.randomNumber randLeft, 795

    randY = 600 * Math.random()
    randStartX = Crafty.math.randomNumber randLeft + 1, randRight - 1

    @rat = Crafty.e 'Rat'
    @rat.attr x: randStartX, y: randY, left: randLeft, right: randRight
    if randStartX < randRight
      @rat.patrolState =  @rat.HorizontalPatrolStates.patrolRight
    else 
      @rat.patrolState = @rat.HorizontalPatrolStates.patrolLeft
    
  
#
# Rat Component
Crafty.c "Rat",
  init: () ->
    @requires 'Canvas, Color, Collision, HorizontalPatrol, rat, SpriteAnimation'
    @w = 100
    @h = 60
    @color 'none'
    @bind 'EnterFrameActive', @_ratEnterFrameActive

  _hitObstacle: ->
    @_reversePatrol()


  _ratEnterFrameActive: () ->
    if @prevPatrolState != @patrolState
      @stop()
      switch @patrolState
        when @HorizontalPatrolStates.idleLeft
          @animate 'idleLeft', 0, 3, 1
          @animate 'idleLeft', 25, 0
        when @HorizontalPatrolStates.idleRight
          @animate 'idleRight', 0, 2, 1
          @animate 'idleRight', 25, 0
        when @HorizontalPatrolStates.patrolLeft
          @animate 'walkLeft', 0, 1, 3
          @animate 'walkLeft', 25, -1
        when @HorizontalPatrolStates.patrolRight
          @animate 'walkRight', 0, 0, 3
          @animate 'walkRight', 25, -1
    @prevPatrolState = @patrolState

Crafty.c 'Obstacle',
  init: () ->
    @requires 'Canvas, Color, 2D, Collision'
    @onHit "PlayerCharacter", @_onHit
    @onHit "Rat", @_onHitRat
    @onHit "Enemy", @_onHit
    return

  _onHitRat: (rats) ->
    for rat in rats
      rat.obj._hitObstacle()
    @_onHit rats

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

Crafty.c 'Highrise',
  init: () ->
    @requires 'Obstacle, Sprite, highrise'
    @w = @h = 100
    @color 'none'

Crafty.c 'Prize',
  init: () ->
    @requires "Canvas, 2D, Color, Collision"
    return

Crafty.c 'Freezable',
  FreezableStates:
    frozen : 0
    idle : 1
    active : 2

  init: () ->
    @bind "KeyDown", @_keydown
    @bind "EnterFrame", @_enterframe
    @freezableState = @FreezableStates.frozen
    return

  _keydown: (e) ->
    switch @freezableState
      when @FreezableStates.idle then Crafty.trigger 'KeydownIdle', e
      when @FreezableStates.active then Crafty.trigger 'KeydownActive', e

  _enterframe: () ->
    switch @freezableState
      when @FreezableStates.idle then Crafty.trigger 'EnterFrameIdle'
      when @FreezableStates.active then Crafty.trigger 'EnterFrameActive'


# Patrol on a horizontal line
# You must set the following attributes:
#   x:      initial x position
#   y:      initial y position
#   left:   leftmost x point of the patrol
#   right:  rightmost x point of the patrol
#   patrolState: initial state. 
#     HorizontalPatrolStates.patrolRight start moving to the right
#     HorizontalPatrolStates.patrolLeft  start moving to the left
#
# Example for a new rat on patrol:    
#   @rat = Window.rat = Crafty.e 'Rat'
#   @rat.attr x: 200, y: 200, w:20, h:20, left: 200, right: 300
#   @rat.patrolState = @rat.HorizontalPatrolStates.patrolRight


Crafty.c 'HorizontalPatrol',
  HorizontalPatrolStates:
    idleLeft: 0
    idleRight: 1
    patrolLeft: 2
    patrolRight: 3

  init: () ->
    @requires '2D'
    @speed = 1
    @MAX_PAUSE = 50 #Number of frames to idle at endpoints
    @pauseCounter = 0 #Fix this
    @bind 'EnterFrameActive', @_enterframeActive
  
  bounds: (left,right) ->
    @left = left
    @right = right
    return

  _wait: () ->
    if @pauseCounter < @MAX_PAUSE
      @pauseCounter += 1
      return false
    else
      @pauseCounter = 0
      return true

  _enterframeActive: () ->
    switch @patrolState
      when @HorizontalPatrolStates.idleLeft
        @patrolState = @HorizontalPatrolStates.patrolRight if @_wait()
      when @HorizontalPatrolStates.idleRight
        @patrolState = @HorizontalPatrolStates.patrolLeft if @_wait()
      when @HorizontalPatrolStates.patrolLeft
        if @x < @left
          @patrolState = @HorizontalPatrolStates.idleLeft
        else
          @x -= @speed
      when @HorizontalPatrolStates.patrolRight
        if @x > @right
          @patrolState = @HorizontalPatrolStates.idleRight
        else
          @x += @speed        
  _reversePatrol: ->
    switch @patrolState
      when @HorizontalPatrolStates.patrolRight
        @patrolState = @HorizontalPatrolStates.idleRight
      when @HorizontalPatrolStates.patrolLeft
        @patrolState = @HorizontalPatrolStates.idleLeft
