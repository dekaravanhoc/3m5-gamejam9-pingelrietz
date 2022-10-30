extends Control

onready var start_button: Button = find_node("StartButton")
onready var exit_button: Button = find_node("ExitButton")

export (PackedScene) var level: PackedScene

func _ready():
	call_deferred("_set_initial_ui_focus")


func _set_initial_ui_focus():
	start_button.grab_focus()


func _on_StartButton_pressed():
	Game.start_level(level)


func _on_ExitButton_pressed():
	get_tree().quit()
