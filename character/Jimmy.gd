class_name NPC
extends StaticBody3D

@export var dialogue_file: DialogueResource
var hover_text: String = "Talk"
var times_interacted: int = 0

func interact():
	SignalBus.talk_to_npc.emit()
	DialogueManager.show_example_dialogue_balloon(dialogue_file)
	times_interacted += 1
