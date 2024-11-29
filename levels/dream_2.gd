extends Node3D

var is_end_triggered: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# to hide roof in editor but see it in game
	$Roof.show()
	Global.fade_in_music(create_tween(), $BackgroundMusic, 3)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.is_frozen = true


func _on_end_trigger_body_entered(body: Node3D) -> void:
	if body is Player and not is_end_triggered:
		is_end_triggered = true
		$EndRoom/StaticBody3D/CollisionShape3D.call_deferred("set_disabled", false)
		var tween = create_tween()
		tween.tween_property($EndRoom/StaticBody3D/MeshInstance3D, "position:y", 0, 2)
		Global.fade_out_music(create_tween(), $BackgroundMusic, 6)
		tween.tween_property($EndRoom/OmniLight3D, "light_energy", 0, 3)
		await tween.finished
		$Commands/Wake.play()
		await $Commands/Wake.finished
		SignalBus.level_end.emit("inn", 1, 0)


func _on_alt_end_trigger_body_entered(body: Node3D) -> void:
	if body is Player and not is_end_triggered:
		is_end_triggered = true
		SignalBus.level_end.emit("inn", 0, 1)


func _on_pickup_item_collected() -> void:
	$AltRoom/BlockedDoor.visible = false
	$AltRoom/BlockedDoor/CollisionShape3D.disabled = true
	$EndRoom/BlockedDoor.visible = false
	$EndRoom/BlockedDoor/CollisionShape3D.disabled = true
