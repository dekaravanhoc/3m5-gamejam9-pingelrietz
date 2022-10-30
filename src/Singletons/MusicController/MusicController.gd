extends Node

var background_music = preload("res://assets/background-loop-melodic-techno-03-2691.mp3")
var abtauchen_sound = preload("res://assets/bubble_sound.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()

func play_abtauchen_sound():
	$MenuSounds.stream = abtauchen_sound
	$MenuSounds.play()
