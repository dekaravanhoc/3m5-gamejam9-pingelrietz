class_name EnemyShip
extends Character

enum States {MOVE, DIE}

export (float) var time_till_direction_change: float = 10.0
export (int, 100, 100000) var min_loot: int = 100
export (int, 100, 100000) var max_loot: int = 1000
export (float) var sink_speed: float = 3.0
export (PackedScene) var scanner_scene: PackedScene

var loot: int
var current_state = States.MOVE
var spawn_point: Vector2 = Vector2.ZERO
var scanner: Area2D

onready var timer: Timer = find_node("MoveTimer")
onready var loot_label: Label = find_node("LootLabel")
onready var spawn_check: Area2D = find_node("SpawnCheck")
onready var moving_particles: Particles2D = find_node("MovingParticles")

func _ready():
	scanner = scanner_scene.instance()
	add_child(scanner)
	timer.connect("timeout", self, "_change_movement_direction")
	spawn_point = global_position
	hide()
	scanner.monitoring = false
	_spawn()
	

func _spawn() -> void:
	_set_spawn_point()
	yield(get_tree(),"physics_frame")
	yield(get_tree(),"idle_frame")
	if !spawn_check.get_overlapping_bodies().empty():
		var timer: SceneTreeTimer = get_tree().create_timer(3)
		timer.connect("timeout", self, "_spawn")
		return
	scanner.visible = true
	scanner.monitoring = true
	shape.disabled = false
	_change_movement_direction()
	_reset_shader_params()
	sprite.modulate.a = 1.0
	sprite.scale = Vector2(1,1)
	loot = randi() % (max_loot - min_loot) + min_loot
	loot_label.text = "??? Gold"
	add_to_group("poi")
	current_state = States.MOVE
	show()
	

func _set_spawn_point() -> void:
	global_position = spawn_point
	

func _change_movement_direction(direction: Vector2 = Vector2.ZERO) -> void:
	var new_direction: Vector2 = direction
	if direction == Vector2.ZERO:
		var radius_to_turn: int = randi() % 360 + 1
		new_direction = ZERO_ROTATION_VECTOR.rotated(deg2rad(radius_to_turn))
	
	movement_vector = new_direction
	
	timer.stop()
	timer.start(time_till_direction_change)
		

func _steal() -> int:
	if current_state == States.MOVE:
		_die()
		return loot
	return 0


func _die() -> void:
	loot_label.get_parent().hide()
	current_state = States.DIE
	remove_from_group("poi")
	scanner.monitoring = false
	shape.disabled = true
	moving_particles.emitting = false
	_sink()
	
	
func _sink() -> void:
	sprite.material.set_shader_param("is_sinking", true);
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "material:shader_param/progress", 1.0, sink_speed)
	tween.tween_property(sprite, "modulate:a", 0.0, sink_speed)
	tween.parallel().tween_property(sprite, "scale", Vector2(0.5, 0.5), sink_speed)
	tween.tween_callback(self, "hide")
	tween.tween_callback(self, "_spawn")
	tween.tween_callback(self, "_reset_movement")
	scanner.visible = false
	

func _reset_shader_params() -> void:
	sprite.material.set_shader_param("is_sinking", false);
	sprite.material.set_shader_param("progress", 0.0);

func pause() -> void:
	scanner.set_deferred("monitoring", false)
	moving_particles.emitting = false
	.pause()
	
func unpause() -> void:
	scanner.set_deferred("monitoring", true)
	moving_particles.emitting = true
	.pause()
	

func _on_LootCheckOut_body_entered(body):
	loot_label.text = "%s Gold" % [loot]


func _on_LootCheckOut_body_exited(body):
	loot_label.text = "??? Gold"


func _on_OtherEnemyCheck_body_entered(body):
	var direction_to_body = body.global_position - global_position
	var new_direction = direction_to_body.rotated(PI)
	_change_movement_direction(new_direction)

