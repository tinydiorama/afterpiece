extends Area2D

const hitEffect = preload("res://scenes/helper/hit_effect.tscn")

@onready var timer = $Timer
@onready var collisionShape = $CollisionShape2D
@export var offsetY:int = 0

signal invincibility_started
signal invincibility_ended

var invincible = false:
	set(value):
		invincible = value
		if ( invincible ):
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")

func startInvincibility(duration):
	self.invincible = true
	timer.start(duration)

func createHitEffect():
	var effect = hitEffect.instantiate()
	GameManager.viewportContainer.add_child(effect)
	effect.global_position = global_position + Vector2(0, offsetY)


func _on_timer_timeout() -> void:
	self.invincible = false

func _on_invincibility_started() -> void:
	collisionShape.set_deferred("disabled", true)
	
func _on_invincibility_ended() -> void:
	collisionShape.disabled = false
