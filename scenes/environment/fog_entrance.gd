extends Area2D

@onready var fogAnimationPlayer = $"../FogAnimation"

func _on_body_entered(body: Node2D) -> void:
	print("body")
	fogAnimationPlayer.play("showfog")


func _on_body_exited(body: Node2D) -> void:
	fogAnimationPlayer.play_backwards("showfog")
