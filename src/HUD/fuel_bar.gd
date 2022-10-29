extends TextureProgress

onready var submarine = Game.submarine

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if(submarine.is_moving()):
		#calculate percentage fill of fuel tank
		self.value = (submarine.current_fuel*100)/submarine.max_fuel
		self.tint_progress = lerp(Color.red, Color.green, self.value/self.max_value)
