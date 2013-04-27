# Enemy Component
Crafty.c "Enemy",
  init: () ->
    @requires 'Canvas, Color, 2D, Collision'
    @bind "EnterFrame", @_enterframe
    @speed = .25
    @color 'red'
    return

  # enemies move every frame
  _enterframe: () ->
    px = Window.playerEntity.getX()
    py = Window.playerEntity.getY()
    ang = Math.atan2((py-@y),(px-@x))
    
    @x += @speed * Math.cos(ang)
    @y += @speed * Math.sin(ang)
    return

Crafty.c 'GameMaster',
  init: () ->
    @bind "KeyDown", @_keydown

  _keydown: (e) ->
    switch e.key
      # e
      when 69 then @spawnEnemy()
      # o
      when 79 then @spawnObstacle()

  spawnEnemy: () ->
    randX = 800 * Math.random()
    randY = 600 * Math.random()
    @enemySquare = Crafty.e 'Enemy'
    @enemySquare.attr x: randX, y:randY, w:20, h:20

  spawnObstacle: () ->
    randX = 800 * Math.random()
    randY = 600 * Math.random()
    randW = 60 * Math.random() + 40
    randH = 60 * Math.random() + 40
    @obstacle = Crafty.e 'Obstacle'
    @obstacle.attr x: randX, y: randY, w:randW, h:randH

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

      if dx > dy
        if playerCenterY < -playerCenterX + objCenterX + objCenterY
          target.obj.y = @y - playerH
          target.obj.targetY = @y - playerH
        else
          target.obj.x = @x + @w
          target.obj.targetX = @x + @w
      else
        if playerCenterY < -playerCenterX + objCenterX + objCenterY
          target.obj.x = @x - playerW
          target.obj.targetX = @x - playerW
        else
          target.obj.y = @y + @h
          target.obj.targetY = @y + @h

    return
