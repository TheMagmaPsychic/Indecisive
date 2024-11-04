extends Node

var timers = {
	running = 0
}
var timescale : float = 1.0
var is_printing_warning:bool = false
var is_printing_info:bool = false
enum urgencies {
	ERROR,
	WARNING,
	INFO
}

func _process(delta):
	timers.running += delta
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

func output(text: String, urgency: urgencies = urgencies.WARNING, do_print: bool = false):
	if urgency == urgencies.ERROR:
		print("ERROR | ", timers.running, " | ", text)
	if urgency == urgencies.WARNING and is_printing_warning:
		print("WARNING | ", timers.running, " | ", text)
	if urgency == urgencies.WARNING and is_printing_info and do_print:
		print("INFO | ", timers.running, " | ", text)
