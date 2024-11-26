extends StaticBody3D

signal item_collected()
var hover_text = ''


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_rotation:y", deg_to_rad(360), 6).from_current()
	tween.set_loops()


func interact(player: Player):
	set_collision_layer_value(1, false)
	var tween = create_tween()
	tween.tween_property(self, "global_position", player.global_position, 0.3)
	await tween.finished
	hide()
	item_collected.emit()
	queue_free()
