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

    @playerEntity = Crafty.e 'PlayerCharacter'
    @playerEntity.attr x:@STAGE_WIDTH/2, y:@STAGE_WIDTH/2, w:20, h:20
    @playerEntity.color 'blue'
