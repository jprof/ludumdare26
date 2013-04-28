DRUM_ASSETS =
[
    "assets/audio/ludum_beat.mp3",
    "assets/audio/ludum_beat.ogg",
    "assets/audio/ludum_beat.wav"
]

ASSETS = [].concat DRUM_ASSETS
Crafty.scene "load", () ->
    console.log "loading start"

    Crafty.audio.add "drum", DRUM_ASSETS

    Crafty.load ASSETS, () ->
        console.log "loading done"
        Crafty.scene "main"
        return
    return



Crafty.scene "main", () ->
    console.log "main"

    @gameMaster = Crafty.e 'GameMaster'

    @player = Window.playerEntity = Crafty.e 'PlayerCharacter'

    Window.enemies = []

    @enemySquare = Crafty.e 'Enemy'
    randX = Crafty.math.randomInt(0,@STAGE_WIDTH-20)
    randY = Crafty.math.randomInt(0,@STAGE_HEIGHT-20)
    @enemySquare.attr x: 400, y:400, w:20, h:20
    @enemySquare.color 'red'
    Window.enemies.push @enemySquare  

    @obj = Crafty.e 'Obstacle'
    @obj.attr x: 120, y: 50, w:50, h:50
    @obj.color 'yellow'

    @rat = Window.rat = Crafty.e 'Rat'
    @rat.attr x: 200, y: 200, w:20, h:20
    @rat.setPathLength 100
