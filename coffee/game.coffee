window.Game =
  start: ()->
    @STAGE_WIDTH = 800
    @STAGE_HEIGHT = 600
    Crafty.init @STAGE_HEIGHT, @STAGE_WIDTH
    Crafty.background 'green'

    @playerEntity = Crafty.e 'PlayerCharacter'
    @playerEntity.attr x:@STAGE_WIDTH/2, y:@STAGE_WIDTH/2, w:20, h:20
    @playerEntity.color 'blue'

