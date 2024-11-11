extends RigidBody3D

@export var player: Player
@onready var click_joint: PinJoint3D = $PinJoint3D

var is_held: bool = false
var created_pin_point: StaticBody3D

func interact(collision_point) -> void:
	print("clicked on")
	if not is_held:
		is_held = true
		var pinned_point = StaticBody3D.new()
		player.camera.add_child(pinned_point)
		pinned_point.global_position = collision_point
		click_joint.node_a = self.get_path()
		click_joint.node_b = pinned_point.get_path()
		
	
func _unhandled_input(event: InputEvent) -> void:
	pass#if event is InputEventMouseButton and event.is_action_released("Interact"):
	#	is_held = false
	#	created_pin_point.queue_free()
