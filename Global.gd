extends Node

var timers = {}
var timescale : float = 1.0

func _process(delta):
	for repititions in range(floor(timescale)):
		manual_process(delta, delta)
	if timescale - floor(timescale) != 0:
		manual_process(delta * timescale, delta)

func _physics_process(delta):
	timescale = clampf(timescale, 0, 3)
	for repititions in range(floor(timescale)):
		manual_physics_process(delta, delta)
	if timescale - floor(timescale) != 0:
		manual_physics_process(delta * timescale, delta)

func manual_process(delta, original_delta):
	$"/root/Main/Signal_Bus".emit_signal("process", delta, original_delta)

func manual_physics_process(delta, original_delta):
	$"/root/Main/Signal_Bus".emit_signal("physics_process", delta, original_delta)
