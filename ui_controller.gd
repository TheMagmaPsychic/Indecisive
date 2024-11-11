extends Control


func _ready():
	SignalBus.update_UI_interact.connect(interact)
	#SignalBus.talk_to_npc.connect(hide_ui)
	DialogueManager.dialogue_ended.connect(show_ui)
	DialogueManager.passed_title.connect(hide_ui)

func interact(new_text):
	$Info.text = new_text

func hide_ui(resource):
	visible = false

func show_ui(resource):
	visible = true
