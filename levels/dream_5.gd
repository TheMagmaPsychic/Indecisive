extends Node3D


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
