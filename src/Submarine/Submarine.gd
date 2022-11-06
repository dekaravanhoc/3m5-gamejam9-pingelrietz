class_name Submarine
extends Character

enum States {FREE, CAN_STEAL, CAN_BUY, STEALING, BUYING, REFUEL, GAME_OVER}
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
var current_target: Node2D
var possible_targets: Array

func _ready() -> void:
	Game.set_submarine(self)
	current_fuel = 100
	emit_signal("gold_gained", 0)
	emit_signal("fuel_changed")
	spawn_point = global_position
	claw.connect("gold_stolen", self, "gain_gold")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#Movement
	if _is_moving():
		current_fuel = clamp(float(current_fuel) - float(fuel_loss_rate) * delta, 0, max_fuel)
		emit_signal("fuel_changed")
	
	if current_fuel == 0:
		if current_state == States.CAN_BUY and gold > 0:
			pass
		else:
			Game.emit_signal("game_over")
			
	if current_state == States.CAN_STEAL:
		claw.look_at(current_target.global_position)
				
	if collider and collider is EnemyShip:
		spotted()
		

func spotted():
	Game.emit_signal("game_over")
	current_state = States.GAME_OVER


func gain_gold(gains):
	gold += gains
	emit_signal("gold_gained", gains)



func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		Game.to_main_menu()
	_set_movement_vector()
	match current_state:
		States.FREE:
			pass
		States.CAN_STEAL:
			if Input.is_action_just_pressed("interact"):
				_start_stealing()
		States.CAN_BUY:
			if Input.is_action_just_pressed("interact"):
				var success: bool = current_target.initiate_fuel_transfer(self)
				if success:
					current_state = States.REFUEL
		States.REFUEL:
			if _is_moving():
				current_target.stop_fuel_transfer()
				current_state = States.CAN_BUY
		
	
func _set_movement_vector():
	if _is_controller_input() and current_fuel > 0:
		if !_is_moving():
			_start_moving()
		movement_vector = Vector2(
		Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left"), 
		Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
		)
	elif _is_moving():
		_stop_moving()
		

func _start_moving():
	moving_particles.emitting = true


func _stop_moving():
	moving_particles.emitting = false
	movement_vector = Vector2.ZERO


func _start_can_steal():
	if current_state == States.CAN_STEAL:
		return
	current_state = States.CAN_STEAL
	claw.show()


func _start_stealing():
	_stop_moving()
	claw.shoot(current_target, wait_bar)
	current_state = States.STEALING
	set_process_input(false)
	claw.connect("retracted", self, "_check_status", [], CONNECT_ONESHOT)


func _start_can_buy():
	if current_state == States.CAN_BUY:
		return
	current_state = States.CAN_BUY
	dive_anim(0.0)


func _start_free():
	if current_state == States.FREE:
		return
	current_state = States.FREE
	dive_anim(1.0)
	claw.hide()
	
	
func _is_moving():
	return movement_vector != Vector2.ZERO


func _is_controller_input():
	return Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")


func _check_status():
	if current_state == States.GAME_OVER:
		return
		
	set_process_input(true)
	if current_target is EnemyShip:
		_start_can_steal()
		
	if current_target is Ramschladen:
		_start_can_buy()

	if !is_instance_valid(current_target):
		current_target == null

	if current_target == null:
		_start_free()

		
func _set_current_target():
	if current_state == States.GAME_OVER:
		return
	if possible_targets.empty():
		current_target = null
		_check_status()
		return

	current_target = possible_targets.pop_front()
	_check_status()


func _on_Area2D_body_entered(body: Node) -> void:
	if current_state == States.GAME_OVER:
		return
	possible_targets.append(body)
	_set_current_target()


func dive_anim(target:float) -> void:
	#print("diving in richtung", target)
	MusicController.play_abtauchen_sound()
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "material:shader_param/progress", target, dive_speed)


func _on_Area2D_body_exited(body: Node) -> void:
	if current_state == States.GAME_OVER:
		return
	possible_targets.erase(body)
	if current_target == body:
		current_target = null
	_set_current_target()

	
func pause():
	.pause()
	_stop_moving()
	current_movement_speed = 0
