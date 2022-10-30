class_name Scanner
extends Area2D

func _ready():
	Game.connect("game_over", self, "pause")
	global_rotation_degrees = randi() % 360 + 1
	

func _on_Scanner_body_entered(body):
	if body is Submarine:
		body.spotted()
		

func pause() -> void:
	set_physics_process(false)
	set_process_input(false)
	
	
func unpause() -> void:
	set_physics_process(true)
	set_process_input(true)
