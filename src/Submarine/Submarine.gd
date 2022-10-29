class_name Submarine
extends Character

enum States {FREE, STEAL, BUY}
var current_state = States.FREE

var gold : int
export (float) var max_fuel: float = 100
var current_fuel : float 
export (float) var fuel_loss_rate: float = 0.1

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
		movement_vector = get_input_direction()
		current_fuel -= fuel_loss_rate
	else:
		movement_vector = Vector2.ZERO
	#Interaction
	if current_state != States.FREE && Input.is_action_just_pressed("interact"):
		if current_state == States.STEAL && body is EnemyShip:
			gain_gold()
			print(gold)
		if current_state == States.BUY && body is Ramschladen:
			body.buy_fuel(self, max_fuel)
			print(current_fuel)
			pass

func is_moving():
	return Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")

func get_input_direction():
	return Vector2(
		Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left"), 
		Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	)

func spotted():
	print("spotted!")

func gain_gold():
	gold += body._steal()


func _on_Area2D_body_entered(body: Node) -> void:
	print("we encountered....")
	if body is EnemyShip:
		print("ship!")
		current_state = States.STEAL
		self.body = body
		pass
	if body is Ramschladen:
		print("Shop!")
		current_state = States.BUY
		self.body = body
		pass


func _on_Area2D_body_exited(body: Node) -> void:
	if current_state != States.FREE:
		current_state = States.FREE
		self.body = null
	pass # Replace with function body.
