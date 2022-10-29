class_name Character
extends KinematicBody2D

const ZERO_ROTATION_VECTOR: Vector2 = Vector2.UP

export (int) var max_speed: int = 100
export (int) var acceleration: int = 10

var movement_vector: Vector2 = Vector2.ZERO
var current_movement: Vector2 = Vector2.ZERO

onready var sprite: Node2D = find_node("Sprite")


func _ready():
	pass


func _physics_process(delta):
	
	movement_vector = movement_vector.normalized()
	
	current_movement = movement_vector * max_speed * delta
	
	move_and_collide(current_movement)
	
	
	
	
