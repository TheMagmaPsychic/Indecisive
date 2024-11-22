extends Node

signal process #manual process for when time gets sped up or slowed down
signal physics_process #same but for physics process
signal update_UI_interact(new_text) #when interactable undertext updates

signal player_move_request(position: Vector3, rotation: Vector3)
signal level_end(sanity_change: int, knowledge_change: int)

# Dream 3 signals
signal set_new_path_request(path: Curve3D)
signal path_move_request(speed: float)
signal reset_request
