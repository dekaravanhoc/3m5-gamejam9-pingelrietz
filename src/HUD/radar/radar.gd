extends Node2D

export (Color) var lines_color := ColorN("green")
export (Color) var enemy_color := ColorN("red")
export (Color) var ramschladen_color := ColorN("cyan")
var line_width := 3
var point_radius := 6

var radar_center = Vector2(200, 200)

var radar_size = 150
var radar_range = 1080 * 3
var radar_scale = radar_range / radar_size

onready var radar_fill: Polygon2D = find_node("RadarFill")

func _ready():
	var tween = create_tween().set_loops()
	
	
	
	tween.tween_property(radar_fill, "global_rotation", PI*2, 4)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(self, "modulate:a", 0.8, 0.6).set_delay(0.2).from(1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _draw():
	
	draw_arc(radar_center, 150, 0, PI*2, 100, lines_color, line_width)
	draw_arc(radar_center, 100, 0, PI*2, 100, lines_color, line_width)
	draw_arc(radar_center, 50, 0, PI*2, 100, lines_color, line_width)
	draw_arc(radar_center, point_radius, 0, PI*2, 100, lines_color, line_width)
	
	var pois := get_tree().get_nodes_in_group("poi")
		
	for poi in pois:
		var local_position: Vector2 = poi.global_position - Game.submarine.global_position
		var radar_position: Vector2 = local_position / radar_scale
		var color = lines_color
		if poi is EnemyShip:
			color = enemy_color
		if poi is Ramschladen:
			color = ramschladen_color
		if radar_position.length() <= radar_size:
			draw_circle(radar_position + radar_center, point_radius, color)

func _on_PingTimer_timeout():
	update()
	
