window.Game =
  start: ()->
    @STAGE_WIDTH = 800
    @STAGE_HEIGHT = 600
    Crafty.init @STAGE_HEIGHT, @STAGE_WIDTH
    Crafty.background 'black'

    @playerEntity = Crafty.e 'Canvas, Color, 2D, Collision'
    @playerEntity.attr x:@STAGE_WIDTH/2, y:@STAGE_WIDTH/2, w:200, h:200
    @playerEntity.color 'blue'

