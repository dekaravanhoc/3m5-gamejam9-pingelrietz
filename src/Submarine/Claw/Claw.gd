class_name Claw
extends Node2D

signal gold_stolen

export (float) var steal_time := 2.0

onready var chain = $Hook/Chain
onready var hook = $Hook
onready var hit_check = $Hook/Area2D

var tween: SceneTreeTween

var enemy_ship
var distance


func _ready():
	Game.connect("game_over", self, "retract")
	hide()

func shoot(body, wait_bar: WaitBar) -> void:
	show()
	enemy_ship = body
	#Hook zum EnemyShip rotieren
	look_at(enemy_ship.global_position)
	distance = (enemy_ship.global_position - Game.submarine.global_position).length()
	
	if tween and tween.is_valid():
		tween.kill()

	tween = get_tree().create_tween()
	tween.tween_property(hook, "position:x",distance, 0.25).from(0.0)
	tween.parallel().tween_property(chain, "region_rect:size:y", distance, 0.25)
	
	tween.tween_callback(self, "steal", [wait_bar])
	tween.tween_interval(steal_time)

	tween.tween_callback(self, "retract")
	

func steal(wait_bar: WaitBar):
	if hit_check.get_overlapping_bodies().empty():
		tween.kill()
		retract()
		return
	enemy_ship.pause()
	Game.submarine.pause()
	wait_bar.start_wait("stealing", steal_time)
	yield(wait_bar, "wait_finished")
	var gains = enemy_ship._steal()
	emit_signal("gold_stolen", gains)
	

func retract() -> void:
	if tween and tween.is_valid():
		tween.kill()
	else:
		return
	tween = get_tree().create_tween()
	tween.tween_property(hook, "position:x", 0.0, 0.5).from(distance)
	tween.parallel().tween_property(chain, "region_rect:size:y", 0.0, 0.5).from(distance)
	tween.tween_callback(self, "hide")
	tween.tween_callback(Game.submarine, "unpause")
	hide()


