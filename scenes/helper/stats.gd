extends Node

signal no_health
signal health_changed(value)
signal max_health_changed(value)

@export var maxHealth := 1:
	get:
		return maxHealth
	set(value):
		maxHealth = value
		if ( health ):
			self.health = min(health, maxHealth)
		emit_signal("max_health_changed", value)

@onready var health = maxHealth:
	get: 
		return health
	set(value): 
		health = value
		emit_signal("health_changed", value)
		if health <= 0:
			emit_signal("no_health")
