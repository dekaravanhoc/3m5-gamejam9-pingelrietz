extends Sprite

var check_rect: Rect2 = Rect2(0,0,2016,1152)

	
func _process(delta):
	if not check_rect.has_point(Game.submarine.global_position):
		if Game.submarine.global_position.x < check_rect.position.x:
			global_position.x -= check_rect.size.x
			region_rect.position.x -= check_rect.size.x
			check_rect.position.x -= check_rect.size.x
		elif Game.submarine.global_position.x > check_rect.end.x:
			global_position.x += check_rect.size.x
			region_rect.position.x += check_rect.size.x
			check_rect.position.x += check_rect.size.x
		elif Game.submarine.global_position.y < check_rect.position.y:
			global_position.y -= check_rect.size.y
			region_rect.position.x -= check_rect.size.y
			check_rect.position.y -= check_rect.size.y
		elif Game.submarine.global_position.y > check_rect.end.y:
			global_position.y += check_rect.size.y
			region_rect.position.x += check_rect.size.y
			check_rect.position.y += check_rect.size.y

func _ready() -> void:
	material.set_shader_param("aspect_ratio", texture.get_height() / texture.get_width())

	
