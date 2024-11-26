extends Node3D

@onready var player_spawn: Marker3D = $PlayerSpawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blink()
	Global.day += 1
	setup_inn()


func setup_inn():
	match Global.day:
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass

func blink():
	var tween = create_tween()
	tween.parallel().tween_property($BlinkEffect/ColorRect, "position:y", -345, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($BlinkEffect/ColorRect2, "position:y", 666, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
