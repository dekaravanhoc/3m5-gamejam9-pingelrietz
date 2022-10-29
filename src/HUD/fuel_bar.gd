extends TextureProgress


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if(Game.submarine.is_moving()):
		#calculate percentage fill of fuel tank
		self.value = (Game.submarine.current_fuel*100)/Game.submarine.max_fuel
		self.tint_progress = lerp(Color.red, Color.green, self.value/self.max_value)
