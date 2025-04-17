extends Node2D

@export var wanderRange := 32

@onready var startPos:Vector2 = global_position
@onready var targetPos:Vector2 = global_position
@onready var timer:Timer = $Timer

func _ready() -> void:
	updateTargetPos()

func _on_timer_timeout() -> void:
	updateTargetPos()

func updateTargetPos():
	var targetVector = Vector2(randf_range(-wanderRange, wanderRange), randf_range(-wanderRange, wanderRange))
	targetPos = startPos + targetVector

func getTimeLeft():
	return timer.time_left

func startWanderTimer(duration:int):
	timer.start(duration)
