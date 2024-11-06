extends CharacterBody3D

var speed: float = 5 #How much speed to add to velocity, not max speed
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") #We can change the gravity in project settings so it's global
var jump_strength: float = 0.5
var mouse_sensitivity: float = 0.0018 #Needs to be very small, play with the value (about 0.002 is "normal")
var joystick_sensitivity: Dictionary = {
	x = 0.1,
	y = 0.09
}
var sprint_multiplier: float = 1.6 #Value multiplied to the speed when running forward.

var print_velocity: bool = false
var print_speed: bool = false
var print_friction: bool = false
var print_input:bool = false
var print_position:bool = false

var input:Vector2 = Vector2(0, 0)
var movement_dir:Vector3 = Vector3(0, 0, 0)
var is_sprinting:bool = false #is player sprinting
var sprint_toggled:bool = false

var movement_speed: float = 0
var normalized_speed: Vector3 = Vector3(0,0,0)
var movement_dir_normal: Vector3 = Vector3(0,0,0)
var difference: float = 0

enum locomotion {
	GROUND,
	AIR,
	LADDER
}
var current_locomotion: locomotion = locomotion.GROUND

#BUG slows down when not moving forward when facing a direction

# Called when the node enters the scene tree for the first time.
func _ready(): #capture mouse, connect manual processes to the signal bus
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Signalbus.connect("physics_process", manual_physics_process)
	Signalbus.connect("process", manual_process)

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: #I just pulled this from some tutorial
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera.rotate_x(event.relative.y * mouse_sensitivity)
		$Camera.rotation.x = clampf($Camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("ui_accept"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("b button"):
		position = Vector3(0,0,0)
	if event.is_action_pressed("speed up"):
		Global.timescale += 0.1
	if event.is_action_pressed("slow down"):
		Global.timescale -= 0.1
	if event.is_action_pressed("Toggle Sprint"):
		sprint_toggled = !sprint_toggled

func _physics_process(delta): #if going faster than 100%, doesn't recalculate input on each process
	#The player will only get ~70% of the sprint bonus if also strafing because of vector normalization
	#If using a joystick, the player can be "sprinting" at very slow movement speeds
	var look_input = Input.get_vector("Look Left", "Look Right", "Look Down", "Look Up", 0.2)
	if look_input != Vector2(0,0):
		rotate_y(-look_input.x * joystick_sensitivity.x)
		$Camera.rotate_x(-look_input.y * joystick_sensitivity.y)
		$Camera.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	input = Input.get_vector("Move Left", "Move Right", "Move Forward", "Move Backward", 0.2)
	is_sprinting = Input.is_action_pressed("Sprint") or sprint_toggled
	if current_locomotion != locomotion.LADDER:
		velocity.y += -gravity * delta
	
	if $Camera/Pointer.is_colliding():
		if $Camera/Pointer.get_collider().is_in_group("NPCs"):
			$Camera/Pointer.get_collider().talk_to()

func ground_move():
	velocity.x += movement_dir.x * speed * -1
	velocity.z += movement_dir.z * speed * -1
	if Input.is_action_just_pressed("Jump"):
		jump()
	var friction = get_friction()
	velocity.x *= friction
	velocity.z *= friction

func air_move():
	var new_norm = normalized_speed
	if normalized_speed != Vector3(0, 0, 0) and movement_dir_normal != Vector3(0, 0, 0) and abs(rad_to_deg(difference)) > 120:
		movement_speed *= 0.97
	else:
		new_norm = (normalized_speed + -0.05 * movement_dir).normalized()
	velocity.x = movement_speed * new_norm.x
	velocity.z = movement_speed * new_norm.z

func ladder_move():
	if movement_dir_normal != Vector3(0, 0, 0):
		if abs(rad_to_deg(input.angle()) + 90) < 35:
			velocity.y += speed / 3
		elif abs(rad_to_deg(input.angle()) - 90) < 35:
			velocity.y -= speed / 3
	if !$"Ladder ColliderL".is_colliding() and !$"Ladder ColliderL/Ladder ColliderR".is_colliding() and $"Ladder ColliderL/Ladder ColliderD".is_colliding():
		velocity.x += movement_dir.x * speed * -0.2
		velocity.z += movement_dir.z * speed * -0.2
	var friction = get_friction()
	velocity.x *= friction
	velocity.z *= friction
	
	velocity.y *= 0.7

func manual_physics_process(delta, original_delta):
	if is_sprinting and input.y < 0.3: #if shift and w are being held, sprint only in the direction you're looking
		movement_dir = transform.basis * Vector3(input.x, 0, input.y * sprint_multiplier)
	else:
		movement_dir = transform.basis * Vector3(input.x, 0, input.y)

	normalized_speed = Vector3(velocity.x, 0, velocity.z).normalized()
	movement_speed = abs(velocity.x * normalized_speed.x) + abs(velocity.z * normalized_speed.z)
	movement_dir_normal = movement_dir.normalized() * Vector3(-1, 0, -1)
	difference = Vector2(normalized_speed.x, normalized_speed.z).angle() - Vector2(movement_dir_normal.x, movement_dir_normal.z).angle()

	var is_on_ladder = $"Ladder ColliderL".is_colliding() or $"Ladder ColliderL/Ladder ColliderR".is_colliding() or $"Ladder ColliderL/Ladder ColliderD".is_colliding()
	if is_on_ladder: #check for movement type
		current_locomotion = locomotion.LADDER
	elif is_on_floor():
		current_locomotion = locomotion.GROUND
	else:
		current_locomotion = locomotion.AIR
	match current_locomotion: #move according to movement type
		locomotion.LADDER:
			ladder_move()
		locomotion.GROUND:
			ground_move()
		locomotion.AIR:
			air_move()

	if movement_speed <= 4:
		sprint_toggled = false

	velocity.x *= delta / original_delta
	velocity.z *= delta / original_delta
	Global.output(str(movement_speed), Global.urgencies.INFO, print_speed)
	Global.output(str(position), Global.urgencies.INFO, print_position)
	move_and_slide()

func get_friction():
	var floors: Array = $FloorCollider.get_overlapping_bodies()
	var most_friction: float = 1
	floors.erase(self)
	for x in floors:
		if x.physics_material_override == null:
			floors.erase(x)
	match len(floors):
		0:
			Global.output("Friction defaulting to 0.6 (No floor found)", Global.urgencies.WARNING, print_friction)
			return(0.6)
		1:
			Global.output(str(floors[0].physics_material_override.friction), Global.urgencies.INFO, print_friction)
			return(floors[0].physics_material_override.friction)
		_:
			for x in floors:
				var current_friction = x.physics_material_override.friction
				if current_friction <= most_friction:
					most_friction = current_friction
	Global.output(str(most_friction), Global.urgencies.INFO, print_friction)
	return(most_friction)

func jump():
	velocity.y = 5

func manual_process(_delta, _original_delta):
	pass

func _process(_delta):
	pass
