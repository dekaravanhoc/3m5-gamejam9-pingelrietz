class_name ScannerLookOut
extends Scanner

export (int, 1, 360) var rotation_speed_in_seconds: int = 10
export (Color) var color: Color = ColorN("green")

onready var scan_area_draw: Polygon2D = find_node("ScanAreaDraw")
onready var collision_polygon: CollisionPolygon2D = find_node("CollisionPolygon2D")

func _ready():
	var tween: SceneTreeTween = create_tween().chain().set_loops()
	
	tween.tween_property(scan_area_draw, "color:a", 0.1, 3).from(0.3)
	tween.tween_property(scan_area_draw, "color:a", 0.3, 3).from(0.1)


func _physics_process(delta):
	
	global_rotation = global_rotation + deg2rad(rotation_speed_in_seconds) * delta



