extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# to hide roof in editor but see it in game
	$Roof.show()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		print("got ya")


func _on_moveable_object_interacted_with() -> void:
	$FakeWall.hide()
