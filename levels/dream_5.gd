extends Node3D

var is_saying_wake_alot: bool = false
var wake_cooldown: float = 1.0
var cur_cooldown: float = 0.0
var cur_wake_spam: int = 0
const WAKE_SPAM: int = 30

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		print($Player.global_position)
	if is_saying_wake_alot:
		if cur_cooldown >= wake_cooldown:
			cur_wake_spam += 1
			$Wake.play()
			wake_cooldown = randf_range(0.1, 0.5)
			$Wake.pitch_scale = randf_range(0.95, 1.05)
			cur_cooldown = 0.0
			if cur_wake_spam >= WAKE_SPAM:
				is_saying_wake_alot = false
		else:
			cur_cooldown += delta

func _on_door_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		$Door/CollisionShape3D.call_deferred("set_disabled", false)
		var tween = create_tween()
		tween.tween_property($Door/MeshInstance3D,"position:y", 0, 1)


func _on_button_item_collected() -> void:
	
	var tween = create_tween()
	tween.tween_property($Lights/OmniLight3D6, "light_energy", 0, 3)
	tween.tween_callback(wake_up).set_delay(1)
	tween.tween_callback($Door.hide).set_delay(3)
	tween.parallel().tween_property($GridMap,"cell_size", Vector3(20,5,20), 10).set_delay(3)
	tween.parallel().tween_property($DirectionalLight3D, "light_energy", 1, 2).set_delay(3)
	tween.parallel().tween_property($DirectionalLight3D2, "light_energy", 1, 2).set_delay(3)
	#tween.parallel().tween_property($DirectionalLight3D, "rotation:y", PI*10, 20)

func wake_up():
	$Wake.play()
	await $Wake.finished
	is_saying_wake_alot = true


func _on_end_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		for child in $EndRoom.get_children():
			child.freeze = false
		var tween = create_tween()
		tween.tween_property($WorldEnvironment.environment, "fog_depth_begin", 1, 10)
		tween.parallel().tween_property($WorldEnvironment.environment, "fog_depth_end", 2, 10)
		$Timer.start()
		

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://theme/Start Screen.tscn")
