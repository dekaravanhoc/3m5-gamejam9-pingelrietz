class_name Ramschladen
extends Node2D

onready var transferTimer: Timer = find_node("FuelTransferTimer")
onready var cooldownTimer: Timer = find_node("FuelCooldownTimer")
onready var cooldownProgressBar: TextureProgress = find_node("FuelCooldownBar")
onready var fuel_amount_label: RichTextLabel = find_node("FuelAmountLabel")

export (int) var fuel_prize: int = 10 
export (float) var fuel_refill_cooldown: float = 10 # in seconds
export (float) var fuel_transfer_interval: float = 10 # in seconds
export (float) var fuel_per_transfer: float = 1
export (float) var max_stored_fuel: float = 20
export (float) var current_stored_fuel: float = 20

var sub = null
var is_refilling: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transferTimer.connect("timeout", self, "_transfer_fuel")
	cooldownTimer.connect("timeout", self, "_allow_refill")
	fuel_amount_label.text = str(current_stored_fuel)
	cooldownProgressBar.visible = false

func _process(delta):
	# handle fuel cooldown
	if cooldownTimer.time_left != 0:
		var ratio = (cooldownTimer.time_left / fuel_refill_cooldown)
		cooldownProgressBar.value = ratio * 100
		current_stored_fuel = (1 - ratio) * max_stored_fuel
		fuel_amount_label.text = str(int(current_stored_fuel))
		print(current_stored_fuel)

	
func _set_refill_cooldown() -> void:
	if is_refilling:
		print("Error: buying fuel is still on cooldown")
		return
	cooldownProgressBar.visible = true
	is_refilling = true
	# add control node with progress bar to scene
	cooldownTimer.start(fuel_refill_cooldown)

func _allow_refill():
	cooldownTimer.stop()	
	cooldownProgressBar.visible = false
	current_stored_fuel = max_stored_fuel
	fuel_amount_label.text = str(current_stored_fuel)
	is_refilling = false
	
func initiate_fuel_transfer(sub):
	if is_refilling:
		print("NOPE")
		return
	if sub.current_fuel == sub.max_fuel:
		print("Sub has already full fuel")
		return
	self.sub = sub
	# start timer that transfers fuel, you pay per transfer
#	transferTimer.start(fuel_transfer_interval)
	transferTimer.start(0.5)
	
func stop_fuel_transfer():
	transferTimer.stop()
	if current_stored_fuel <= 0.01:
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
	fuel_amount_label.text = str(current_stored_fuel)
	sub.emit_signal("fuel_changed")
