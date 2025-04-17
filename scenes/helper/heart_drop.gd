extends Area2D

@onready var audioPlayer = $AudioStreamPlayer

func _on_body_entered(body: Node2D) -> void:
	PlayerStats.health += 1
	queue_free()


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
