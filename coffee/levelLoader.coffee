Crafty.c "LevelLoader",
  init: () ->
    #Define Levels
    console.log "LevelLoader created"
    window.currentLevel = 0
    
    Crafty.scene "currentLevel", () ->
      newLevel = window.levelData[window.currentLevel]
      Crafty('LevelLoader').loadPlayer newLevel["player"]
      Crafty('LevelLoader').loadEnemies newLevel["enemies"]
      Crafty('LevelLoader').loadRats newLevel["rats"]
      Crafty('LevelLoader').loadObstacles newLevel["obstacles"]
      Crafty('LevelLoader').loadPrize newLevel["prize"]
      Crafty('LevelLoader').loadHighrises newLevel["highrises"]

    Crafty.scene "nextLevel", () ->
      window.currentLevel += 1
      newLevel = window.levelData[window.currentLevel]
      Crafty('LevelLoader').loadPlayer newLevel["player"]
      Crafty('LevelLoader').loadEnemies newLevel["enemies"]
      Crafty('LevelLoader').loadRats newLevel["rats"]
      Crafty('LevelLoader').loadObstacles newLevel["obstacles"]
      Crafty('LevelLoader').loadPrize newLevel["prize"]
      Crafty('LevelLoader').loadHighrises newLevel["highrises"]

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
    @text = Crafty.e "2D, DOM, Text, Keyboard"
    @text.attr x: 250, y:300
    @text.textColor "#FF0000", 1
    @text.css {"font-size": "3em", "font-weight": "bold"}
    @text.text "Game Over!"
    return

  loadPlayer: (data) ->
    console.log "Player"
    console.log data
    @playerHolder = Window.playerEntity = Crafty.e "PlayerCharacter"
    @playerHolder.x = @playerHolder.targetX = data["x"]
    @playerHolder.y = @playerHolder.targetY = data["y"]
    return

  loadEnemies: (enemies) ->
    console.log "Enemies"
    for enemy in enemies
      console.log enemy
      @enemyHolder = Crafty.e "Enemy"
      @enemyHolder.x = @enemyHolder.targetX = enemy["x"]
      @enemyHolder.y = @enemyHolder.targetY = enemy["y"]
      @enemyHolder.color "red"
    return
  
  loadRats: (rats) ->
    console.log "Rats"
    for rat in rats
      console.log rat
      @ratHolder = Crafty.e "Rat"
      @ratHolder.attr x:rat["x"], y:rat["y"]
      @ratHolder.attr left:rat["l"], right:rat["r"]
      @ratHolder.patrolState = rat["s"]
    return
  
  loadObstacles: (obstacles) ->
    console.log "Obstacles"
    for obst in obstacles
      console.log obst
      @obstHolder = Crafty.e "Obstacle"
      @obstHolder.x = obst["x"]
      @obstHolder.y = obst["y"]
      @obstHolder.w = obst["w"]
      @obstHolder.h = obst["h"]
    return

  loadPrize: (prize) ->
    console.log "Prize"
    console.log prize
    @prizeHolder = Crafty.e "Prize"
    @prizeHolder.attr x: prize["x"], y: prize["y"], w:20, h:20
    @prizeHolder.color "orange"
    return

  loadHighrises: (highrises) ->
    console.log "Highrise"
    for highrise in highrises
      console.log highrise
      @hrHolder = Crafty.e "Highrise"
      @hrHolder.attr x:highrise["x"], y:highrise["y"]
    return
