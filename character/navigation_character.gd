extends CharacterBody3D


@export var patrol_points: Array[Marker3D] = []

@export var will_pursue_player: bool = false

@onready var nav_agent = $NavigationAgent3D
var is_target_reached: bool = false
var patrol_point_index: int = 0
var SPEED := 6.0


func _ready() -> void:
	update_target_location()


func set_movement_target(movement_target: Vector3):
	nav_agent.set_target_position(movement_target)


func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
		return
	if nav_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = global_position.direction_to(next_path_position)
	look_at(next_path_position)
	var new_velocity: Vector3 = direction * SPEED
	
	if not is_on_floor():
		nav_agent.velocity.y -= 7 * delta
	
	nav_agent.set_velocity(new_velocity)


func update_target_location():
	nav_agent.call_deferred("set_target_position",patrol_points[patrol_point_index].global_position)
	if patrol_point_index + 1 >= patrol_points.size():
		patrol_point_index = 0
	else:
		patrol_point_index += 1


func _on_navigation_agent_3d_target_reached():
	update_target_location()


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()
