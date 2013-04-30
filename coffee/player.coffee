Crafty.c 'PlayerCharacter',
  PlayerStates:
    idleUp: 0
    idleRight: 1
    idleDown: 2
    idleLeft: 3
    dashUp: 4
    dashRight: 5
    dashDown: 6
    dashLeft: 7
    walkUp: 8
    walkRight: 9
    walkDown: 10
    walkLeft: 11

  init: () ->
    @requires 'Canvas, Color, 2D, Collision, gnome, SpriteAnimation'
    @onHit "Prize", @_onHitPrize
    @onHit "Rat", @die
    @onHit "Enemy", @die
    @bind 'KeydownActive', @_keydownActive
    @bind 'EnterFrameActive', @_playerEnterframeActive
    @collision new Crafty.polygon [20,90], [50,90], [50,125], [20,125]
    @movedThisTick = false
    @framesPerTick = 50
    @maxSpeed = 200
    @w = 70
    @h = 125
    @z = 3
    @color 'none'
    @playerState = @PlayerStates.idleDown
    return

  getX: () ->
    return @x

  getY: () ->
    return @y

  _keydownActive: (e) ->
    #constants for deermining when and how much
    #to push back
    @ACC_BOUND = .7
    @MULT = 5
    if not @movedThisTick
      # 0 < accuracy < 1; higher is better
      accuracy = Math.abs(Crafty.frame() % @framesPerTick - @framesPerTick / 2) * 2 / @framesPerTick
      # left:  37 || 65
      # right: 39 || 68
      # up:    38 || 87
      # down:  40 || 83
      switch e.key
        when 37
          @playerState = @PlayerStates.dashLeft
          @targetX -= accuracy * @maxSpeed
        when 39
          @playerState = @PlayerStates.dashRight
          @targetX += accuracy * @maxSpeed
        when 38
          @playerState = @PlayerStates.dashUp
          @targetY -= accuracy * @maxSpeed
        when 40
          @playerState = @PlayerStates.dashDown
          @targetY += accuracy * @maxSpeed
      if e.key == 37 or e.key == 39 or e.key == 38 or e.key == 40
        console.log "accuracy #{accuracy}"
        @blowAway @MULT * (accuracy - @ACC_BOUND) if accuracy > @ACC_BOUND
      @movedThisTick = true
    return

  _playerEnterframeActive: () ->
    if @prevPlayerState != @playerState
      @stop()
      switch @playerState
        when @PlayerStates.idleUp
          @animate('idleUp', 0, 5, 3)
          @animate('idleUp', 80, -1)
        when @PlayerStates.idleRight
          @animate('idleRight', 0, 6, 3)
          @animate('idleRight', 80, -1)
        when @PlayerStates.idleDown
          @animate('idleDown', 0, 4, 3)
          @animate('idleDown', 80, -1)
        when @PlayerStates.idleLeft
          @animate('idleLeft', 0, 7, 3)
          @animate('idleLeft', 80, -1)
        when @PlayerStates.dashUp
          @animate('dashUp', 4, 1, 5)
          @animate('dashUp', 25, 0)
        when @PlayerStates.dashRight
          @animate('dashRight', 4, 2, 5)
          @animate('dashRight', 25, 0)
        when @PlayerStates.dashDown
          @animate('dashDown', 4, 0, 5)
          @animate('dashDown', 25, 0)
        when @PlayerStates.dashLeft
          @animate('dashLeft', 4, 3, 5)
          @animate('dashLeft', 25, 0)
        when @PlayerStates.walkUp
          @animate('walkUp', 0, 1, 3)
          @animate('walkUp', 8, -1)
        when @PlayerStates.walkRight
          @animate('walkRight', 0, 2, 3)
          @animate('walkRight', 8, -1)
        when @PlayerStates.walkDown
          @animate('walkDown', 0, 0, 3)
          @animate('walkDown', 8, -1)
        when @PlayerStates.walkLeft
          @animate('walkLeft', 0, 3, 3)
          @animate('walkLeft', 8, -1)
    @prevPlayerState = @playerState
    @dx = (@targetX - @x) * .1
    @dy = (@targetY - @y) * .1
    @x += @dx
    @y += @dy
    @z = @y + @h
    if Math.abs(@dx) + Math.abs(@dy) < 5
      switch @playerState
        when @PlayerStates.dashUp
          @playerState = @PlayerStates.walkUp
        when @PlayerStates.dashRight
          @playerState = @PlayerStates.walkRight
        when @PlayerStates.dashDown
          @playerState = @PlayerStates.walkDown
        when @PlayerStates.dashLeft
          @playerState = @PlayerStates.walkLeft
    if Math.abs(@dx) + Math.abs(@dy) < 1
      switch @playerState
        when @PlayerStates.walkUp
          @playerState = @PlayerStates.idleUp
        when @PlayerStates.walkRight
          @playerState = @PlayerStates.idleRight
        when @PlayerStates.walkDown
          @playerState = @PlayerStates.idleDown
        when @PlayerStates.walkLeft
          @playerState = @PlayerStates.idleLeft
    if Crafty.frame() % @framesPerTick == @framesPerTick / 2
      @movedThisTick = false
    if Crafty.frame() % @framesPerTick == @framesPerTick - 4
      Crafty.audio.play "drum"
    return

  #push all the enemies away from the player
  #stength will be a float between 0 and 1
  blowAway: (strength) ->

    @_pushEnemy enemy, strength for enemy in Crafty("Enemy")
    return

  _pushEnemy: (e,strength) ->
    cap = 200 * strength
    worstCase = 20
    enemy = Crafty(e)
    
    px = @targetX
    py = @targetY

    ex = enemy.x
    ey = enemy.y
    
    #d = 10 / (1 + Crafty.math.distance px, py, ex, ey)
    d = Math.max worstCase, cap - Crafty.math.distance px, py, ex, ey

    ang = Math.atan2((py-ey),(px-ex))
    
    enemy.targetX -= d * Math.cos(ang)
    enemy.targetY -= d * Math.sin(ang)

  _onHitPrize: (hits) ->
    for hit in hits
      Crafty.trigger "PrizeGet"
      hit.obj.destroy()
      prizes = Crafty "Prize"
      if prizes.length == 0
        Crafty("LevelLoader").nextLevel()
    return

  die: () ->
    @deadPlayer = Crafty.e 'DeadPlayer'
    @deadPlayer.x = @x - 15
    @deadPlayer.y = @y + 28
    @deadPlayer.z = @y + @h
    @destroy()

Crafty.c 'DeadPlayer',
  init: () ->
    @requires 'Canvas, Color, 2D, Collision, deadgnome, Sprite'
    @timeout window.levelLoader.reloadLevel, 2000
