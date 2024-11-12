extends RigidBody3D

@export var player: Player

## How quickly the object will catch up with the mouse
@export var snappiness: float = 0.1
## How strong the objects movements are
@export var follow_speed: float = 4

@onready var click_joint: PinJoint3D = $PinJoint3D


#TODO consider making the marker3D an accessible node of player

var is_held: bool = false
var hover_text: String = "Pick up"
var drag_point: Marker3D

func interact() -> void:
	if not is_held:
		is_held = true
		
		# create marker as a child of the player at the location of the interacted object
		drag_point = Marker3D.new()
		player.camera.add_child(drag_point)
		drag_point.global_position = global_position
		add_collision_exception_with(player)
		
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Interact"):
		if is_held:
			is_held = false
			drag_point.queue_free()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if is_held:
		# apply force to object to have it stay near the drag_point
		state.linear_velocity = state.linear_velocity.lerp((drag_point.global_position - state.transform.origin) * follow_speed, snappiness)