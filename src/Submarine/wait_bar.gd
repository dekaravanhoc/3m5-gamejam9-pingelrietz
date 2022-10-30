class_name WaitBar
extends CenterContainer

signal wait_finished

onready var text: Label = find_node("WaitText")
onready var progress: ProgressBar = find_node("WaitProgress")

func _ready():
	hide()
	
func start_wait(wait_text: String, wait_time: float):
	show()
	text.text = wait_text
	
	var tween: SceneTreeTween = create_tween()
	
	tween.tween_property(self, "modulate:a", 1.0, 0.1).from(0.0)
	tween.parallel().tween_property(progress, "value", 100.0, wait_time).from(0.0)
	tween.tween_callback(self, "emit_signal", ["wait_finished"])
	tween.tween_property(self, "modulate:a", 0.0, 0.1).from(1.0)
	tween.tween_callback(self, "hide")
