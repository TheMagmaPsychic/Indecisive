extends Sprite3D

@export var player: Node3D
## select which axis is parallel to the mirror
@export_enum("X-axis", "Z-axis") var mirror_placment_axis: int

@onready var mirror_camera: Camera3D = $SubViewport/Camera3D

const REFLECTION_VEC:= Vector3(-1,0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mirror_camera.global_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var reflection_point := Vector3.ZERO
	
	if mirror_placment_axis == 0:
		reflection_point.z = player.global_position.z
		reflection_point.x = global_position.x - (player.global_position.x - global_position.x)
		reflection_point.y = global_position.y
	elif mirror_placment_axis == 1:
		reflection_point.x = player.global_position.x
		reflection_point.z = global_position.z - (player.global_position.z - global_position.z)
		reflection_point.y = global_position.y
	mirror_camera.look_at(reflection_point)
