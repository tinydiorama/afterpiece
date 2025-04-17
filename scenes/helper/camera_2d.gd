extends Camera2D

@export_category("Follow Character")
@export var player : CharacterBody2D
@export_category("Camera Smoothing")
@export var smoothingEnabled:bool
@export_range(1, 10) var smoothingDistance:int = 8
@export_category("Camera Shake")
@export var strength:float = 30.0
@export var decayRate:float = 5.0
@export var shakeSpeed:float = 15.0

@export var topLeft:Marker2D
@export var bottomRight:Marker2D

@onready var noise = FastNoiseLite.new()

var shakeStrength:float = 0.0
var noise_i:float = 0.0

func _ready() -> void:
	setCameraLimit(topLeft, bottomRight)
	noise.seed = randi()
	
func setCameraLimit(topLeftSet:Marker2D, bottomRightSet:Marker2D):
	topLeft = topLeftSet
	bottomRight = bottomRightSet
	limit_top = topLeft.global_position.y
	limit_left = topLeft.global_position.x
	limit_bottom = bottomRight.global_position.y
	limit_right = bottomRight.global_position.x

func _physics_process(delta: float) -> void:
	if player != null:
		var cameraPosition:Vector2
		if ( smoothingEnabled ):
			var weight:float = float(smoothingDistance) / 100
			cameraPosition = lerp(global_position, player.global_position, weight)
		else:
			cameraPosition = player.global_position
		global_position = cameraPosition.floor()

func shakeCamera() -> void:
	shakeStrength = strength

func _process(delta:float) -> void:
	shakeStrength = lerp(shakeStrength, 0.0, decayRate * delta)
	offset = getRandomOffset(delta)
	
func getRandomOffset(delta:float) -> Vector2:
	noise_i += delta * shakeSpeed
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shakeStrength,
		noise.get_noise_2d(100, noise_i) * shakeStrength
	)
