extends Area3D


@export var dialog_script: DialogueResource

var is_player_in_zone: bool = false


func interact() -> void:
	print("talked to")
	DialogueManager.show_dialogue_balloon(dialog_script)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		is_player_in_zone = true
		print("player in zone")


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		is_player_in_zone = false
		print("player left zone")
