class_name QuestManager
extends Node

@export var quests:Array[Quest]

func _ready() -> void:
	GameManager.questManager = self

func enableQuestDesc(questID:int, descriptionID:int) -> void:
	quests[questID].descriptionsSeen[descriptionID] = true
