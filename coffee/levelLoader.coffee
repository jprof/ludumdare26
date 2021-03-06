Crafty.c "LevelLoader",
  init: () ->
    #Define Levels
    console.log "LevelLoader created"
    window.currentLevel = 0
    
    Crafty.scene "currentLevel", () ->
      newLevel = window.levelData[window.currentLevel]
      bg = Crafty.e "2D, Canvas, Image"
      bg.attr
        x: -Crafty.viewport.width,
        y: -Crafty.viewport.height,
        w: Crafty.viewport.width * 2 + newLevel["width"],
        h: Crafty.viewport.height * 2 + newLevel["height"]
      bg.image "assets/img/bg2.png", "repeat"
      Crafty('LevelLoader').loadBorder newLevel["width"], newLevel["height"]
      Crafty('LevelLoader').loadPlayer newLevel["player"]
      Crafty('LevelLoader').loadEnemies newLevel["enemies"]
      Crafty('LevelLoader').loadRats newLevel["rats"]
      Crafty('LevelLoader').loadPrize newLevel["prizes"]
      Crafty('LevelLoader').loadBuilding1s newLevel["building1s"]
      Crafty('LevelLoader').loadBuilding2s newLevel["building2s"]

    Crafty.scene "nextLevel", () ->
      window.currentLevel += 1
      newLevel = window.levelData[window.currentLevel]
      bg = Crafty.e "2D, Canvas, Image"
      bg.attr
        x: -Crafty.viewport.width,
        y: -Crafty.viewport.height,
        w: Crafty.viewport.width * 2 + newLevel["width"],
        h: Crafty.viewport.height * 2 + newLevel["height"]
      bg.image "assets/img/bg2.png", "repeat"
      Crafty('LevelLoader').loadBorder newLevel["width"], newLevel["height"]
      Crafty('LevelLoader').loadPlayer newLevel["player"]
      Crafty('LevelLoader').loadEnemies newLevel["enemies"]
      Crafty('LevelLoader').loadRats newLevel["rats"]
      Crafty('LevelLoader').loadPrize newLevel["prizes"]
      Crafty('LevelLoader').loadBuilding1s newLevel["building1s"]
      Crafty('LevelLoader').loadBuilding2s newLevel["building2s"]

    Crafty.scene "endGame", () ->
      Crafty('LevelLoader').endGame()

    return

  nextLevel: () ->
    if window.currentLevel + 1 == window.levelData.length
      Crafty.scene "endGame"
    else
      Crafty.scene "nextLevel"
    return

  reloadLevel: () ->
    Crafty.scene "currentLevel"
    return

  endGame: () ->
    Crafty.viewport.x = Crafty.viewport.y = 0
    bg = Crafty.e "2D, Canvas, Image"
    bg.attr
      x: 0,
      y: 0,
      w: Crafty.viewport.width,
      h: Crafty.viewport.height
    bg.image "assets/img/bg2.png", "repeat"
    @text = Crafty.e "2D, DOM, Text, Keyboard"
    @text.attr
      x: (Crafty.viewport.width / 2) - 100,
      y: (Crafty.viewport.height / 2) - 100
    @text.textColor "#FF0000", 1
    @text.css {"font-size": "3em", "font-weight": "bold"}
    @text.text "Game Over!"
    return

  loadBorder: (width, height) ->
    # left
    x = -100
    for y in [-100..height] by 100
      building = Crafty.e 'Border'
      building.x = x
      building.y = y
      building.z = y + building.h
    # top
    y = -100
    for x in [0..width] by 100
      building = Crafty.e 'Border'
      building.x = x
      building.y = y
      building.z = y + building.h
    # right
    x = width
    for y in [0..height-100] by 100
      building = Crafty.e 'Border'
      building.x = x
      building.y = y
      building.z = y + building.h
    # bottom
    y = height
    for x in [0..width] by 100
      building = Crafty.e 'Border'
      building.x = x
      building.y = y
      building.z = y + building.h
    return

  loadPlayer: (data) ->
    console.log "Player"
    console.log data
    @playerHolder = Window.playerEntity = Crafty.e "PlayerCharacter"
    @playerHolder.x = @playerHolder.targetX = data["x"]
    @playerHolder.y = @playerHolder.targetY = data["y"]
    @playerHolder.z = @playerHolder.y + @playerHolder.h
    Crafty.viewport.clampToEntities = false
    Crafty.viewport.follow @playerHolder, 0, 0
    return

  loadEnemies: (enemies) ->
    console.log "Enemies"
    for enemy in enemies
      console.log enemy
      @enemyHolder = Crafty.e "Enemy"
      @enemyHolder.x = @enemyHolder.targetX = enemy["x"]
      @enemyHolder.y = @enemyHolder.targetY = enemy["y"]
      @enemyHolder.z = @enemyHolder.y + @enemyHolder.h
    return
  
  loadRats: (rats) ->
    console.log "Rats"
    for rat in rats
      console.log rat
      @ratHolder = Crafty.e "Rat"
      @ratHolder.attr x:rat["x"], y:rat["y"]
      @ratHolder.z = @ratHolder.y + @ratHolder.h
      @ratHolder.attr left:rat["l"], right:rat["r"]
      @ratHolder.patrolState = rat["s"]
    return

  loadPrize: (prizes) ->
    for prize in prizes
      console.log "Prize"
      console.log prize
      @prizeHolder = Crafty.e "Prize"
      @prizeHolder.attr x: prize["x"], y: prize["y"]
      @prizeHolder.z = @prizeHolder.y + @prizeHolder.h
    return

  loadBuilding1s: (building1s) ->
    console.log "Building1"
    for building1 in building1s
      console.log building1
      @hrHolder = Crafty.e "Building1"
      @hrHolder.attr x:building1["x"], y:building1["y"]
      @hrHolder.z = @hrHolder.y + @hrHolder.h
    return

  loadBuilding2s: (building2s) ->
    console.log "Building2"
    for building2 in building2s
      console.log building2
      @hrHolder = Crafty.e "Building2"
      @hrHolder.attr x:building2["x"], y:building2["y"]
      @hrHolder.z = @hrHolder.y + @hrHolder.h
    return
