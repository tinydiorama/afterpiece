extends Area2D

@export var levelToGoToId:int
@export var idLocation:int

var levelManager

func _ready() -> void:
	levelManager = get_parent()

func _on_body_entered(body: Node2D) -> void:
	levelManager.saveSceneData()
	GameManager.timePassing = false
	GameManager.levelLoader.load_level(levelToGoToId)
	GameManager.currentLevelPosition = idLocation
