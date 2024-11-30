extends Node3D

@onready var blocking_wall_1: CollisionShape3D = $StartRoom/RoomWalls/xWall
@onready var blocking_wall_2: CollisionShape3D = $StartRoom/RoomWalls/negxWall

var times_failed: int = 0
var has_jumped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	say_command($Commands/Jump)


func say_command(command: AudioStreamPlayer):
	$Commands/CommandDelay.start()
	await $Commands/CommandDelay.timeout
	SignalBus.set_text_request.emit(command.name)
	command.play()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		if not has_jumped and event.is_action_pressed("Jump"):
			has_jumped = true
			blocking_wall_1.disabled = true
			blocking_wall_1.visible = false
			say_command($Commands/Retrieve)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		$Moveable.freeze = false
		blocking_wall_2.set_deferred("disabled", true)
		blocking_wall_2.set_deferred("visible", false)


func _on_trigger_area_2_body_entered(body: Node3D) -> void:
	if body is InteractableBody:
		blocking_wall_2.set_deferred("disabled", false)
		blocking_wall_2.set_deferred("visible", true)
		body.is_interactable = false
		body.freeze = true
		var tween = create_tween()
		tween.tween_property(body,"global_position", Vector3(-31,body.global_position.y,0), 0.8)
		tween.tween_property(body,"global_position:y", 19, 5)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
		await tween.finished
		$PedestalRoom/RoomWalls/Floor.set_deferred("disabled", true)
		$PedestalRoom/Pedestal.set_deferred("visible", false)


func _on_jump_room_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		$JumpRoom/SpotLight3D.set_deferred("visible", true)
		$JumpRoom/SpotLight3D2.set_deferred("visible", true)


func _on_falling_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		body.set_deferred("global_position", Vector3(-32,-136,0))
		if times_failed == 0:
			$JumpRoom/SpotLight3D.light_color = "f1f269"
		elif times_failed == 1:
			$JumpRoom/SpotLight3D.light_color = "ff5c5d"
		else:
			pass # fail task here?
		times_failed += 1


func _on_end_dream_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		$EndRoom/EndDreamTrigger.call_deferred("set_monitoring", false)
		var tween = create_tween()
		$EndRoom/Door/AudioStreamPlayer3D.play()
		tween.tween_property($EndRoom/Door, "rotation:y", 0, 0.5)
		tween.tween_property($EndRoom/SpotLight3D, "light_energy", 0, 3)
		Global.fade_out_music(create_tween(), $BackgroundMusic, 3)
		await tween.finished
		say_command($Commands/Wake)
		await $Commands/Wake.finished
		SignalBus.level_end.emit("inn", 0, 0)


func _on_moveable_object_interacted_with() -> void:
	say_command($Commands/Deposit)
