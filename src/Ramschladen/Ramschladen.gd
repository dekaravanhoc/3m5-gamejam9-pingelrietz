class_name Ramschladen
extends Node2D

export (float) var fuel_prize: int = 10 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func buy_fuel(sub, fuel_amount: float):
	# refill until full when no amount given
	#var buy_amount : float = fuel_amount or (sub.max_fuel - sub.current_fuel)
	if sub.current_fuel + fuel_amount > sub.max_fuel:
		fuel_amount = sub.max_fuel - sub.current_fuel
	var total = fuel_amount * fuel_prize
	if sub.gold < total:
		print("not enough cash cash")
		return
	sub.gold -= total
	sub.current_fuel += fuel_amount
		
