class_name Submarine
extends Character

enum States {FREE, STEAL, BUY}
var current_state = States.FREE

var gold : int
export (float) var max_fuel: float = 100
var current_fuel : float 
export (float) var fuel_loss_rate: float = 1

signal fuel_change
signal gold_gained

#body in range to interact with
var body


func _ready() -> void:
	Game.submarine = self
	current_fuel = max_fuel
	gold = 100
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#Movement
	if is_moving() and current_fuel > 0:
		current_fuel = clamp(current_fuel - fuel_loss_rate * delta, 0, max_fuel)
	#Interaction
	if current_state != States.FREE && Input.is_action_just_pressed("interact"):
		if current_state == States.STEAL && body is EnemyShip:
			gain_gold()
		if current_state == States.BUY && body is Ramschladen:
			body.buy_fuel(self, max_fuel)
			emit_signal("fuel_change")
			pass

func _input(event):
	if is_controller_input():
		movement_vector = Vector2(
		Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left"), 
		Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
		)
	else:
		movement_vector = Vector2.ZERO
func is_moving():
	return movement_vector != Vector2.ZERO

func is_controller_input():
	return Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")

func get_input_direction():
	return Vector2(
		Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left"), 
		Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	)
	print( Input.get_joy_name(0))
	if Input.get_joy_name(0) == "":
		print("s")
	

func spotted():
	print("spotted!")

func gain_gold():
	var gains = body._steal()
	gold += gains
	emit_signal("gold_gained", gains)
	


func _on_Area2D_body_entered(body: Node) -> void:
	if body is EnemyShip:
		current_state = States.STEAL
		self.body = body
		pass
	if body is Ramschladen:
		current_state = States.BUY
		self.body = body
		pass


func _on_Area2D_body_exited(body: Node) -> void:
	if current_state != States.FREE:
		current_state = States.FREE
		self.body = null
	pass # Replace with function body.
