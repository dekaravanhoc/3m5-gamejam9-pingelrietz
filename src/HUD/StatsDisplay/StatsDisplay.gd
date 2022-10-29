extends Control

onready var scoreTextLabel = find_node("ScoreValue")
onready var goldTextLabel = find_node("GoldValue")

func _ready() -> void:
	Game.submarine.connect("gold_gained", self, "_update_stats")

func _update_stats(gains: int):
	print("_update_stats()")
	var submarine = Game.submarine
	scoreTextLabel.text = str(Game.score)
	goldTextLabel.text = str(submarine.gold)

