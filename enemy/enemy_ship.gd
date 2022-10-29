class_name EnemyShip
extends Character


func _ready():
	_change_movement_direction()
	

func _change_movement_direction() -> void:
	var radius_to_turn: int = randi() % 360 + 1
	var new_direction: Vector2 = ZERO_ROTATION_VECTOR.rotated(deg2rad(radius_to_turn))
	
	movement_vector = new_direction
	
	var timer: SceneTreeTimer = get_tree().create_timer(1)
	
	timer.connect("timeout", self, "_change_movement_direction")
	
	print(movement_vector)
	
	
