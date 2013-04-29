window.Game =
  start: ()->
    @STAGE_WIDTH = 800
    @STAGE_HEIGHT = 600
    Crafty.init @STAGE_WIDTH, @STAGE_HEIGHT
    Crafty.background 'green'

    Crafty.sprite(100, 100, 'assets/img/building1.gif', {
      building1: [0, 0]
    })

    Crafty.sprite(200, 150, 'assets/img/building2.gif', {
      building2: [0, 0]
    })

    Crafty.sprite(100, 60, 'assets/img/rat2.gif', {
      rat: [0, 0]
    })

    Crafty.sprite(70, 125, 'assets/img/gnome.gif', {
      gnome: [0, 0]
    })

    Crafty.scene "load"

