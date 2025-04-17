extends CanvasLayer

@onready var heartUIFull = %HeartsFull
@onready var heartUIEmpty = %HeartsEmpty
@onready var timeIndicator = %TimeIndicator

var maxhearts = 4
var hearts = 4
		
func setHearts(value):
	hearts = clamp(value, 0, maxhearts)
	if ( heartUIEmpty != null ):
		heartUIEmpty.size.x = hearts *  10
		
func setMaxHearts(value):
	maxhearts = max(value, 1)
	if ( hearts ):
		hearts = min(hearts, maxhearts)
	if ( heartUIFull != null ):
		heartUIFull.size.x = maxhearts * 10

func _ready() -> void:
	setMaxHearts(PlayerStats.maxHealth)
	setHearts(PlayerStats.health)
	PlayerStats.connect("health_changed", setHearts)
	PlayerStats.connect("max_health_changed", setMaxHearts)
	GameManager.connect("time_tick", updateTime)

func updateTime(day:int, hour:int, minute:int):
	timeIndicator.position.x = min(((2 + day * 50) + ((hour - GameManager.initialHour) * 2.08)), 104)
