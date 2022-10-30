class_name Ramschladen
extends Node2D

onready var transfer_timer: Timer = find_node("FuelTransferTimer")
onready var cooldown_timer: Timer = find_node("FuelCooldownTimer")
onready var fuel_bar: TextureProgress = find_node("FuelBar")

export (int) var fuel_prize: int = 10 
export (float) var fuel_refill_cooldown: float = 10 # in seconds
export (float) var fuel_transfer_interval: float = 1 # in seconds
export (float) var fuel_per_transfer: float = 1
export (float) var max_stored_fuel: float = 20
export (float) var current_stored_fuel: float = 20

var sub = null
var is_refilling: bool = false

func _ready() -> void:
	transfer_timer.connect("timeout", self, "_transfer_fuel")
	cooldown_timer.connect("timeout", self, "_allow_refill")
	fuel_bar.max_value = max_stored_fuel

func _process(delta):
	# handle fuel cooldown
	if cooldown_timer.time_left != 0:
		var ratio = 1 - (cooldown_timer.time_left / fuel_refill_cooldown)
		current_stored_fuel = ratio * max_stored_fuel
		fuel_bar.value = current_stored_fuel
	
func _set_refill_cooldown(x: float = 1) -> void:
	print(x)
	print(fuel_refill_cooldown)
	print(fuel_refill_cooldown * x)
	if is_refilling:
		print("Error: buying fuel is still on cooldown")
		return
	is_refilling = true
	fuel_bar.tint_progress = Color.gray
	var cooldown = fuel_refill_cooldown * (1 - (current_stored_fuel / max_stored_fuel))
	cooldown_timer.start(cooldown)

func _allow_refill():
	cooldown_timer.stop()	
	current_stored_fuel = max_stored_fuel
	is_refilling = false
	fuel_bar.tint_progress = Color.green
	
func initiate_fuel_transfer(sub) -> bool:
	if is_refilling:
		print("NOPE")
		return false
	if sub.current_fuel == sub.max_fuel:
		print("Sub has already full fuel")
		return false
	self.sub = sub
	# start timer that transfers fuel, you pay per transfer
	transfer_timer.start(fuel_transfer_interval)
	return true
	
func stop_fuel_transfer():
	transfer_timer.stop()
	_set_refill_cooldown()

func _transfer_fuel():
	# exist trasfer when: user input OR full fuel OR not enough gold
	if current_stored_fuel == 0 or sub.current_fuel == sub.max_fuel:
		stop_fuel_transfer()
	var amount = fuel_per_transfer
	if sub.current_fuel + amount > sub.max_fuel:
		amount = sub.max_fuel - sub.current_fuel
	if current_stored_fuel < amount:
		amount = current_stored_fuel
	var price = amount * fuel_prize
	if sub.gold < price:
		stop_fuel_transfer()
		return
	print("transfer fuel: ", amount)
	sub.gold -= price
	sub.current_fuel += amount
	current_stored_fuel -= amount
	fuel_bar.value = current_stored_fuel
	sub.emit_signal("fuel_changed")
