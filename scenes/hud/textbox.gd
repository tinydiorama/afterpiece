extends MarginContainer

@onready var label = %Label
@onready var timer = $LetterDisplayTimer
@onready var audioPlayer = $AudioStreamPlayer
@onready var nextIndicator = %NextIndicatorSprite

const maxWidth = 256

var text = ""
var letterIndex = 0
var letterTime = 0.03
var spaceTime = 0.06
var punctuationTime = 0.2

signal finished_displaying()

func _ready():
	scale = Vector2.ZERO

func displayText(textToDisplay:String, speechSFX:AudioStream):
	text = textToDisplay
	label.text = textToDisplay
	audioPlayer.stream = speechSFX
	await resized
	custom_minimum_size.x = min(size.x, maxWidth)
	if ( size.x > maxWidth ):
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	global_position.x -= size.x / 2
	global_position.y -= size.y + 40
	label.text = ""
	pivot_offset = Vector2(size.x / 2, size.y)
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		self, "scale", Vector2(1, 1), 0.15
	).set_trans( Tween.TRANS_BACK )
	displayLetter()

func displayLetter():
	label.text += text[letterIndex]
	letterIndex += 1
	
	if ( letterIndex >= text.length() ):
		finished_displaying.emit()
		nextIndicator.visible = true
		return
	match text[letterIndex]:
		"!", ".", ",", "?":
			timer.start(punctuationTime)
		" ":
			timer.start(spaceTime)
		_:
			timer.start(letterTime)
			var newAudioPlayer = audioPlayer.duplicate()
			newAudioPlayer.pitch_scale += randf_range(-0.1, 0.1)
			if ( text[letterIndex] in ["a", "e", "i", "o", "u"] ):
				newAudioPlayer.pitch_scale += 0.2
			get_tree().root.add_child( newAudioPlayer )
			newAudioPlayer.play()
			await newAudioPlayer.finished
			newAudioPlayer.queue_free()

func _on_letter_display_timer_timeout() -> void:
	displayLetter()
