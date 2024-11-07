extends Area3D


@export var dialog_script: String

var is_player_in_zone: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_player_in_zone:
		if Input.is_action_just_pressed("Interact"):
			SignalBus.start_dialog.emit(dialog_script)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		is_player_in_zone = true


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		is_player_in_zone = false
