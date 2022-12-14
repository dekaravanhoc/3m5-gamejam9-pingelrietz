extends Control

onready var scoreTextLabel = find_node("ScoreValue")
onready var goldTextLabel = find_node("GoldValue")

func _ready() -> void:
	Game.submarine.connect("gold_gained", self, "_update_stats")
	Game.submarine.connect("gold_loss", self, "_update_stats")
	
func _update_gold():
	_update_stats()

func _update_stats(gains: int = 0):
	var submarine = Game.submarine
	
	var current_score := int(scoreTextLabel.text)
	var current_gold := int(goldTextLabel.text)
	
	var tween: SceneTreeTween = get_tree().create_tween().set_parallel(true)
	
	tween.tween_method(self, "_set_score", current_score, Game.score, 1)
	tween.tween_method(self, "_set_gold", current_gold, submarine.gold, 1)
	
	
func _set_score(score: int):
	scoreTextLabel.text = str(score)

func _set_gold(gold: int):
	goldTextLabel.text = str(gold)
	
	

