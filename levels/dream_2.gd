extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# to hide roof in editor but see it in game
	$Roof.show()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.is_frozen = true


func _on_moveable_object_interacted_with() -> void:
	$FakeWall.hide()


func _on_end_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		SignalBus.level_end.emit("inn", 1, 0)


func _on_alt_end_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		SignalBus.level_end.emit("inn", 0, 1)


func _on_pickup_item_collected() -> void:
	pass # side_doors_open
