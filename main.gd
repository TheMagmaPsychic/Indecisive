extends Node3D

var levels_dict: Dictionary = {
	"inn":preload("res://levels/inn.tscn"),
	"dream1":preload("res://levels/dream1.tscn"),
	"dream2":preload("res://levels/dream2.tscn"),
	"dream3":preload("res://levels/dream3.tscn"),
	"dream4":preload("res://levels/dream4.tscn"),
	"dream5":preload("res://levels/dream5.tscn")
}
var cur_level_instance: Node3D
@onready var level_holder: Node = $LevelHolder


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SignalBus.player_move_request.connect(_on_player_move_request)
	SignalBus.level_end.connect(_on_level_end)
	load_level("dream1")

func load_level(level_name: StringName) -> void:
	cur_level_instance = levels_dict[level_name].instantiate()
	level_holder.add_child(cur_level_instance)


func unload_level():
	if cur_level_instance:
		cur_level_instance.queue_free()
	

func _on_player_move_request(new_position: Vector3, new_rotation: Vector3) -> void:
	pass#player.global_position = new_position
	#player.global_rotation = new_rotation


func _on_level_end(next_scene: StringName, sanity_change: int, knowledge_change: int):
	#play transition
	unload_level()
	load_level(next_scene)
