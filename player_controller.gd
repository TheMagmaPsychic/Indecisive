extends CharacterBody3D

var speed: float = 5 #How much speed to add to velocity, not max speed
var max_speed: float = 10
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") #We can change the gravity in project settings so it's global
var jump_strength: float = 0.5
var mouse_sensitivity: float = 0.0018 #Needs to be very small, play with the value (about 0.002 is "normal")
var sprint_multiplier: float = 1.6 #Value multiplied to the speed when running forward.

var input:Vector2 = Vector2(0, 0)
var movement_dir:Vector3 = Vector3(0, 0, 0)
var is_sprinting:bool = false #is player sprinting

# Called when the node enters the scene tree for the first time.
func _ready(): #capture mouse, connect manual processes to the signal bus
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$"/root/Main/Signal_Bus".connect("physics_process", manual_physics_process)
	$"/root/Main/Signal_Bus".connect("process", manual_process)

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: #I just pulled this from some tutorial
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("ui_accept"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta): #if going faster than 100%, doesn't recalculate input on each process
	#The player will only get ~70% of the sprint bonus if also strafing because of vector normalization
	#If using a joystick, the player can be "sprinting" at very slow movement speeds
	input = Input.get_vector("Move Left", "Move Right", "Move Forward", "Move Backward")
	is_sprinting = Input.is_action_pressed("Sprint")

func manual_physics_process(delta):
	velocity.y += -gravity * delta
	if is_sprinting and input.y < 0: #if shift and w are being held, sprint only in the direction you're looking
		movement_dir = transform.basis * Vector3(input.x, 0, input.y * sprint_multiplier)
	else:
		movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	if is_on_floor(): #If touching floor, allow movement (will replace with friction mechanics)
		velocity.x += movement_dir.x * speed * -1
		velocity.z += movement_dir.z * speed * -1
		if Input.is_action_just_pressed("Jump"):
			jump()
	else: #this is meant to give you a little control over your midair movement, but can make you go really fast too
		velocity.x += movement_dir.x * speed * -0.1
		velocity.z += movement_dir.z * speed * -0.1
	if is_on_floor(): #Friction
		velocity.x *= 0.6
		velocity.z *= 0.6
	else:
		velocity.x *= 0.9
		velocity.z *= 0.9
	#var normie = Vector2(abs(velocity.x), abs(velocity.z)).normalized()
	#print("Before: x|" + str(velocity.x) + " z|" + str(velocity.z))
	#this is supposed to find the direction of travel (from x and z ratio), check if total speed is greater than max speed, then set speed to speed limit
	#if abs(velocity.x * normie.x) + abs(velocity.z * normie.y) >= max_speed + (max_speed * int(is_sprinting) * sprint_multiplier - 1):
	#	velocity.x = -int(velocity.x < 0) * abs(normie.x) * (max_speed) #+ (max_speed * int(is_sprinting) * (sprint_multiplier - 1)))
	#	velocity.z = -int(velocity.z < 0) * abs(normie.y) * (max_speed) #+ (max_speed * int(is_sprinting) * (sprint_multiplier - 1)))
	#print("After: x|" + str(velocity.x) + " z|" + str(velocity.z))
	move_and_slide()

func jump():
	velocity.y = 5

func manual_process(_delta):
	pass
