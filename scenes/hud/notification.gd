extends HBoxContainer

@onready var itemAddedUI = $ItemAdded
@onready var animationPlayer = $AnimationPlayer

func addNotification(item:InventoryItem):
	itemAddedUI.texture = item.texture
	animationPlayer.play("fade")
	await animationPlayer.animation_finished
	await get_tree().create_timer(2).timeout
	animationPlayer.play_backwards("fade")
	await animationPlayer.animation_finished
