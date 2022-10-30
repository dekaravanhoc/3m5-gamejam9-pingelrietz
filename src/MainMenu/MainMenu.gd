extends Control

onready var start_button: TextureButton = find_node("StartButton")
onready var exit_button: TextureButton = find_node("ExitButton")
onready var focus_timer: Timer = find_node("FocusTimer")
onready var focus_progress_bar: TextureProgress = find_node("StartButtonFocusProgress")

var is_start_button_focused: bool = false
var focus_animation_duration: float = 0.25

export (PackedScene) var level: PackedScene

func _ready():
	focus_timer.connect("timeout", self, "_finish_focus_animation")
	call_deferred("_set_initial_ui_focus")


func _process(delta):
	if focus_timer.time_left:
		if is_start_button_focused:
			focus_progress_bar.value = (1 - (focus_timer.time_left / focus_animation_duration)) * 100
		else:
			focus_progress_bar.value = (focus_timer.time_left / focus_animation_duration) * 100


func _set_initial_ui_focus():
	start_button.grab_focus()


func _finish_focus_animation():
	focus_timer.stop()
	if is_start_button_focused:
		focus_progress_bar.value = 100
	else:
		focus_progress_bar.value = 0
	
func _on_StartButton_pressed():
	Game.start_level(level)


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_StartButton_focus_entered():
	is_start_button_focused = true
	focus_timer.stop()
	focus_timer.start(focus_animation_duration)


func _on_StartButton_focus_exited():
	is_start_button_focused = false
	focus_timer.stop()
	focus_timer.start(focus_animation_duration)
