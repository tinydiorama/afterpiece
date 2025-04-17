extends Node2D

@export var currentLevelManager:Node
@export var currentLevel := 0
@export var allLevelManagers:Array[LevelManager]
@export var camera:Camera2D
@export var player:Node

@onready var loadingScreen = $LoadingScreen
@onready var colorRect = $LoadingScreen/ColorRect
@onready var animationPlayer = $AnimationPlayer

var levelLoading = false

func _ready() -> void:
	GameManager.masterLevelController = self
	GameManager.timePassing = true
	# check if we have a loaded game
	if ( GameManager.saverLoader.hasLoadedData() && GameManager.saverLoader.savedGame.currentLevel != -1 ):
		var savedData:SavedGame = GameManager.saverLoader.savedGame
		loadLevelData(savedData.levelSavedData)
		newLevelData(savedData.currentLevel, 0)
	else:
		newLevelData(0, 0)

func loadLevel(id:int, positionId:int) -> void:
	if ( ! levelLoading ):
		levelLoading = true
		GameManager.timePassing = false
		animationPlayer.play("fade")
		await animationPlayer.animation_finished
		newLevelData(id, positionId)
		animationPlayer.play_backwards("fade")
		await animationPlayer.animation_finished
		GameManager.timePassing = true
		levelLoading = false
	
func newLevelData(id:int, positionId:int) -> void:
	currentLevelManager = allLevelManagers[id]
	currentLevel = id
	camera.setCameraLimit(currentLevelManager.cameraTopLeft, currentLevelManager.cameraBottomRight)
	player.global_position = currentLevelManager.allLevelLocations[positionId].global_position
	camera.global_position = currentLevelManager.allLevelLocations[positionId].global_position
	movePlayer(currentLevelManager.characterRoot)
	
func movePlayer(newParent):
	(func(): player.reparent(newParent)).call_deferred()
	
func loadLevelData(savedLevels:Array[LevelSavedData]):
	for savedLevel in savedLevels:
		allLevelManagers[savedLevel.id].onBeforeLoadGame()
		allLevelManagers[savedLevel.id].onLoadGame(savedLevel)
