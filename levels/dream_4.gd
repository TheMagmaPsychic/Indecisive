extends Node3D

var color_cycle: Array[Color] = [Color.RED, Color.BLUE, Color.YELLOW]
var color_index: int = 0


func _on_timer_timeout() -> void:
	var color_tween = create_tween()
	color_tween.tween_property($DirectionalLight3D, "light_color", color_cycle[color_index], 0.1)
	color_index = (color_index + 1) % 3
	$AudioStreamPlayer3D.play()


func _on_start_timer_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		_on_timer_timeout()
		$Timer.start()
