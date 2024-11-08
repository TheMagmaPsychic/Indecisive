extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
#TODO remove this and update the player position by calling update_target_location
@export var player: CharacterBody3D

var should_jump: bool = false
var next_location: Vector3
var SPEED := 6.0
var cycles_between_recalc := 50
var cycles_since_recalc := 1

func _process(delta: float) -> void:
	if cycles_since_recalc >= cycles_between_recalc:
		next_location = nav_agent.get_next_path_position()
		cycles_since_recalc = 0
	else:
		cycles_since_recalc += 1


func _physics_process(delta):
	update_target_location(player.global_position)
	var direction := global_position.direction_to(next_location)
	nav_agent.velocity.x = direction.x * SPEED
	nav_agent.velocity.z = direction.z * SPEED
	
	print(is_on_floor())
	if not is_on_floor():
		nav_agent.velocity.y -= 7 * delta
	#elif should_jump:
	#	nav_agent.velocity.y += 16
	#	should_jump = false
	
	velocity = nav_agent.velocity
	print(velocity)
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_target_reached():
	print("in range")


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	


func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	if is_on_floor():
		cycles_since_recalc = 0
		print("jump")
		var direction := global_position.direction_to(next_location)
		nav_agent.velocity.y = 7
		nav_agent.velocity.x = direction.x * SPEED*2
		nav_agent.velocity.z = direction.z * SPEED*2
