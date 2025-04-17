extends StaticBody2D

var BushEffect = preload("res://scenes/environment/bush_effect.tscn") 
var droppedHeart = preload("res://scenes/helper/heart_drop.tscn")

var percentChanceDrop = 2

func create_effect():
	var bushEffect = BushEffect.instantiate()
	#var world = get_tree().current_scene
	var world = get_parent()
	world.add_child(bushEffect)
	bushEffect.global_position = global_position
	

func _on_hurt_box_area_entered(_area: Area2D) -> void:
	var dropCheck = randi() % 10
	if ( dropCheck <= percentChanceDrop ):
		var heartDrop = droppedHeart.instantiate()
		var world = get_parent()
		(func(): addHeart(heartDrop)).call_deferred()
	create_effect()
	queue_free()

func addHeart(heartDrop) -> void:
	get_parent().add_child(heartDrop)
	heartDrop.global_position = global_position
