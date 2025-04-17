extends Area2D

@export var itemToPickup:InventoryItem

var canPickup := false

func _unhandled_input(event):
	if ( event.is_action_pressed("interact") && canPickup ):
		GameManager.menuSystem.displayNotification(itemToPickup)
		GameManager.playerInventory.add(itemToPickup)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	canPickup = true


func _on_body_exited(body: Node2D) -> void:
	canPickup = false

func onSaveGame(saved_data:Array[PickupSavedData]):
	var myData = PickupSavedData.new()
	myData.position = global_position
	myData.scenePath = scene_file_path
	saved_data.append(myData)

func onBeforeLoadGame():
	get_parent().remove_child(self)
	queue_free()
	
func onLoadGame(savedData:PickupSavedData):
	global_position = savedData.position
