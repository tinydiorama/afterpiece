extends Node

func _ready() -> void:
	GameManager.levelLoader.load_level(GameManager.currentLevel)
