#
# Enemy Component
# Chases after the player
#
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
    
#
# Rat Component
# Moves along a horizontal line
# you define a starting point and define its length
# (negative goes to left of starting point, positive to right
# if endX < start, config = 'left' i.e. intially goe from
# right to left

Crafty.c "Rat",
  init: () ->
    @requires 'Canvas, Color, 2D, Collision'
    @bind "EnterFrame", @_enterframe
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

    console.log("current position: #{@x},#{@y}")
    console.log("@startX: #{@startX}")
    console.log("@endX: #{@endX}")
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



  _wait: (bound, color) ->
    @color color
    if @pauseCounter < @MAX_PAUSE
      @pauseCounter += 1
    else
      @_resetAndReverse()
    return


  _enterframe: () ->
    b = @_boundCheck()

    switch b
      when 'left'  then @_wait('left','pink')
      when 'right' then @_wait('right','red')
      else @x += @dir * @speed
    return
     
