class_name Character
extends KinematicBody2D

const ZERO_ROTATION_VECTOR: Vector2 = Vector2.UP

export (int) var max_speed: int = 100
export (int) var acceleration: float = 30
export (int) var rotation_speed: int = 30

var movement_vector: Vector2 = Vector2.ZERO
var current_movement_vector: Vector2 = Vector2.UP
var current_movement_speed: float = 0.0

var collider: KinematicBody2D

onready var sprite: Node2D = find_node("Sprite")
onready var shape = $CollisionShape2D


func _ready():
	Game.connect("game_over", self, "pause")


func _physics_process(delta):
	
	movement_vector = movement_vector.normalized()
	current_movement_vector = current_movement_vector.normalized()
	
	var final_movement_vector: Vector2 = Vector2.ZERO
	
	if movement_vector == Vector2.ZERO:
		current_movement_speed = clamp(current_movement_speed - acceleration * delta, 0, max_speed)
	
	else:
		current_movement_speed = clamp(current_movement_speed + acceleration * delta, 0, max_speed)
		var rotation_to_target_movement = sign(current_movement_vector.angle_to(movement_vector))
		var rotation_increment = deg2rad(rotation_to_target_movement * rotation_speed * delta)
		current_movement_vector = current_movement_vector.rotated(rotation_increment)
	
	final_movement_vector = current_movement_vector * current_movement_speed * delta
		
	
	var collision_object =  move_and_collide(final_movement_vector)
	if collision_object:
		collider = collision_object.collider
	
	var sprite_rotation: float = ZERO_ROTATION_VECTOR.angle_to(current_movement_vector)
	
	sprite.global_rotation = sprite_rotation
	shape.global_rotation = sprite_rotation
	
	
func pause() -> void:
	set_physics_process(false)
	set_process_input(false)
	
	
func unpause() -> void:
	set_physics_process(true)
	set_process_input(true)
	
	
func _reset_movement():
	current_movement_speed = 0
	current_movement_vector = Vector2.UP
	sprite.global_rotation = 0
	shape.global_rotation = 0
	
	
	
	
