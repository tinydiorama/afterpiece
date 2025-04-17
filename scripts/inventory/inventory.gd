class_name Inventory
extends Resource

@export var items:Array[InventorySlot]

func add(item:InventoryItem):
	var itemSlots = items.filter(func(slot): return slot && slot.item == item)
	if ( ! itemSlots.is_empty() ):
		itemSlots[0].amount += 1
	else:
		var emptySlots = items.filter(func(slot): return slot == null || slot.item == null)
		if ( ! emptySlots.is_empty() ):
			emptySlots[0].item = item
			emptySlots[0].amount = 1
