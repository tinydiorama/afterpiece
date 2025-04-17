extends CharacterBody2D

const destroyEffect = preload("res://scenes/environment/enemy_death.tscn") 

enum {
	IDLE,
	WANDER,
	CHASE,
	KNOCKBACK
}

@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var sprite:AnimatedSprite2D = $Slime
@onready var hurtBox = $HurtBox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WanderController
@onready var stunTimer = $StunTimer

@export var knockbackSpeed = 20
@export var speed := 10
@export var acceleration := 500
@export var friction := 50

var knockback := Vector2.ZERO
var state := IDLE
var initialPosition:Vector2

func _ready() -> void:
	state = pickRandomState([IDLE, WANDER])
	initialPosition = global_position

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, delta * knockbackSpeed)
	move_and_slide()
	
	match state:
		IDLE:
			sprite.play("default")
			velocity = velocity.move_toward(Vector2.ZERO, delta * speed)
			checkWander()
		WANDER:
			sprite.play("default")
			checkWander()
			var direction = global_position.direction_to(wanderController.targetPos)
			velocity = velocity.move_toward(direction * speed, acceleration)
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				sprite.play("jump")
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * speed, acceleration)
			else:
				state = IDLE
		KNOCKBACK:
			pass
				
	sprite.flip_h = velocity.x < 0
	move_and_slide()
	
func checkWander():
	seekPlayer()
	if ( wanderController.getTimeLeft() == 0 ):
		state = pickRandomState([IDLE, WANDER])
		wanderController.startWanderTimer(randi_range(1, 3))
	
func seekPlayer():
	if ( playerDetectionZone.canSeePlayer() ):
		state = CHASE
		
func pickRandomState(stateList:Array) -> int:
	stateList.shuffle()
	return stateList.pop_front()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	var direction = ( position - area.owner.position ).normalized()
	velocity = direction * knockbackSpeed
	sprite.frame = 0
	move_and_slide()
	state = KNOCKBACK
	stunTimer.start(1)
	hurtBox.createHitEffect()

func _on_stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = destroyEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.position = position


func _on_stun_timer_timeout() -> void:
	state = CHASE

func onSaveGame(saved_data:Array[EnemySavedData]):
	var myData = EnemySavedData.new()
	myData.position = initialPosition
	myData.scenePath = scene_file_path
	saved_data.append(myData)

func onBeforeLoadGame():
	get_parent().remove_child(self)
	queue_free()
	
func onLoadGame(savedData:EnemySavedData):
	global_position = savedData.position
