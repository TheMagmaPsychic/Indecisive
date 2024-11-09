extends Area3D


@export var dialog_script: String

var is_player_in_zone: bool = false


func _ready() -> void:
	load_from_file()

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

func load_from_file():
	var file = FileAccess.open("res://test_script.txt", FileAccess.READ)
	var full_script: PackedStringArray = file.get_as_text(true).split("\\n")
	for line in full_script:
		var identifier = line.get_slice(' ', 0)
		print(identifier)
		match identifier:
			'act1':
				pass
	
