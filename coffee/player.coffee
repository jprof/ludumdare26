Crafty.c 'PlayerCharacter',
  init: () ->
    @requires 'Canvas, Color, 2D, Collision'
    @bind "KeyDown", @_keydown
    @bind "EnterFrame", @_enterframe
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
    if not @movedThisTick
      # 0 < accuracy < 1; higher is better
      accuracy = Math.abs(@frame % @framesPerTick - @framesPerTick / 2) * 2 / @framesPerTick
      # left: 37
      # right: 39
      # up: 38
      # down: 40
      switch e.key
        when 37 then @targetX -= accuracy * @maxSpeed
        when 39 then @targetX += accuracy * @maxSpeed
        when 38 then @targetY -= accuracy * @maxSpeed
        when 40 then @targetY += accuracy * @maxSpeed
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
