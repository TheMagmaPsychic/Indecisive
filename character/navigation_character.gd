extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@export var player: CharacterBody3D

var SPEED := 3.0

func _physics_process(delta):
	nav_agent.target_position = player.global_position
	var current_location = global_position
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.velocity = new_velocity
	

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_target_reached():
	print("in range")


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()
