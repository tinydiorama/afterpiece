extends CharacterBody2D

const playerHurtSound = preload("res://scenes/helper/playerHurtSound.tscn")
const playerAttackSound = preload("res://assets/sounds/hit-swing-sword-small-2-95566.mp3")

enum {
	MOVE,
	DASH,
	ATTACK,
	ATTACKCOMBO,
	KNOCKBACK
}
var state := MOVE
var canCombo := false
var comboPressed := false
var attacking := false
var dashDirection := Vector2.LEFT
var stats = PlayerStats

@export var speed := 80
@export var acceleration := 500
@export var friction := 500
@export var dashSpeed := 300
@export var knockbackSpeed = 1000

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var hurtBox = $HurtBox
@onready var playerTimer = $Timer
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@onready var audioPlayer = $AudioStreamPlayer

func _ready() -> void:
	stats.connect("no_health", queue_free)

func _process(delta):
	if ( ! GameManager.timePassing ): # Game is paused
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		move_and_slide()
		return
	if ( Input.is_action_just_pressed("attack") && canCombo ): # pressed attack again during first attaack
		comboPressed = true
		
	match state:
		MOVE:
			move_state(delta)
		DASH:
			dash_state(delta)
		ATTACK:
			attack_state(delta)
		ATTACKCOMBO:
			attack_state_combo(delta)
		KNOCKBACK:
			pass
	
func move_state(delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	input_direction = input_direction.normalized()
	
	if ( input_direction != Vector2.ZERO ):
		dashDirection = input_direction
		animationTree.set("parameters/Idle/blend_position", input_direction)
		animationTree.set("parameters/Run/blend_position", input_direction)
		animationTree.set("parameters/Attack/blend_position", input_direction)
		animationTree.set("parameters/Attack2/blend_position", input_direction)
		animationTree.set("parameters/Dash/blend_position", input_direction)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_direction * speed, acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	#print(get_last_slide_collision())
	
	if ( Input.is_action_just_pressed("attack") && ! canCombo && ! attacking ): # first attack
		state = ATTACK
	if ( Input.is_action_just_pressed("dash") ):
		state = DASH

func attack_state(delta):
	if ( ! attacking ):
		animationState.travel("Attack")
		canCombo = true
		attacking = true
		#audioPlayer.stop()
		#audioPlayer.stream = playerAttackSound
		#audioPlayer.play(0.0)
		velocity = velocity.move_toward(Vector2.ZERO, friction/2 * delta)
		move_and_slide()

func attack_state_combo(_delta):
	#audioPlayer.stream = playerAttackSound
	#audioPlayer.play(0.0)
	animationState.travel("Attack2")
	canCombo = false
	
func dash_state(_delta):
	if ( hurtBox.invincible == false ):
		hurtBox.invincible = true
	animationState.travel("Dash")
	velocity = dashDirection * dashSpeed
	move_and_slide()

func attackAnimationFinished():
	attacking = false
	if ( canCombo && comboPressed ):
		state = ATTACKCOMBO
	else:
		state = MOVE
		
	canCombo = false
	comboPressed = false

func dashAnimationFinished():
	hurtBox.invincible = false
	velocity = Vector2.ZERO
	move_and_slide()
	state = MOVE

func _on_hurt_box_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	state = KNOCKBACK
	playerTimer.start(0.1)
	var playerHurtSoundInstance = playerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSoundInstance)
	GameManager.masterLevelController.camera.shakeCamera()
	hurtBox.startInvincibility(0.6)
	hurtBox.createHitEffect()


func _on_timer_timeout() -> void:
	attacking = false
	canCombo = false
	comboPressed = false
	state = MOVE


func _on_hurt_box_invincibility_started() -> void:
	blinkAnimationPlayer.play("start")

func _on_hurt_box_invincibility_ended() -> void:
	blinkAnimationPlayer.play("stop")
