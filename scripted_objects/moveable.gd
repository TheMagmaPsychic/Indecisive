class_name InteractableBody
extends RigidBody3D

#TODO consider making the marker3D an accessible node of player
#TODO get reference to play from function call instead of export, this is for testing
@export var player: Player

## How quickly the object will catch up with the mouse
@export var snappiness: float = 0.1
## How strong the objects movements are
@export var follow_speed: float = 4
## Is the object currently able to be picked up or interacted with
@export var is_interactable = true :
	set = _set_is_interactable


var is_held: bool = false
var hover_text: String = "Pick up"
var drag_point: Marker3D

func interact() -> void:
	if not is_held and is_interactable:
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
		var correction_vect = drag_point.global_position - state.transform.origin
		correction_vect.x *= follow_speed
		correction_vect.y *= follow_speed/2
		correction_vect.z *= follow_speed
		state.linear_velocity = state.linear_velocity.lerp(correction_vect, snappiness)


func _set_is_interactable(new_state):
	is_interactable = new_state
	is_held = false
