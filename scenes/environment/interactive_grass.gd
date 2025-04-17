extends Area2D

@onready var sprite:Sprite2D = $Animatedgrass

@export var skewValue := 5
@export var bendGrassAnimationSpeed = 0.3
@export var grassReturnAnimationSpeed = 5.0

func _on_body_entered(body: Node2D) -> void:
	var direction = global_position.direction_to(body.global_position)
	var skew:int = -direction.x * skewValue
	
	var tween = create_tween()
	tween.tween_property(
		sprite.material,
		"shader_parameter/skew",
		skew,
		bendGrassAnimationSpeed
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		sprite.material,
		"shader_parameter/skew",
		0.0,
		grassReturnAnimationSpeed
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
