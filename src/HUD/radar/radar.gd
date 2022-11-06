extends Node2D

export (Color) var lines_color := ColorN("green")
export (Color) var enemy_color := ColorN("red")
export (Color) var ramschladen_color := ColorN("cyan")
var line_width := 3
var point_radius := 6

var radar_center = Vector2(200, 200)

var radar_size = 150
var radar_range = 1080 * 5
var radar_scale = radar_range / radar_size
var pois: Array

onready var radar_fill: Polygon2D = find_node("RadarFill")
onready var radar_ray: Area2D = find_node("RadarScanner")

func _ready():
	radar_ray.find_node("CollisionShape2D").shape.length = radar_range
	var tween = create_tween().set_loops().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	tween.tween_property(radar_fill, "global_rotation", PI*2, 4)
	tween.parallel().tween_property(radar_ray, "global_rotation", PI*2, 4)
	# tween.parallel().tween_property(self, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	# tween.parallel().tween_property(self, "modulate:a", 0.8, 0.6).set_delay(0.2).from(1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	remove_child(radar_ray)
	Game.submarine.get_parent().add_child(radar_ray)
	radar_ray.global_position = Game.submarine.global_position
	

func _physics_process(delta: float) -> void:
	radar_ray.global_position = Game.submarine.global_position
	update()


func _draw():
	
	draw_arc(radar_center, 150, 0, PI*2, 100, lines_color, line_width)
	draw_arc(radar_center, 100, 0, PI*2, 100, lines_color, line_width)
	draw_arc(radar_center, 50, 0, PI*2, 100, lines_color, line_width)
	draw_arc(radar_center, point_radius, 0, PI*2, 100, lines_color, line_width)
	
	var pois_to_delete: Array
	
	for poi in pois:
		var local_position: Vector2 = poi[0]
		var color: Color = poi[1]
		var add_time = poi[2]
		var radar_position: Vector2 = local_position / radar_scale
		var fade = 1.0 -  (Time.get_ticks_msec() - add_time) / 4000.0
		if radar_position.length() <= radar_size:
			draw_circle(radar_position + radar_center, point_radius, Color(color.r, color.b, color.g, fade))
		if fade <= 0.0:
			pois_to_delete.append(poi)
			
	for poi in pois_to_delete:
		pois.erase(poi)
		


func _on_RadarScanner_body_entered(body: Node) -> void:
	var color: Color
	if body is EnemyShip:
		color = enemy_color
	if body is Ramschladen:
		color = ramschladen_color
	var local_position = body.global_position - Game.submarine.global_position
	pois.append([local_position, color, Time.get_ticks_msec()])
