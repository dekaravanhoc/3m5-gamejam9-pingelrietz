class_name Scanner
extends Area2D

func _ready():
	pass

func _on_Scanner_body_entered(body):
	if body is Submarine:
		body.spotted()
