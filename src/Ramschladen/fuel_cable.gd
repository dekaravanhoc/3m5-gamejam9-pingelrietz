class_name FuelCable
extends Sprite

export (float) var attach_time:= 0.2
export (float) var pump_tick := 1.0

onready var cable: Sprite = $Cable
onready var end: Sprite = $End
onready var pump: Sprite = $Pump

var tween: SceneTreeTween

func _ready():
	pass
	
func attach(sub: Node2D):
	look_at(sub.global_position)
	end.global_position = sub.global_position
	var cable_length = end.position.length()
	
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(cable, "region_rect:size:y", cable_length, attach_time)
	tween.tween_callback(self, "_run_fill")
	
	end.show()
	
	
func deattach():
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(cable, "region_rect:size:y", 0.0, attach_time)
	
	pump.hide()
	end.hide()
	pump.position = Vector2.ZERO
	end.position = Vector2.ZERO
	
	
func _run_fill():
	if tween and tween.is_valid():
		tween.kill()
	pump.show()
	
	var target_global_position = end.global_position
	var start_position = pump.global_position
	tween = create_tween().set_loops()
	tween.tween_property(pump, "global_position", target_global_position, pump_tick).from(start_position)

