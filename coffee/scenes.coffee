DRUM_ASSETS =
[
    "assets/audio/ludum_beat.mp3",
    "assets/audio/ludum_beat.ogg",
    "assets/audio/ludum_beat.wav"
]

ASSETS = ['assets/img/building1.gif',
          'assets/img/building2.gif',
          'assets/img/potato.gif',
          'assets/img/pigeons.gif',
          'assets/img/rat2.gif',
          'assets/img/gnome.gif',
          'assets/img/gnomedeath.gif',
          'assets/img/bg2.png',
          'assets/img/metrognome.gif'].concat DRUM_ASSETS

Crafty.scene "load", () ->
    console.log "loading start"

    Crafty.audio.add "drum", DRUM_ASSETS
    window.levelLoader = Crafty.e "LevelLoader"
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
      @logo = Crafty.e "2D, DOM, Sprite, Keyboard, loadimage"
        
      # if no keyboard input is received, proceed to main in 10 seconds.
      proceedTimeout = setTimeout proceedToMain, 10000

      # if keyboard input is received, clear the timeout and proceed to main
      @logo.bind 'KeyDown', () ->
       console.log "KeyDown"
       clearTimeout proceedTimeout
       proceedToMain()

    displayTitle()

Crafty.scene "main", () ->
    console.log "main"
    @freezer = Crafty.e 'Freezable'
    @freezer.freezableState = @freezer.FreezableStates.active
    Crafty('LevelLoader').reloadLevel()
    return
