extends Node3D

@onready var blocking_wall_1: CollisionShape3D = $StartRoom/RoomWalls/xWall
@onready var blocking_wall_2: CollisionShape3D = $StartRoom/RoomWalls/negxWall

var times_failed: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("Jump"):
			blocking_wall_1.disabled = true
			blocking_wall_1.visible = false


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
		tween.tween_property(body,"global_position:y", 19, 5)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
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
