window.Game =
  start: ()->
    @STAGE_WIDTH = 800
    @STAGE_HEIGHT = 600
    Crafty.init @STAGE_WIDTH, @STAGE_HEIGHT
    Crafty.background 'green'

    # Add simple audio
    Crafty.audio.add("drum", ["assets/audio/ludum_beat.mp3",
                             "assets/audio/ludum_beat.ogg",
                             "assets/audio/ludum_beat.wav"])

    @player = Window.playerEntity = Crafty.e 'PlayerCharacter'
    #@player.attr x:@STAGE_WIDTH/2, y:@STAGE_WIDTH/2, w:20, h:20
    @player.attr x: 50, y: 50, w:20, h:20
    @player.color 'blue'


    @enemySquare = Crafty.e 'Enemy'
    randX = Crafty.math.randomInt(0,@STAGE_WIDTH-20)
    randY = Crafty.math.randomInt(0,@STAGE_HEIGHT-20)
    @enemySquare.attr x: 400, y:400, w:20, h:20
    @enemySquare.color 'red'
