extends Node3D

var color_cycle: Array[Color] = [Color.RED, Color.BLUE, Color.YELLOW, Color.BLACK]
var color_index: int = 0
var is_maze_ready: bool = true
var collected_items: int = 0

@onready var maze: GridMap = $Maze/Maze


func _on_rotate_trigger_body_entered(body: Node3D) -> void:
	if is_maze_ready and body is Player:
		is_maze_ready = false
		$MazeCooldown.start()
		var tween = create_tween()
		tween.tween_property(maze, "rotation:y", maze.rotation.y + PI/2, 2)
		$MazeRumble.play(14.8)


func _on_maze_cooldown_timeout() -> void:
	is_maze_ready = true


func _on_start_pickup_item_collected() -> void:
	print("cool")


func _on_pickup_item_collected() -> void:
	var color_tween = create_tween()
	color_tween.tween_property($DirectionalLight3D, "light_color", color_cycle[collected_items], 0.1)
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished
	collected_items += 1
	if collected_items == 3:
		$Commands/Wake.play()
		await $Commands/Wake.finished
		SignalBus.level_end.emit("inn", collected_items, )
	else:
		$Commands/Retrieve.play()
