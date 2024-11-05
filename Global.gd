extends Node

var timers = {
	running = 0
}
var timescale : float = 1.0
var is_printing_warning:bool = false
var is_printing_info:bool = true
enum urgencies {
	ERROR,
	WARNING,
	INFO
}

func _process(delta):
	for key in timers.keys(): #advance timers
		timers[key] += delta

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
	SignalBus.emit_signal("process", delta, original_delta)

func manual_physics_process(delta, original_delta):
	SignalBus.emit_signal("physics_process", delta, original_delta)

func output(text: String, urgency: urgencies = urgencies.WARNING, do_print: bool = false):
	var print_timer = str(round(timers.running * 10000) / 10000).pad_decimals(4)
	if urgency == urgencies.ERROR:
		print("ERROR | ", print_timer, " | ", text)
	if urgency == urgencies.WARNING and is_printing_warning:
		print("WARNING | ", print_timer, " | ", text)
	if urgency == urgencies.INFO and is_printing_info and do_print:
		print("INFO | ", print_timer, " | ", text)
