extends StaticBody3D

var hover_text: String = "Talk"
var times_interacted: int = 0
var flags = {
	first_interaction = true,
	turned_on_lights = false,
	blown_out_candles = false,
}
var dialogue = {
	first_interact = {
		first = ["Hello!", "It's been a while.", "Would you mind turning on the lights for me?"],
		second = ["The lights still need to be turned on."],
		repeat = ["Please stop stalling, I need the lights to be turned on."]
	},
	lights_turned_on = {
		first = ["Thanks for turning the lights off.", "Jimmy has been having problems sleeping.", "Would you go check on him?"],
	}
}

#requirement = func():
	#return(times_interacted == 1),
	#print(dialogue.first_interact.requirement.call())

func _ready():
	pass

func _process(_delta):
	pass

func interact():
	Signalbus.emit_signal("talk_to_npc")
	choose_dialogue()
	times_interacted += 1

func choose_dialogue():
	if flags.first_interaction:
		match times_interacted:
			0:
				do_dialogue(dialogue.first_interact.first)
			1:
				do_dialogue(dialogue.first_interact.second)
			_:
				do_dialogue(dialogue.first_interact.repeat)
	elif flags.turned_on_lights and !flags.blown_out_candles:
		match times_interacted:
			0:
				pass
			1:
				pass
			[2, 3, 4, 5, 6, 7, 8]:
				pass
			_:
				pass

func do_dialogue(text):
	if text is Array:
		text[0]
	else:
		text
