extends CharacterBody3D

## Assign Marker3D to this to set the character's patrol path. Creating a Node as a child of the character and placing your markers there is recommended for organization
@export var patrol_points: Array[Marker3D] = []
## WIP nothing for now
@export var will_pursue_player: bool = false
## Sets the speed that the entity will move at
@export var move_speed: float = 6.0
## Time the character will pause after reaching a patrol point before heading to the next one
@export var patrol_pause_time: float = 1.0


@onready var nav_agent = $NavigationAgent3D

var is_target_reached: bool = false
var needs_to_turn: bool = false
var patrol_point_index: int = 0
var cur_patrol_pause_time: float = 1.1


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
	if patrol_pause_time >= cur_patrol_pause_time:
		cur_patrol_pause_time += delta
		return
	if needs_to_turn:
		pass

	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = global_position.direction_to(next_path_position)
	#look_at(direction + global_position)
	var new_velocity: Vector3 = direction * move_speed
	
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
	cur_patrol_pause_time = 0.0
	needs_to_turn = true
	update_target_location()


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	if not velocity.is_equal_approx(Vector3.ZERO):
		look_at(velocity + global_position)
	move_and_slide()
