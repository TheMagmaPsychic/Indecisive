extends Node3D

@onready var player_spawn: Marker3D = $PlayerSpawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
