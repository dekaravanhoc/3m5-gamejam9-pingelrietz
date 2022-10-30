class_name CustomProgressBar
extends Control

onready var progress_bar: TextureProgress = find_node("TextureProgress")

func _ready():
	pass # Replace with function body.

func set_value(value):
	progress_bar.value = value

func set_max_value(value):
	progress_bar.max_value = value
	
func set_color(color: Color):
	progress_bar.tint_progress = color
