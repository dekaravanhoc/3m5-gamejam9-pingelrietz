extends Node2D

onready var chain = $Hook/Chain
var direction := Vector2(0,0)
var claw_pos := Vector2(0,0) #extra position for claw to not mess with player pos in relation

var enemy_ship

export (float) var speed = 2;

var flying := false
var hooked := false
var retracting := false

signal gold_stolen

func shoot(dir: Vector2, body) -> void:
	direction = dir.normalized()
	flying = true
	claw_pos = self.global_position
	enemy_ship = body
	claw_pos = $Hook.global_position
	var claw_pos_local = to_local(claw_pos)
	#Hook zum EnemyShip rotieren
	look_at(enemy_ship.global_position)
	var distance = (enemy_ship.global_position - Game.submarine.global_position).length()
	#chain.position = claw_pos_local
	#Tweens for animation
	var tween = get_tree().create_tween()
	tween.tween_property($Hook, "position:x",distance, 0.25).from(0.0)
	#tween.parallel().tween_property(chain, "global_position", enemy_ship.global_position, 0.25)
	tween.parallel().tween_property(chain, "region_rect:size:y", distance, 0.25)
	
	tween.tween_callback(self, "steal")
	#tween von hook zu playership
	
	tween.tween_property($Hook, "position:x", 0.0, 0.5).from(distance)
	tween.parallel().tween_property(chain, "region_rect:size:y", 0.0, 0.5).from(distance)
	
	#tween.parallel().tween_property(chain, "global_position", Game.submarine.global_position, 0.5)
	#tween callball method Steal() loot saved in return var 
	tween.tween_callback(self, "retract")
	

func steal():
	var gains = enemy_ship._steal()
	emit_signal("gold_stolen", gains)
	enemy_ship.pause()
	Game.submarine.pause()
	

func retract() -> void:
	enemy_ship.unpause()
	Game.submarine.unpause()
	


func release() -> void:
	flying = false
	hooked = false
	retracting = true

func _process(_delta: float) -> void:
	self.visible = flying or hooked or retracting
	if !self.visible:
		return
	#Tween von Hook hin zu enemyhsip
#	if !retracting:
#		chain.region_rect.size.y = claw_pos_local.length()
#	else:
#		retract()
		
	

#func _physics_process(delta: float) -> void:
#	if flying:
#		claw_pos = lerp(claw_pos, enemy_ship.global_position, delta * speed)
#	if retracting:
#		if(claw_pos.x <= Game.submarine.global_position.x + 5.0 and claw_pos.x >= Game.submarine.global_position.x - 5.0
#		and claw_pos.y <= Game.submarine.global_position.y + 5.0 and claw_pos.y >= Game.submarine.global_position.y - 5.0):
#			retracting = false
#			hooked = false
#			print("claw in ship")
#			return
#		claw_pos = lerp(claw_pos, Game.submarine.global_position, delta * speed)
#
#
#		#enemy_ship._die()
#		#release()
#	#if retracting:
#	#	$Hook.move_and_collide(-direction * speed)
#		#retracting = false
#	#claw_pos = $Hook.global_position


func _on_Area2D_body_entered(body: Node) -> void:
	if body is EnemyShip:
		hooked = true
		flying = false
		#Pause Submarine
		#siphon gold 
		#after enough gold
		retracting = true

