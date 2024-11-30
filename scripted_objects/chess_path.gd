extends Path3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.set_new_path_request.connect(_on_set_new_path_request)
	SignalBus.path_move_request.connect(_on_move_request)
	SignalBus.reset_request.connect(_on_reset_request)


func _on_set_new_path_request(path: Curve3D):
	_on_reset_request()
	curve = path


func _on_move_request(speed: float = 8.0):
	var tween = create_tween()
	tween.tween_property($PathFollow3D,"progress_ratio", 1.0, speed)
	tween.tween_callback($PathFollow3D.set_visible.bind(false))
	

func _on_reset_request():
	$PathFollow3D.progress_ratio = 0.0
	$PathFollow3D.visible = true
