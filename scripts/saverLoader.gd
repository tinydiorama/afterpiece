class_name SaverLoader
extends Node

var savedGame:SavedGame = SavedGame.new()

func saveGame():
	#iterate through each level
	var allLevelDatas:Array[LevelSavedData] = []
	for level in GameManager.masterLevelController.allLevelManagers:
		level.onSaveGame(allLevelDatas)
	savedGame.currentLevel = GameManager.masterLevelController.currentLevel
	savedGame.time = GameManager.time
	savedGame.levelSavedData = allLevelDatas
	ResourceSaver.save(savedGame, "user://save.tres")
	
func loadGame():
	savedGame = load("user://save.tres") as SavedGame
	if ( savedGame.time != -1.0 ):
		GameManager.time = savedGame.time

func hasLoadedData() -> bool:
	return savedGame != null

func clearLoadedData():
	savedGame = SavedGame.new()
