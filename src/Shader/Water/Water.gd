extends Sprite


func calculate_aspect_ratio() -> void:
	material.set_shader_param("aspect_ratio", self.scale.y / self.scale.x);
	pass
