class_name Character
extends KinematicBody2D

const ZERO_ROTATION_VECTOR: Vector2 = Vector2.UP

export (int) var max_speed: int = 100
export (float) var acceleration: float = 0.5
export (int) var rotation_speed: int = 30

var movement_vector: Vector2 = Vector2.ZERO
var current_movement_vector: Vector2 = Vector2.ZERO

onready var sprite: Node2D = find_node("Sprite")


func _ready():
	pass


func _physics_process(delta):
	
	movement_vector = movement_vector.normalized()
	current_movement_vector = current_movement_vector.normalized()
	
	if movement_vector == Vector2.ZERO:
		current_movement_vector == Vector2.ZERO
	
	elif current_movement_vector == Vector2.ZERO:
		current_movement_vector = movement_vector * max_speed * delta
	
	else:
	
		var rotation_to_target_movement = sign(current_movement_vector.angle_to(movement_vector))
		var rotation_increment = deg2rad(rotation_to_target_movement * rotation_speed * delta)
		current_movement_vector = current_movement_vector * max_speed * delta
		current_movement_vector = current_movement_vector.rotated(rotation_increment)
	
	move_and_collide(current_movement_vector)
	
	var sprite_rotation: float = ZERO_ROTATION_VECTOR.angle_to(current_movement_vector)
	
	sprite.global_rotation = sprite_rotation
	
	
	
	
