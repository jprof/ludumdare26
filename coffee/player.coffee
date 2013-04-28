Crafty.c 'PlayerCharacter',
  init: () ->
    @requires 'Canvas, Color, 2D, Collision'
    @bind "KeyDown", @_keydown
    @bind "EnterFrame", @_enterframe
    @onHit "Prize", @_onHitPrize
    @frame = 0
    @movedThisTick = false
    @framesPerTick = 60
    @maxSpeed = 100
    @w = 20
    @h = 20
    @x = 0
    @y = 0
    @targetX = 300
    @targetY = 300
    @color 'blue'
    return

  getX: () ->
    return @x

  getY: () ->
    return @y

  _keydown: (e) ->

    #constants for deermining when and how much
    #to push back
    @ACC_BOUND = .8
    @MULT = 5
    if not @movedThisTick
      # 0 < accuracy < 1; higher is better
      accuracy = Math.abs(@frame % @framesPerTick - @framesPerTick / 2) * 2 / @framesPerTick
      # left:  37 || 65
      # right: 39 || 68
      # up:    38 || 87
      # down:  40 || 83
      switch e.key
        when 37 then @targetX -= accuracy * @maxSpeed
        when 39 then @targetX += accuracy * @maxSpeed
        when 38 then @targetY -= accuracy * @maxSpeed
        when 40 then @targetY += accuracy * @maxSpeed
      if e.key == 37 or e.key == 39 or e.key == 38 or e.key == 40
        console.log "accuracy #{accuracy}"
        @blowAway @MULT * (accuracy - @ACC_BOUND) if accuracy > @ACC_BOUND
      @movedThisTick = true
    return

  _enterframe: () ->
    @x += (@targetX - @x) * .2
    @y += (@targetY - @y) * .2
    if @frame % @framesPerTick == 0
      @color 'blue'
    if @frame % @framesPerTick == @framesPerTick / 2
      @movedThisTick = false
    if @frame % @framesPerTick == @framesPerTick - 5
      Crafty.audio.play "drum"
      @color 'red'
    @frame++
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

    ex = enemy.getX()
    ey = enemy.getY()
    
    #d = 10 / (1 + Crafty.math.distance px, py, ex, ey)
    d = Math.max worstCase, cap - Crafty.math.distance px, py, ex, ey

    ang = Math.atan2((py-ey),(px-ex))
    
    enemy.targetX -= d * Math.cos(ang)
    enemy.targetY -= d * Math.sin(ang)

  _onHitPrize: (hits) ->
    for hit in hits
      Crafty.trigger "PrizeGet"
      #Do something here
      hit.obj.destroy()
