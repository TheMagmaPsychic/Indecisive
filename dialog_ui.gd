extends Control

@onready var dialog_label: RichTextLabel = $MarginContainer2/PanelContainer/MarginContainer/DialogLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.start_dialog.connect(_on_start_dialog)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_dialog(dialog_script: String):
	pass
