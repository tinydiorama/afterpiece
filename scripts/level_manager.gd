class_name LevelManager
extends Node

@export var id:int
@export var allLevelLocations:Array[Marker2D]
@export var characterRoot:Node
@export var cameraTopLeft:Marker2D
@export var cameraBottomRight:Marker2D

var myData:LevelSavedData

func _ready() -> void:
	pass
	
	
func loadSceneData():
	myData = GameManager.saverLoader.loadSceneData(id)
	
	if ( myData ):
		characterRoot.call_group("EnemyGameEvent", "onBeforeLoadGame")
		for item in myData.enemies:
			var scene = load(item.scenePath) as PackedScene
			var restoredNode = scene.instantiate()
			characterRoot.add_child(restoredNode)

			if ( restoredNode.has_method("onLoadGame")):
				restoredNode.onLoadGame(item)

	
func saveSceneData():
	#save my data
	myData = LevelSavedData.new()
	myData.id = id
	
	var enemySavedData:Array[EnemySavedData] = []
	var pickupSavedData:Array[PickupSavedData] = []
	for child in characterRoot.find_children("*"):
		if child.is_in_group("EnemyGameEvent"):
			child.onSaveGame(enemySavedData)
		elif child.is_in_group("PickupGameEvent"):
			child.onSaveGame(pickupSavedData)
	myData.enemies = enemySavedData
	myData.pickableItems = pickupSavedData

func onSaveGame(saved_data:Array[LevelSavedData]):
	saveSceneData()
	saved_data.append(myData)

func onBeforeLoadGame():
	for child in characterRoot.find_children("*"):
		if child.is_in_group("EnemyGameEvent"):
			child.onBeforeLoadGame()
		elif child.is_in_group("PickupGameEvent"):
			child.onBeforeLoadGame()
	
func onLoadGame(savedData:LevelSavedData):
	for enemyData in savedData.enemies:
		var scene = load(enemyData.scenePath) as PackedScene
		var restoredNode = scene.instantiate()
		characterRoot.add_child(restoredNode)
		restoredNode.onLoadGame(enemyData)
	for pickupData in savedData.pickableItems:
		var scene = load(pickupData.scenePath) as PackedScene
		var restoredNode = scene.instantiate()
		characterRoot.add_child(restoredNode)
		restoredNode.onLoadGame(pickupData)
