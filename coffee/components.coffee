# Enemy Component
Crafty.c "Enemy",
  init: () ->
    @requires 'Canvas, Color, 2D, Collision'
    @bind "EnterFrame", @_enterframe
    @speed = .25
    return

  # enemies move every frame
  _enterframe: () ->
    px = Window.playerEntity.getX()
    py = Window.playerEntity.getY()
    ang = Math.atan2((py-@y),(px-@x))
    
    @x += @speed * Math.cos(ang)
    @y += @speed * Math.sin(ang)
    return

Crafty.c 'Obstacle',
  init: () ->
    @requires 'Canvas, Color, 2D, Collision'
    @onHit "PlayerCharacter", @_onHit
    @onHit "Enemy", @_onHit
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
