class_name Submarine
extends Character

enum States {FREE, CAN_STEAL, CAN_BUY, STEALING, BUYING, REFUEL}
var current_state = States.FREE

var gold : int = 0
export (int) var max_fuel: int = 100
export (int) var current_fuel : float = 100
export (float) var fuel_loss_rate: float = 3

export (float) var dive_speed = 1.0;

var spawn_point: Vector2

onready var wait_bar: WaitBar = find_node("WaitBar")
onready var claw: Claw = find_node("Claw")
onready var moving_particles = find_node("MovingParticles")

signal fuel_changed
signal gold_gained(gains)
signal gold_loss(loss)

#body in range to interact with
var body

func _ready() -> void:
	Game.set_submarine(self)
	current_fuel = 100
	emit_signal("gold_gained", 0)
	emit_signal("fuel_changed")
	spawn_point = global_position
	$Claw.connect("gold_stolen", self, "gain_gold")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#Movement
	if is_moving():
		current_fuel = clamp(float(current_fuel) - float(fuel_loss_rate) * delta, 0, max_fuel)
		emit_signal("fuel_changed")
		if !moving_particles.emitting:
			moving_particles.emitting = true
		
	else:
		if moving_particles.emitting:
			moving_particles.emitting = false
		
		if current_fuel == 0:
			if current_state == States.CAN_BUY and gold > 0:
				pass
			else:
				Game.emit_signal("game_over")
			
	if current_state == States.CAN_STEAL:
		claw.look_at(body.global_position)
				
	if collider and collider is EnemyShip:
		spotted()
		
		

func _input(event):
	_set_movement_vector()
	match current_state:
		States.FREE:
			pass
		States.CAN_STEAL:
			if Input.is_action_just_pressed("interact"):
				claw.shoot(body, wait_bar)
		States.CAN_BUY:
			if Input.is_action_just_pressed("interact"):
				var success: bool = body.initiate_fuel_transfer(self)
				if success:
					current_state = States.REFUEL
		States.REFUEL:
			if is_moving():
				body.stop_fuel_transfer()
				current_state = States.CAN_BUY
		
	
func _set_movement_vector():
	if is_controller_input() and current_fuel > 0:
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


func spotted():
	Game.emit_signal("game_over")

func gain_gold(gains):
	gold += gains
	emit_signal("gold_gained", gains)
	

func _on_Area2D_body_entered(body: Node) -> void:
	if body is EnemyShip:
		current_state = States.CAN_STEAL
		self.body = body
		claw.show()
	if body is Ramschladen:
		current_state = States.CAN_BUY
		self.body = body
		dive_anim(0.0)

func dive_anim(target:float) -> void:
	#print("diving in richtung", target)
	MusicController.play_abtauchen_sound()
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "material:shader_param/progress", target, dive_speed)


func _on_Area2D_body_exited(body: Node) -> void:
	if current_state != States.FREE:
		current_state = States.FREE
		self.body = null
		dive_anim(1.0)
		if not claw.tween or not claw.tween.is_valid():
			claw.hide()
	
func pause():
	.pause()
	current_movement_speed = 0
