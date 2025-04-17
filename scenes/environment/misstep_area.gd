extends Area2D

@onready var fogAnimation = $"../FogAnimation"
@onready var wasteEntrance := $"../LevelLoadLocation"

func _on_body_entered(body: Node2D) -> void:
	fogAnimation.play("fogwrong")
	fogAnimation.animation_finished.connect(_on_animation_finished)


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func _on_animation_finished(animationName) -> void:
	GameManager.masterLevelController.player.global_position = wasteEntrance.global_position
	GameManager.masterLevelController.camera.global_position = wasteEntrance.global_position
	fogAnimation.animation_finished.disconnect(_on_animation_finished)
	fogAnimation.play_backwards("fogwrong")
