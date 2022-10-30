extends CenterContainer

signal countdown_ended
signal exit_button_pressed

var process_input: bool = false

onready var text_countdown = $VBoxContainer/TextCountDown

func _ready():
	Game.connect("game_over", self, "_start_game_over_screen")
	
	
	
func _start_game_over_screen():
	var tween: SceneTreeTween = create_tween()
	show()
	process_input = true
	
	tween.tween_property(self, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(self, "_set_countdown", ["3"])
	tween.tween_property(text_countdown, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(text_countdown, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(self, "_set_countdown", ["2"])
	tween.tween_property(text_countdown, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(text_countdown, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(self, "_set_countdown", ["1"])
	tween.tween_property(text_countdown, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(text_countdown, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(Game, "start_level")
	

func _set_countdown(text: String):
	text_countdown.text = text
	
func _input(event):
	if !process_input:
		return
		
	if event.is_pressed() and !event.is_echo():
		Game.to_main_menu()
