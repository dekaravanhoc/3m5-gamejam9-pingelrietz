extends TextureRect



func _ready():
	texture = find_node("Viewport", false, false).get_texture()
