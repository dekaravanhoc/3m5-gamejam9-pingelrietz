class_name Submarine
extends Character

export (float) var rotation_speed = 5

var gold : int
var fuel : float

var forward : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	forward = Vector2.UP
	print(forward)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_input():
		var rotation_direction = get_input_direction()
		if rotation_direction != forward:
			movement_vector = rotation_direction
		else:
			movement_vector = forward
	else:
		movement_vector = Vector2.ZERO
	print(movement_vector)

func is_input():
	return Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")

func get_input_direction():
	return Vector2(
		Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left"), 
		Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	)
