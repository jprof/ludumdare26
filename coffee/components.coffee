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
#

Crafty.c "Rat",
  init: () ->
    @requires 'Canvas, Color, 2D, Collision'
    @bind "EnterFrame", @_enterframe
    @color 'gray'
    @speed = 1
    @dir = 1

    #how many frames to pause at ends of path
    @MAX_PAUSE = 20 
    @pauseCounter = 0 #Fix this
  
  setPathLength: (dist) ->
    @startX = @x
    @endX = @startX + dist
    
    #startX should always be to the left
    #of endX
    if @endX < @startX
      temp = @startX
      @startX = @endX
      @endX = temp

    console.log("current position: #{@x},#{@y}")
    console.log("@startX: #{@startX}")
    console.log("@endX: #{@endX}")
    return

  _enterframe: () ->
    if (@x < @startX) or (@x > @endX)
      if @pauseCounter < @MAX_PAUSE 
        @color 'pink'
        @pauseCounter += 1 
      else
        @pauseCounter = 0
        @color 'gray'
        @dir *= -1
        @x += @dir * @speed
     else
        @x += @dir * @speed

    return
     
