class_name Ramschladen
extends Node2D

export (float) var fuel_prize: int = 10 
var player_in_range : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _on_Area2D_body_entered(body):
	if body is Submarine:
		print(body.name + " entered shop area")
		player_in_range = true

func _on_Area2D_body_exited(body):
	if body is Submarine:
		print(body.name + " left shop area")
		player_in_range = false

func buy_fuel(sub: Submarine, fuel_amount: float):
	# TODO: check if sub is in range
	if not player_in_range:
		return
	# refill until full when no amount given
	var buy_amount : float = fuel_amount or (sub.max_fuel - sub.current_fuel)
	var total = buy_amount * fuel_prize
	if sub.money < total:
		# not enough cash cash
		return
	sub.money -= total
	sub.current_fuel += buy_amount
		
