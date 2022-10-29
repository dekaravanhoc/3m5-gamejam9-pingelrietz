class_name Submarine
extends Character


var gold : int
export (float) var max_fuel: float = 100
var current_fuel : float 
export (float) var fuel_loss_rate: float = 0.1

var forward : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	forward = Vector2.UP
	Game.submarine = self
	current_fuel = max_fuel
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_moving() and current_fuel > 0:
		movement_vector = get_input_direction()
		current_fuel -= fuel_loss_rate
	else:
		movement_vector = Vector2.ZERO

func is_moving():
	return Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")

func get_input_direction():
	return Vector2(
		Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left"), 
		Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	)

func spotted():
	print("spotted!")
