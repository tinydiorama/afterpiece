extends Area2D

var canSave := false

func _on_body_entered(body: Node2D) -> void:
	canSave = true


func _on_body_exited(body: Node2D) -> void:
	canSave = false

func _unhandled_input(event):
	if ( event.is_action_pressed("interact") && canSave ):
		GameManager.saverLoader.saveGame()
