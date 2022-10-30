extends Node

signal game_over

var submarine : Submarine
var score : int = 0
onready var main_menu = preload("res://src/MainMenu/MainMenu.tscn")

func _ready():
	connect("game_over", self, "game_over")


func _update_score(gained_gold: int) -> void:
	score += gained_gold

	
func set_submarine(sub) -> void:
	submarine = sub
	submarine.connect("gold_gained", self, "_update_score")
	
	
func game_over():
	score = 0


func start_level(scene = get_tree().current_scene):
	if scene == get_tree().current_scene:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to(scene)
	
	
func to_main_menu():
	get_tree().change_scene_to(main_menu)

