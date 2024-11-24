extends Node3D

@onready var wait_timer: Timer = $WaitTimer
@onready var player_spawn: Marker3D = $PlayerSpawn
@export var path_options: Array[Curve3D]

var success: int = 0
var alt_success: int = 0
var fails: int = 0

const ROUNDS = 3
const TRIES = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func show_path():
	#say task
	wait_timer.start()
	await wait_timer.timeout
	SignalBus.path_move_request.emit()
	wait_timer.start()
	await wait_timer.timeout
	$PlayerBox/StaticBody3D/front.disabled = true
	$PlayerBox/StaticBody3D/floor.disabled = true


func _on_exit_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		success += 1
		if success >= ROUNDS:
			SignalBus.LevelEnd.emit(success, alt_success)


func _on_alt_exit_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		success += 1
		alt_success += 1
		if success >= ROUNDS:
			SignalBus.level_end.emit("inn", success, alt_success)


func _on_fail_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		fails += 1
		if fails >= TRIES:
			SignalBus.level_end.emit("inn", success, alt_success)
		$PlayerBox/StaticBody3D/front.call_deferred("set_disabled", false)
		$PlayerBox/StaticBody3D/floor.call_deferred("set_disabled", false)
		SignalBus.reset_request.emit()
		$Player.global_position = player_spawn.global_position # temp


func _on_show_path_trigger_body_entered(body: Node3D) -> void:
	show_path()
