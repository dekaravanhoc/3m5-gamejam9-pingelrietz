extends Control

onready var scoreTextLabel = find_node("ScoreValue")
onready var goldTextLabel = find_node("GoldValue")

func _ready() -> void:
	Game.submarine.connect("gold_gained", self, "_update_stats")
	Game.submarine.connect("fuel_changed", self, "_update_gold")
	
func _update_gold():
	_update_stats()

func _update_stats(gains: int = 0):
	var submarine = Game.submarine
	scoreTextLabel.text = str(Game.score)
	goldTextLabel.text = str(submarine.gold)

