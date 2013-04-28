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
        Crafty.scene "title"
        return
    return

Crafty.scene "title", () ->
    proceedToMain = () ->
      console.log "Proceeding"
      Crafty.scene "main"

    displayTitle = () ->
      console.log "displayTitle"
      @text = Crafty.e "2D, DOM, Text, Keyboard"
      @text.attr { x: 250, y: 300 }
      @text.textColor "#FF0000", 1
      @text.css { "font-size": "3em", "font-weight": "bold" }
      @text.text "MetroGnome!"

      # if no keyboard input is received, proceed to main in 10 seconds.
      proceedTimeout = setTimeout proceedToMain, 10000

      # if keyboard input is received, clear the timeout and proceed to main
      @text.bind 'KeyDown', () ->
       console.log "KeyDown"
       clearTimeout proceedTimeout
       proceedToMain()

    displayTitle()

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
    buildBoundaries window

    @obj = Crafty.e 'Obstacle'
    @obj.attr x: 120, y: 50, w:50, h:50
    @obj.color 'yellow'
    @obj.bind "PrizeGet", () -> @color "orange"

    @rat = Window.rat = Crafty.e 'Rat'
    @rat.attr x: 200, y: 200, w:20, h:20
    @rat.setDistance 100

    @prize = Crafty.e 'Prize'
    @prize.attr x: 400, y: 400, w:20, h:20
    @prize.color 'orange'

    @freezer = Crafty.e 'Freezable'
    @freezer.freezableState = @freezer.FreezableStates.active

# Don't let anything that obstacle cares about get off the screen!
buildBoundaries = (game) ->
  points = [
    {
      # Top
      x: -game.STAGE_WIDTH / 2,
      y: -game.STAGE_HEIGHT,
      w: game.STAGE_WIDTH * 2,
      h: game.STAGE_HEIGHT
    },
    {
      # Left
      x: -game.STAGE_WIDTH,
      y: -game.STAGE_HEIGHT / 2,
      w: game.STAGE_WIDTH,
      h: game.STAGE_HEIGHT * 2
    },
    {
      # Right
      x: game.STAGE_WIDTH,
      y: -game.STAGE_HEIGHT / 2,
      w: game.STAGE_WIDTH,
      h: game.STAGE_HEIGHT * 2
    },
    {
      # Bottom
      x: -game.STAGE_WIDTH / 2,
      y: game.STAGE_HEIGHT,
      w: game.STAGE_WIDTH * 2,
      h: game.STAGE_HEIGHT
    }
  ]

  for point in points
    wall = Crafty.e "Obstacle"
    wall.attr point
  return
