extends Node2D

@onready var particles:CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	particles.one_shot = true

func _on_cpu_particles_2d_finished() -> void:
	queue_free()
