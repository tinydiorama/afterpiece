extends Node

@onready var textBoxScene = preload("res://scenes/hud/textbox.tscn")

var dialogueLines:Array[String] = []
var currentLineIndex = 0

var textBox
var textBoxPos:Vector2

var sfx:AudioStream

var isDialogueActive = false
var canAdvanceLine = false

func startDialogue(position:Vector2, lines:Array[String], speechSFX:AudioStream):
	if ( isDialogueActive ):
		return
	
	dialogueLines = lines
	textBoxPos = position
	sfx = speechSFX
	showTextBox()
	isDialogueActive = true
	GameManager.timePassing = false

func showTextBox():
	textBox = textBoxScene.instantiate()
	textBox.finished_displaying.connect(onTextBoxFinishedDisplaying)
	get_tree().root.add_child(textBox)
	var currentViewport = GameManager.viewportContainer
	
	textBox.global_position = textBoxPos * Vector2( 3.6, 3.6 )
	textBox.displayText(dialogueLines[currentLineIndex], sfx)
	canAdvanceLine = false
	
func onTextBoxFinishedDisplaying():
	canAdvanceLine = true
	
func _unhandled_input(event):
	if ( event.is_action_pressed("interact") && isDialogueActive && canAdvanceLine ):
		textBox.queue_free()
		currentLineIndex += 1
		if ( currentLineIndex >= dialogueLines.size() ):
			isDialogueActive = false
			GameManager.timePassing = true
			currentLineIndex = 0
			return
		showTextBox()
