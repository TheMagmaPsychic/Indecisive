extends Control

@onready var command_label: RichTextLabel = $MarginContainer/Label

var text_shown: bool = false
var text_stay_time: float = 4.5
var cur_time_shown: float = 0.0

func _process(delta: float) -> void:
	if text_shown:
		if cur_time_shown >= text_stay_time:
			text_shown = false
			cur_time_shown = 0.0
			var tween = create_tween()
			tween.tween_property(command_label, "modulate:a", 0, 1)
		else:
			cur_time_shown += delta
		
	
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
	text_shown = true
	cur_time_shown = 0
