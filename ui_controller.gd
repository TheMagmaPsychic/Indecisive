extends Control

@onready var command_label: RichTextLabel = $MarginContainer/Label

func _ready():
	SignalBus.update_UI_interact.connect(interact)
	SignalBus.set_text_request.connect(_on_set_text_request)
	DialogueManager.dialogue_ended.connect(show_ui)
	DialogueManager.passed_title.connect(hide_ui)

func interact(new_text):
	$Info.text = new_text

func hide_ui(_resource):
	visible = false

func show_ui(_resource):
	visible = true

func _on_set_text_request(new_text):
	command_label.text = "[center]" + new_text
