window.Game =
  start: ()->
    @STAGE_WIDTH = 800
    @STAGE_HEIGHT = 600
    Crafty.init @STAGE_WIDTH, @STAGE_HEIGHT
    Crafty.background 'green'

    Crafty.sprite(100, 'assets/img/building.gif', {
      highrise: [0, 0]
    })

    Crafty.scene "load"

