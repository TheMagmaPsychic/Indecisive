extends Control


func _ready():
	SignalBus.update_UI_interact.connect(interact)
	DialogueManager.dialogue_ended.connect(show_ui)
	DialogueManager.passed_title.connect(hide_ui)

func interact(new_text):
	$Info.text = new_text

func hide_ui(_resource):
	visible = false

func show_ui(_resource):
	visible = true
