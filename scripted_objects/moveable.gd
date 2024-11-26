class_name InteractableBody
extends RigidBody3D

#TODO consider making the marker3D an accessible node of player

## How quickly the object will catch up with the mouse
@export var snappiness: float = 0.1
## How strong the objects movements are
@export var follow_speed: float = 4
## Is the object currently able to be picked up or interacted with
@export var is_interactable = true :
	set = _set_is_interactable


var is_held: bool = false
var is_on_cooldown: bool = false
var hover_text: String = "Pick up"
var drag_point: Marker3D
var cur_drop_cooldown: float = 1

const DROP_COOLDOWN: float = 0.2

signal object_interacted_with()


func _process(delta: float) -> void:
	if is_on_cooldown:
		if cur_drop_cooldown > DROP_COOLDOWN:
			is_on_cooldown = false
		else:
			cur_drop_cooldown += delta


func interact(player: Player) -> void:
	if not is_held and is_interactable and not is_on_cooldown:
		object_interacted_with.emit()
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
			is_on_cooldown = true
			cur_drop_cooldown = 0.0


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if is_held:
		# apply force to object to have it stay near the drag_point
		var correction_vect = drag_point.global_position - state.transform.origin
		correction_vect.x *= follow_speed
		correction_vect.y *= follow_speed#/2
		correction_vect.z *= follow_speed
		state.linear_velocity = state.linear_velocity.lerp(correction_vect, snappiness)


func _set_is_interactable(new_state):
	is_interactable = new_state
	is_held = false


func _on_body_entered(body: Node) -> void:
	if not body is Player:
		if linear_velocity.length() > 1.6 and not is_held:
			$AudioStreamPlayer3D.play()
