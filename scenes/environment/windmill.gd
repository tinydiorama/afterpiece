extends StaticBody2D

@onready var animationPlayer:AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.current_animation = "windmillanimation"
	animationPlayer.play()
	
