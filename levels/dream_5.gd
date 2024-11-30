extends Node3D


func _on_door_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		$Door/CollisionShape3D.call_deferred("set_disabled", false)
		var tween = create_tween()
		tween.tween_property($Door/MeshInstance3D,"position:y", 0, 1)


func _on_button_item_collected() -> void:
	$Door.hide()
	var tween = create_tween()
	tween.tween_property($GridMap,"cell_size", Vector3(20,1,20), 10)
