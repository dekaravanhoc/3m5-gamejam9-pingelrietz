extends Control

onready var scoreTextLabel = find_node("ScoreValue")
onready var goldTextLabel = find_node("GoldValue")

func _process(delta: float) -> void:
	# TODO: use signals
	var submarine = Game.submarine
	scoreTextLabel.text = str(submarine.gold)
	goldTextLabel.text = str(submarine.gold)
