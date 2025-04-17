extends CharacterBody2D

@export var schedule:Array[ScheduleItem]

const speed = 50.0
var active:bool = false
@onready var navigationAgent = $NavigationAgent2D

func _unhandled_input(event: InputEvent) -> void:
	if ( event.pressed && event.is_action_pressed("ui_home") ):
		navigationAgent.target_position = get_global_mouse_position()
		active = true

func _physics_process(delta: float) -> void:
	if ( active ):
		var nextPathPos = navigationAgent.get_next_path_position()
		var direction := global_position.direction_to(nextPathPos)
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
func enableNPC() -> void:
	print("NPC activated")
	navigationAgent.target_position = global_position
	active = true

func disableNPC() -> void:
	print("NPC disabled")
	active = false

func _on_navigation_agent_2d_target_reached() -> void:
	print("Reached target")
	disableNPC()


func _on_navigation_agent_2d_navigation_finished() -> void:
	print("Navigation finished")
	disableNPC()
