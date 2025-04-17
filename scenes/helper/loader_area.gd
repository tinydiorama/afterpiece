extends Area2D

@export var levelToGoToId:int
@export var idLocation:int

func _on_body_entered(body: Node2D) -> void:
	if ( body.is_in_group("Player") ):
		GameManager.masterLevelController.loadLevel(levelToGoToId, idLocation)
	else: # must be an NPC
		var levelToGoTo = GameManager.masterLevelController.allLevelManagers[levelToGoToId]
		var positionToGoTo = levelToGoTo.allLevelLocations[idLocation]
		body.global_position = positionToGoTo.global_position
