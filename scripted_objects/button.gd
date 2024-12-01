extends StaticBody3D

signal item_collected()
var hover_text = 'Wake Up'


func interact(player: Player):
	item_collected.emit()
