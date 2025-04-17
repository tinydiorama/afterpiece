extends Area2D

@export var lines:Array[String]
@export var speechSound:AudioStream
@onready var interactionArea = $"."

func _unhandled_input(event):
	if ( event.is_action_pressed("interact") ):
		if ( interactionArea.get_overlapping_bodies().size() > 0 ):
			DialogueManager.startDialogue(get_global_transform_with_canvas().get_origin(), lines, speechSound)
