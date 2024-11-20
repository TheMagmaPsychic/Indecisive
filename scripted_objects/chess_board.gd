extends Node3D


var board: Array[Array] = []
var first_path: Array[Array] = [[3,0], [3,1], [3,2], [4,2], [5,2], [5,3], [5,4], [6,4], [7,4], [7,5], [7,6], [7,7]]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#create 2d array representing the board
	for row in get_children():
		var working_row_array: Array[StaticBody3D] = []
		for tile in row.get_children():
			working_row_array.append(tile)
			tile.set_collision_layer_value(1,false)
		board.append(working_row_array)
	
	enable_collision_on(first_path)

func disable_collision_on(tiles: Array[Array]):
	for tile in tiles:
		assert(board[tile[1]][tile[0]] is StaticBody3D, "your board is messed up, tiles are not StaticBody3D")
		board[tile[1]][tile[0]].set_collision_layer_value(1,false)


func enable_collision_on(tiles: Array[Array]):
	for tile in tiles:
		assert(board[tile[1]][tile[0]] is StaticBody3D, "your board is messed up, tiles are not StaticBody3D")
		board[tile[1]][tile[0]].set_collision_layer_value(1,true)
