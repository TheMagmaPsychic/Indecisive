extends CanvasLayer

@export var audio_bus_name := "Master"

@onready var _bus := AudioServer.get_bus_index(audio_bus_name)

@export var credits: PackedScene

func _ready():
	AudioServer.set_bus_volume_db(_bus, linear_to_db($PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/MusicSlider.value))

func _process(_delta):
	pass

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))

func _on_effects_slider_value_changed(_value):
	pass # Replace with function body.

func _on_start_pressed():
	print("here")
	get_tree().change_scene_to_file("res://main.tscn")


func _on_credits_pressed():
	var instance = credits.instantiate()
	add_child(instance)
