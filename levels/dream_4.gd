extends Node3D

var color_cycle: Array[Color] = [Color.RED, Color.BLUE, Color.YELLOW]
var color_index: int = 0
var is_maze_ready: bool = true

@onready var maze: GridMap = $Maze/Maze

func _on_timer_timeout() -> void:
	var color_tween = create_tween()
	color_tween.tween_property($DirectionalLight3D, "light_color", color_cycle[color_index], 0.1)
	$AudioStreamPlayer3D.play()



func _on_rotate_trigger_body_entered(body: Node3D) -> void:
	if is_maze_ready and body is Player:
		is_maze_ready = false
		$MazeCooldown.start()
		var tween = create_tween()
		tween.tween_property(maze, "rotation:y", maze.rotation.y + PI/2, 2)


func _on_maze_cooldown_timeout() -> void:
	is_maze_ready = true


func _on_start_pickup_item_collected() -> void:
	print("cool")
