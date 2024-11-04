extends Node

var timers = {}
var timescale : float = 1.0

func _process(delta):
	for repititions in range(floor(timescale)):
		manual_process(delta)
	if timescale - floor(timescale) != 0:
		manual_process(delta * timescale)

func _physics_process(delta):
	for repititions in range(floor(timescale)):
		manual_physics_process(delta)
	if timescale - floor(timescale) != 0:
		manual_physics_process(delta * timescale)

func manual_process(delta):
	$"/root/Main/Signal_Bus".emit_signal("process", delta)

func manual_physics_process(delta):
	$"/root/Main/Signal_Bus".emit_signal("physics_process", delta)
