extends Node3D

# Reference to the AudioStreamPlayers
@onready var music_player_inn : AudioStreamPlayer = $MusicPlayerInn
@onready var music_player_dream : AudioStreamPlayer = $MusicPlayerDream

# References to the Area nodes
@onready var inn_area : Area3D = $InnArea
@onready var dream_area : Area3D = $DreamArea

# Reference to the player controller (if it's attached to the player node)
@onready var player_controller : KinematicBody3D = get_node("/root/dream0/Player")

func _ready():
	# Check if player is in the Inn or Dream area using the player controller's state
	if inn_area.is_overlapping_body(player_controller.get_player()):
		music_player_inn.play()
		music_player_dream.stop()
	elif dream_area.is_overlapping_body(player_controller.get_player()):
		music_player_inn.stop()
		music_player_dream.play()
	else:
		music_player_inn.play()
		music_player_dream.stop()

	# Connect the area signals (use signal names from the Area3D node)
	inn_area.body_entered.connect(_on_InnArea_entered)
	inn_area.body_exited.connect(_on_InnArea_exited)
	dream_area.body_entered.connect(_on_DreamArea_entered)
	dream_area.body_exited.connect(_on_DreamArea_exited)

# Function when player enters the Inn area
func _on_InnArea_entered(body : Node3D):
	if body == player_controller.get_player():
		music_player_inn.play()
		music_player_dream.stop()

# Function when player exits the Inn area
func _on_InnArea_exited(body : Node3D):
	if body == player_controller.get_player():
		music_player_inn.stop()

# Function when player enters the Dream area
func _on_DreamArea_entered(body : Node3D):
	if body == player_controller.get_player():
		music_player_inn.stop()
		music_player_dream.play()

# Function when player exits the Dream area
func _on_DreamArea_exited(body : Node3D):
	if body == player_controller.get_player():
		music_player_inn.play()
		music_player_dream.stop()
