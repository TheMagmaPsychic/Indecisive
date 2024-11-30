extends Node3D


var board: Array[Array] = []
var paths: Array[Array] =  [[[3,0], [3,1], [3,2], [4,2], [5,2], [5,3], [5,4], [6,4], [7,4], [7,5], [7,6], [7,7]],
							[[6,0], [6,1], [6,2], [6,3], [5,3], [4,3], [3,3], [2,3], [2,4], [2,5], [2,6], [2,7]],
							[[0,0], [0,1], [0,2], [0,3], [1,3], [2,3], [2,4], [3,4], [4,4], [4,5], [5,5], [6,5], [6,6], [6,7]],
							[[0,0]]]
var path_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.set_new_path_request.connect(_on_new_path)
	#create 2d array representing the board
	for row in get_children():
		var working_row_array: Array[StaticBody3D] = []
		for tile in row.get_children():
			working_row_array.append(tile)
			tile.set_collision_layer_value(1,false)
		board.append(working_row_array)
	
	enable_collision_on(paths[0])

func disable_collision_on(tiles: Array):
	for tile in tiles:
		#assert(board[tile[1]][tile[0]] is StaticBody3D, "your board is messed up, tiles are not StaticBody3D")
		board[tile[1]][tile[0]].set_collision_layer_value(1,false)
		board[tile[1]][7-tile[0]].set_collision_layer_value(1,false)


func enable_collision_on(tiles: Array):
	for tile in tiles:
		#assert(board[tile[1]][tile[0]] is StaticBody3D, "your board is messed up, tiles are not StaticBody3D")
		board[tile[1]][tile[0]].set_collision_layer_value(1,true)
		board[tile[1]][7-tile[0]].set_collision_layer_value(1,true)

func _on_new_path(_path: Curve3D):
	path_index += 1
	disable_collision_on(paths[path_index-1])
	enable_collision_on(paths[path_index])
