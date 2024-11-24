class_name NPC
extends StaticBody3D

@export var dialogue_file: DialogueResource
var hover_text: String = "Talk"
var times_interacted: int = 0

func interact():
	var day = "Day" + str(Global.day)
	DialogueManager.show_example_dialogue_balloon(dialogue_file, day)
	times_interacted += 1
