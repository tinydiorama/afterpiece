extends Area2D

@export var vaneseTalkDay1:Array[String]
@export var speechSound:AudioStream
@onready var interactionArea = $"."

@export var canTalk = false

func _unhandled_input(event):
	if ( event.is_action_pressed("interact") && canTalk ):
		if ( interactionArea.get_overlapping_bodies().size() > 0 ):
			DialogueManager.startDialogue(get_global_transform_with_canvas().get_origin(), vaneseTalkDay1, speechSound)


func _on_body_entered(body: Node2D) -> void:
	print(body)
	canTalk = true


func _on_body_exited(body: Node2D) -> void:
	canTalk = false
