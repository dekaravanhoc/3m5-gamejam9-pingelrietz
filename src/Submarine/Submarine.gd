class_name Submarine
extends Character

enum States {FREE, STEAL, BUY, REFUEL}
var current_state = States.FREE

var gold : int = 0
export (float) var max_fuel: float = 100
var current_fuel : float 
export (float) var fuel_loss_rate: float = 1

export (float) var dive_speed = 1.0;

var spawn_point: Vector2

onready var wait_bar: WaitBar = find_node("WaitBar")
onready var claw: Claw = find_node("Claw")

signal fuel_changed
signal gold_gained(gains)
signal game_over

#body in range to interact with
var body

func _ready() -> void:
	Game.set_submarine(self)
	current_fuel = 50
	emit_signal("gold_gained", 0)
	spawn_point = global_position
	$Claw.connect("gold_stolen", self, "gain_gold")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#Movement
	if is_moving() and current_fuel > 0:
		current_fuel = clamp(current_fuel - fuel_loss_rate * delta, 0, max_fuel)
	#Interaction
	if current_state != States.FREE && Input.is_action_just_pressed("interact"):
		if current_state == States.STEAL && body is EnemyShip:
			claw.shoot(body, wait_bar)
		if current_state == States.BUY && body is Ramschladen && not is_moving():
			var success: bool = body.initiate_fuel_transfer(self)
			if success:
				current_state = States.REFUEL
				
	if collider and collider is EnemyShip:
		spotted()
		

func _input(event):
	# cancel refuel interaction when any input is pressed
	if current_state == States.REFUEL and event.is_pressed():
		body.stop_fuel_transfer()
		current_state = States.BUY
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
	Game.emit_signal("game_over")

func gain_gold(gains):
	gold += gains
	emit_signal("gold_gained", gains)
	

func _on_Area2D_body_entered(body: Node) -> void:
	if body is EnemyShip:
		current_state = States.STEAL
		self.body = body
	if body is Ramschladen:
		current_state = States.BUY
		self.body = body
		dive_anim(0.0) #sprite.animation = "up"

func dive_anim(target:float) -> void:
	print("diving in richtung", target)
	MusicController.play_abtauchen_sound()
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "material:shader_param/progress", target, dive_speed)


func _on_Area2D_body_exited(body: Node) -> void:
	if current_state != States.FREE:
		current_state = States.FREE
		self.body = null
		dive_anim(1.0) 
