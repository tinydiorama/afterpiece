extends Area2D

var push_velocity = Vector2()
var direction = Vector2.ZERO
@export var push_strength = 50


# push ourselves away from colliding entity
func _physics_process(delta):
	var overlapping_areas = get_overlapping_areas()
	if(overlapping_areas.size() != 0):
		var area = overlapping_areas[0]
		if(area != null):
			var colliding_entity = area.owner
			direction = colliding_entity.global_position.direction_to(global_position)
			push_velocity =  direction * push_strength
			owner.velocity = push_velocity
			owner.move_and_slide()
