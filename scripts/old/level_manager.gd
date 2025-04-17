extends Node

@export var id:int
@export var allLevelLocations:Array[Marker2D]
@export var player:Node
@export var levelCamera:Camera2D
@export var enemyRoot:Node

var myData:LevelSavedData

func _ready() -> void:
	GameManager.currentLevelManager = self
	GameManager.timePassing = true
	if ( GameManager.currentLevelPosition != -1 ):
		# move the player to the id location
		player.global_position = allLevelLocations[GameManager.currentLevelPosition].global_position
		levelCamera.global_position = allLevelLocations[GameManager.currentLevelPosition].global_position
	loadSceneData()
	
func loadSceneData():
	myData = GameManager.saverLoader.loadSceneData(id)
	
	if ( myData ):
		get_tree().call_group("EnemyGameEvent", "onBeforeLoadGame")
		for item in myData.enemies:
			var scene = load(item.scenePath) as PackedScene
			var restoredNode = scene.instantiate()
			enemyRoot.add_child(restoredNode)

			if ( restoredNode.has_method("onLoadGame")):
				restoredNode.onLoadGame(item)

	
func saveSceneData():
	#save my data
	myData = LevelSavedData.new()
	myData.id = id
	
	var enemySavedData:Array[EnemySavedData] = []
	get_tree().call_group("EnemyGameEvent", "onSaveGame", enemySavedData)
	myData.enemies = enemySavedData
	
	GameManager.saverLoader.saveSceneData(myData)

func onSaveGame(saved_data:Array[LevelSavedData]):
	var myData = LevelSavedData.new()
	myData.id = id
	saved_data.append(myData)

func onBeforeLoadGame():
	pass
	
func onLoadGame(savedData:EnemySavedData):
	pass
