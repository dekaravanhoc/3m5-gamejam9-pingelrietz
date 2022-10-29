class_name EnemyShip
extends Character

enum States {MOVE, DIE}

export (float) var time_till_direction_change: float = 10.0
export (int, 100, 100000) var min_loot: int = 100
export (int, 100, 100000) var max_loot: int = 1000

var loot: int
var current_state = States.MOVE

onready var timer: Timer = find_node("MoveTimer")
onready var loot_label: Label = find_node("LootLabel")

func _ready():
	_change_movement_direction()
	
	loot = randi() % (max_loot - min_loot) + min_loot
	loot_label.text = "??? Gold"
	
	timer.connect("timeout", self, "_change_movement_direction")

	

func _change_movement_direction(direction: Vector2 = Vector2.ZERO) -> void:
	var new_direction: Vector2 = direction
	if direction == Vector2.ZERO:
		var radius_to_turn: int = randi() % 360 + 1
		new_direction = ZERO_ROTATION_VECTOR.rotated(deg2rad(radius_to_turn))
	
	movement_vector = new_direction
	
	timer.stop()
	timer.start(time_till_direction_change)
		
	
	timer.connect("timeout", self, "_change_movement_direction")
	

func _steal() -> int:
	if current_state == States.MOVE:
		_die()
		return loot
	return 0

func _die() -> void:
	current_state = States.DIE
	queue_free()


func _on_LootCheckOut_body_entered(body):
	loot_label.text = "%s Gold" % [loot]


func _on_LootCheckOut_body_exited(body):
	loot_label.text = "??? Gold"


func _on_OtherEnemyCheck_body_entered(body):
	var direction_to_body = body.global_position - global_position
	var new_direction = direction_to_body.rotated(PI)
	_change_movement_direction(new_direction)
