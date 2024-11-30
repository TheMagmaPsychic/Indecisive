extends CanvasLayer

@export var audio_bus_name := "Voice"

@onready var _bus := AudioServer.get_bus_index(audio_bus_name)
@onready var music_bus := AudioServer.get_bus_index("Music")
@onready var volum_bus := AudioServer.get_bus_index("Voice")

@export var credits: PackedScene

func _ready():
	AudioServer.set_bus_volume_db(music_bus, linear_to_db($PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/MusicSlider.value))
	AudioServer.set_bus_volume_db(volum_bus, linear_to_db($PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/VoiceSlider.value))

func _process(_delta):
	pass

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func _on_effects_slider_value_changed(value):
	AudioServer.set_bus_volume_db(volum_bus, linear_to_db(value))

func _on_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_credits_pressed():
	var instance = credits.instantiate()
	add_child(instance)


func _on_voice_slider_drag_started() -> void:
	$VoiceTest.play()


func _on_voice_slider_drag_ended(value_changed: bool) -> void:
	$VoiceTest.stop()
