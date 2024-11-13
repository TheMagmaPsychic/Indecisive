extends Node3D

@onready var blocking_wall_1: CollisionShape3D = $Walls/StaticBody3D/xWall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("Jump"):
			blocking_wall_1.visible = false
			blocking_wall_1.disabled = true


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		$Moveable.freeze = false
