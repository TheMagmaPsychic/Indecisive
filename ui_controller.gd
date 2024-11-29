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
	var tween = create_tween()
	tween.tween_property(command_label, "modulate:a", 1, 1)
	get_tree().create_timer(4.5).timeout.connect(_on_text_timer_timeout)

func _on_text_timer_timeout():
	var tween = create_tween()
	tween.tween_property(command_label, "modulate:a", 0, 1)
