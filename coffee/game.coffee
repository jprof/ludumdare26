window.Game =
  start: ()->
    @STAGE_WIDTH = 800
    @STAGE_HEIGHT = 600
    Crafty.init @STAGE_WIDTH, @STAGE_HEIGHT
    Crafty.background 'green'

    Crafty.sprite(100, 'assets/img/building.gif', {
      highrise: [0, 0]
    })

    Crafty.sprite(100, 60, 'assets/img/rat2.gif', {
      ratRight1: [0, 0]
      ratLeft1: [1, 0]
      ratRight2: [0, 1]
      ratLeft2: [1, 1]
      ratRight3: [0, 2]
      ratLeft3: [1, 2]
      ratRight4: [0, 3]
      ratLeft4: [1, 3]
      ratRight5: [0, 4]
      ratLeft5: [1, 4]
      ratRight6: [0, 5]
      ratLeft6: [1, 5]
    })

    Crafty.scene "load"

