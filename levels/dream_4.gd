extends Node3D

var color_cycle: Array[Color] = [Color.RED, Color.BLUE, Color.YELLOW]
var color_index: int = 0
@onready var tree = get_tree()

func _on_timer_timeout() -> void:
	var color_tween = create_tween()
	color_tween.tween_property($DirectionalLight3D, "light_color", color_cycle[color_index], 0.1)
	$AudioStreamPlayer3D.play()
	change_walls()
	
	color_index = (color_index + 1) % 3


func change_walls():
	match color_index:
		0:
			tree.call_group("Red","hide")
			tree.call_group("Yellow","show")
		1:
			tree.call_group("Blue","hide")
			tree.call_group("Red","show")
		2:
			tree.call_group("Yellow","hide")
			tree.call_group("Blue","show")


func _on_start_timer_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		_on_timer_timeout()
		$Timer.start()
