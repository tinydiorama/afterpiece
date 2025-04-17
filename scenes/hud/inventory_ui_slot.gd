extends Panel

@onready var itemUI:TextureRect = $Item
@onready var selectedUI:TextureRect = $Selected
@onready var numUI:Label = $Num

var itemStored:InventorySlot
var selected:bool = false

func updateItem(slot:InventorySlot):
	itemStored = slot
	if ( ! slot ):
		itemUI.visible = false
		numUI.visible = false
	else:
		itemUI.visible = true
		itemUI.texture = slot.item.texture
		if ( slot.amount > 1 ):
			numUI.visible = true
			numUI.text = str(slot.amount)

func select():
	selected = true
	selectedUI.visible = true

func deselect():
	selected = false
	selectedUI.visible = false
