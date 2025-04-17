extends Node

#saving
var saverLoader:SaverLoader
#story
var storyManager:StoryManager
var questManager:QuestManager

#level loading
var levelLoader # this is just in case we ever actually want to switch a whole scene
var masterLevelController

#time
var time:float = 0.0
var pastHour:float = -1.0
const minsPerDay = 1440
const minsPerHour = 60
const ingameToRealMinsDuration = (2 * PI) / minsPerDay
const ingameSpeed = 3.0
const initialHour = 6
var timePassing = false

#inventory
var playerInventory = preload("res://scripts/inventory/inventories/playerInventory.tres")

#menus
var menuSystem:MenuSystem

signal time_tick(day:int, hour:int, minute:int)

@export var viewportContainer:SubViewport

func _ready() -> void:
	randomize()
	time = ingameToRealMinsDuration * initialHour * minsPerHour
	saverLoader = SaverLoader.new()
	storyManager = StoryManager.new()
	# load the game
	saverLoader.loadGame()

func _process(delta: float) -> void:
	if ( timePassing ):
		time += delta * ingameToRealMinsDuration * ingameSpeed
		recalculateTime()

func recalculateTime() -> void:
	var totalMins = int(time / ingameToRealMinsDuration)
	var day = int(totalMins / minsPerDay)
	var currentDayMins = totalMins % minsPerDay
	var hour = int(currentDayMins / minsPerHour)
	var minute = int(currentDayMins % minsPerHour)
	
	if ( pastHour != hour ):
		pastHour = hour
		time_tick.emit(day, hour, minute)
