class_name MenuSystem
extends CanvasLayer

@onready var overlay = $Overlay

#quest stuff

#inventory stuff
@onready var inventoryUI = $InventoryUI
@onready var inventoryGrid = %InventoryGrid
@onready var inventorySlotUI = preload("res://scenes/hud/inventory_ui_slot.tscn")
@onready var itemNameUI = %ItemName
@onready var itemDescUI = %ItemDesc
@onready var inventoryNotificationUI = preload("res://scenes/hud/notification.tscn")
@onready var notificationContainer = %NotificationContainer

var isInventoryOpen := false
var selectedInvId := 0
var currentInventoryUISlots:Array

func _ready() -> void:
	GameManager.menuSystem = self
	closeInventory()
	
func closeInventory() -> void:
	GameManager.timePassing = true
	inventoryUI.visible = false
	overlay.visible = false
	isInventoryOpen = false
	for slot in inventoryGrid.get_children():
		inventoryGrid.remove_child(slot)
		slot.queue_free() 
	currentInventoryUISlots.clear()
	
func openInventory() -> void:
	GameManager.timePassing = false
	inventoryUI.visible = true
	overlay.visible = true
	isInventoryOpen = true
	var i = 0
	for inventoryItem in GameManager.playerInventory.items:
		var inventorySlot = inventorySlotUI.instantiate()
		inventoryGrid.add_child(inventorySlot)
		inventorySlot.updateItem(inventoryItem)
		currentInventoryUISlots.append(inventorySlot)
		if ( i == 0 ):
			inventorySlot.select()
			selectedInvId = 0
		i += 1
	displayInventoryItemInfo()
	
func _unhandled_input(event: InputEvent) -> void:
	if ( Input.is_action_just_pressed("menu_open") && ! isInventoryOpen ):
		openInventory()
	elif ( Input.is_action_just_pressed("menu_close") && isInventoryOpen ):
		closeInventory()
	if ( isInventoryOpen ):
		#inventory is open so we can select
		if ( Input.is_action_just_pressed("move_left") ):
			currentInventoryUISlots[selectedInvId].deselect()
			selectedInvId -= 1
			if ( selectedInvId < 0 ):
				selectedInvId = currentInventoryUISlots.size() - 1
			currentInventoryUISlots[selectedInvId].select()
		if ( Input.is_action_just_pressed("move_right") ):
			currentInventoryUISlots[selectedInvId].deselect()
			selectedInvId += 1
			if ( selectedInvId > currentInventoryUISlots.size() - 1 ):
				selectedInvId = 0
			currentInventoryUISlots[selectedInvId].select()
		displayInventoryItemInfo()
			
func displayInventoryItemInfo():
	var currentItem = currentInventoryUISlots[selectedInvId].itemStored
	if ( currentItem ):
		itemNameUI.text = currentItem.item.name
		itemDescUI.text = currentItem.item.description
	else:
		itemNameUI.text = ""
		itemDescUI.text = ""

func displayNotification(item:InventoryItem) -> void:
	var notification = inventoryNotificationUI.instantiate()
	notificationContainer.add_child(notification)
	notification.addNotification(item)
