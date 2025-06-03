extends Area2D

@onready var grassSprite:AnimatedSprite2D = $AnimatedGrass
@onready var timer:Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	grassSprite.play("smash")
	timer.start(0.3)


func _on_timer_timeout() -> void:
	grassSprite.play("regrow")


func _on_animated_grass_animation_finished() -> void:
	if ( grassSprite.animation == "regrow" ):
		grassSprite.play("default")
