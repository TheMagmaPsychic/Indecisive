extends Node3D

@export var dialogue_list: Array[Resource]
@export var dialogue_text: Array[String]

var dialogue_groups: Array[Array] = [[1,2,5], [1,6], [3,4], [8]]

@onready var player_spawn: Marker3D = $PlayerSpawn
@onready var dialogue_player: AudioStreamPlayer = $DialoguePlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.set_text_request.emit("")
	blink()
	Global.fade_in_music(create_tween(),$BackgroundMusic, 5)
	Global.day += 1
	setup_inn()
	say_dialogue()
	

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
	
func say_dialogue():
	$Wake.play()
	await $Wake.finished
	var dialogue_group: Array = dialogue_groups[Global.day-1]
	for dialogue_number in dialogue_group:
		dialogue_player.stream = dialogue_list[dialogue_number-1]
		dialogue_player.play()
		await dialogue_player.finished
	var door_tween = create_tween()
	door_tween.tween_property($Door, "rotation:y", deg_to_rad(140), 1)
	
