extends CharacterBody3D

var speed: float = 5 #How much speed to add to velocity, not max speed
var max_speed: float = 10
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") #We can change the gravity in project settings so it's global
var gravity_strength: float = 0 #How much gravity is currently affecting the player
var jump_strength: float = 0.5
var mouse_sensitivity: float = 0.0018 #Needs to be very small, play with the value (about 0.002 is "normal")
var joystick_sensitivity: Dictionary = {
	x = 0.1,
	y = 0.09
}
var sprint_multiplier: float = 1.6 #Value multiplied to the speed when running forward.

var input:Vector2 = Vector2(0, 0)
var movement_dir:Vector3 = Vector3(0, 0, 0)
var is_sprinting:bool = false #is player sprinting
var sprint_toggled:bool = false

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
	if event.is_action_pressed("teleport up"):
		position.y += 100
	if event.is_action_pressed("speed up"):
		Global.timescale += 0.1
	if event.is_action_pressed("slow down"):
		Global.timescale -= 0.1
	if event.is_action_pressed("Toggle Sprint"):
		sprint_toggled = !sprint_toggled

func _physics_process(_delta): #if going faster than 100%, doesn't recalculate input on each process
	#The player will only get ~70% of the sprint bonus if also strafing because of vector normalization
	#If using a joystick, the player can be "sprinting" at very slow movement speeds
	var look_input = Input.get_vector("Look Left", "Look Right", "Look Down", "Look Up", 0.2)
	if look_input != Vector2(0,0):
		rotate_y(-look_input.x * joystick_sensitivity.x)
		$Camera3D.rotate_x(-look_input.y * joystick_sensitivity.y)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	input = Input.get_vector("Move Left", "Move Right", "Move Forward", "Move Backward")
	is_sprinting = Input.is_action_pressed("Sprint") or sprint_toggled

func manual_physics_process(delta, original_delta):
	if is_sprinting and input.y < 0: #if shift and w are being held, sprint only in the direction you're looking
		movement_dir = transform.basis * Vector3(input.x, 0, input.y * sprint_multiplier)
	else:
		movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	if is_on_floor(): #If touching floor, allow movement (will replace with friction mechanics)
		gravity_strength = 0
		velocity.x += movement_dir.x * speed * -1
		velocity.z += movement_dir.z * speed * -1
		if Input.is_action_just_pressed("Jump"):
			jump()
	else: #this is meant to give you a little control over your midair movement, but can make you go really fast too
		velocity.x += movement_dir.x * speed * -0.1
		velocity.z += movement_dir.z * speed * -0.1
	if is_on_floor() : #Friction
		velocity.x *= 0.6
		velocity.z *= 0.6
	else:
		velocity.x *= 0.9
		velocity.z *= 0.9
	var normalized_speed = Vector2(velocity.x, velocity.z).normalized()
	if abs(velocity.x * normalized_speed.x) + abs(velocity.z * normalized_speed.y) <= 4:
		sprint_toggled = false
	#print(normalized_speed)
	#print(Vector2.RIGHT.rotated(normalized_speed.angle()))
	
	#TODO air movement
	
	print("speed: " + str(abs(velocity.x * normalized_speed.x) + abs(velocity.z * normalized_speed.y)))
	velocity.y += -gravity * delta
	velocity.x *= delta / original_delta
	velocity.z *= delta / original_delta
	#velocity.y *= delta
	move_and_slide()

func jump():
	velocity.y = 5

func manual_process(_delta, _original_delta):
	pass
