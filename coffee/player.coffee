Crafty.c 'PlayerCharacter',
  init: () ->
    @requires 'Canvas, Color, 2D, Collision'
    @bind "KeyDown", @_keydown
    @bind "EnterFrame", @_enterframe
    @frame = 0
    @movedThisTick = false
    return

  _keydown: (e) ->
    if not @movedThisTick
      accuracy = Math.abs @frame % 60 - 30
      # left: 37
      # right: 39
      # up: 38
      # down: 40
      switch e.key
        when 37 then @x -= accuracy
        when 39 then @x += accuracy
        when 38 then @y -= accuracy
        when 40 then @y += accuracy
      @movedThisTick = true
    return

  _enterframe: () ->
    if @frame % 60 == 30
      @movedThisTick = false
    if @frame % 60 == 55
      Crafty.audio.play "drum"
    @frame++
    return
