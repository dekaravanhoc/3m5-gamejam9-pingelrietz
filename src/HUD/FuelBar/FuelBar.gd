extends Control

onready var progress_bar: TextureProgress = find_node("FuelBarProgress")
onready var arrow: Node2D = find_node("FuelBarArrow")

var arrow_pos_top = Vector2(-50, -185)
var arrow_pos_bottom = Vector2(-50, 140)
var arrow_distance = arrow_pos_bottom.y - arrow_pos_top.y

func _ready() -> void:
	Game.submarine.connect("fuel_changed", self, "_update_bar")

func _process(delta: float) -> void:
	if(Game.submarine.is_moving()):
		_update_bar()

func _update_bar():
	# calculate percentage fill of fuel tank
	var progress = (Game.submarine.current_fuel/Game.submarine.max_fuel) 
	progress_bar.value = progress * 100
	arrow.position = arrow_pos_bottom.move_toward(arrow_pos_top, progress * arrow_distance)
