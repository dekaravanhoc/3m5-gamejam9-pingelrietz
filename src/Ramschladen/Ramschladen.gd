class_name Ramschladen
extends Node2D

onready var cooldownTimer: Timer = find_node("FuelCooldownTimer")
onready var cooldownProgressBar: TextureProgress = find_node("FuelCooldownBar")

export (int) var fuel_prize: int = 10 
export (int) var fuel_refill_cooldown: int = 10 # fuel_refill_cooldown in seconds
var is_refilling: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldownTimer.connect("timeout", self, "_allow_refill")
	pass # Replace with function body.
	
func _process(delta):
	# handle fuel cooldown
	cooldownProgressBar.value = (cooldownTimer.time_left / fuel_refill_cooldown) * 100
	

func _set_refill_cooldown() -> void:
	if is_refilling:
		print("Error: buying fuel is still on cooldown")
		return
	cooldownProgressBar.visible = true
	is_refilling = true
	# add control node with progress bar to scene
	cooldownTimer.start(fuel_refill_cooldown)

func _allow_refill():
	print("stop cooldown timer")
	cooldownTimer.stop()	
	cooldownProgressBar.visible = false
	is_refilling = false

func buy_fuel(sub, fuel_amount: float):
	if is_refilling:
		print("NOPE")
		# TODO: show info for player?
		return
	if sub.current_fuel == sub.max_fuel:
		print("Sub has already full fuel")
		return
	if sub.current_fuel + fuel_amount > sub.max_fuel:
		fuel_amount = sub.max_fuel - sub.current_fuel
	var total = fuel_amount * fuel_prize
	print(sub.gold, total)
	if sub.gold < total:
		print("not enough cash cash")
		return
	sub.gold -= total
	sub.current_fuel += fuel_amount
	_set_refill_cooldown()
	# yield(get_tree().create_timer(1.0), "timeout")
	# _set_refill_cooldown(false)
		
