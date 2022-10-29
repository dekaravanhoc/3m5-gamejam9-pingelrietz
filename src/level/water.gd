extends Node2D

var check_rect: Rect2 = Rect2(0,0,1920,1080)

	
func _process(delta):
	if not check_rect.has_point(Game.submarine.global_position):
		if Game.submarine.global_position.x < check_rect.position.x:
			global_position.x -= 1920
			check_rect.position.x -= 1920
		elif Game.submarine.global_position.x > check_rect.end.x:
			global_position.x += 1920
			check_rect.position.x += 1920
		elif Game.submarine.global_position.y < check_rect.position.y:
			global_position.y -= 1080
			check_rect.position.y -= 1080
		elif Game.submarine.global_position.y > check_rect.end.y:
			global_position.y += 1080
			check_rect.position.y += 1080


		
		

	
		
