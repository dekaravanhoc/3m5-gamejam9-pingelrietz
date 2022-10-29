extends Node

var submarine : Submarine
var score : int = 0

func _update_score(gained_gold: int) -> void:
	score += gained_gold
	
func set_submarine(sub) -> void:
	submarine = sub
	submarine.connect("gold_gained", self, "_update_score")
	
