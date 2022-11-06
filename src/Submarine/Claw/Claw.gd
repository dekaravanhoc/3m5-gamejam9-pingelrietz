class_name Claw
extends Node2D

signal gold_stolen
signal retracted

export (float) var steal_time := 2.0

onready var chain = $Hook/Chain
onready var hook = $Hook
onready var hit_check = $Hook/Area2D
onready var hook_left = $Hook/HookLeft
onready var hook_right = $Hook/HookRight

var tween: SceneTreeTween

var enemy_ship
var distance


func _ready():
	Game.connect("game_over", self, "_game_over")
	hook.modulate.a = 0.0

func shoot(body, wait_bar: WaitBar) -> void:
	enemy_ship = body
	#Hook zum EnemyShip rotieren
	look_at(enemy_ship.global_position)
	distance = (enemy_ship.global_position - Game.submarine.global_position).length()
	
	if tween and tween.is_running():
		yield(tween, "finished")

	tween = get_tree().create_tween()
	tween.tween_property(hook_left, "rotation_degrees", -90.0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(hook_right, "rotation_degrees", 90.0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(hook, "position:x",distance, 0.25).from(0.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(chain, "region_rect:size:y", distance, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(self, "steal", [wait_bar])


func steal(wait_bar: WaitBar):
	if hit_check.get_overlapping_bodies().empty():
		tween.kill()
		retract()
		return
	tween = get_tree().create_tween()
	tween.tween_property(hook_left, "rotation_degrees", 30.0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(hook_right, "rotation_degrees", -30.0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	enemy_ship.pause()
	Game.submarine.pause()
	wait_bar.start_wait("stealing", steal_time)
	yield(wait_bar, "wait_finished")
	var gains = enemy_ship._steal()
	emit_signal("gold_stolen", gains)
	retract()
	

func retract() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(hook_left, "rotation_degrees", 0.0, 0.2)
	tween.parallel().tween_property(hook_right, "rotation_degrees", 0.0, 0.2)
	tween.parallel().tween_property(hook, "position:x", 0.0, 0.5).from(distance)
	tween.parallel().tween_property(chain, "region_rect:size:y", 0.0, 0.5).from(distance)
	tween.tween_callback(Game.submarine, "unpause")
	tween.tween_callback(self, "hide")
	emit_signal("retracted")


func _game_over():
	if tween and tween.is_running():
		yield(tween, "finished")
		tween.tween_property(hook_left, "rotation_degrees", 0.0, 0.1)
		tween.parallel().tween_property(hook_right, "rotation_degrees", 0.0, 0.1)
		tween.parallel().tween_property(hook, "position:x", 0.0, 0.1).from(distance)
		tween.parallel().tween_property(chain, "region_rect:size:y", 0.0, 0.1).from(distance)
		tween.tween_callback(self, "hide")
	else:
		hide()


func hide():
	if tween and tween.is_running():
		yield(tween, "finished")

	tween = get_tree().create_tween()
	tween.tween_property(hook, "modulate:a", 0.0, 0.1)


func show():
	if tween and tween.is_running():
		yield(tween, "finished")

	tween = get_tree().create_tween()
	tween.tween_property(hook, "modulate:a", 1.0, 0.1)
			


