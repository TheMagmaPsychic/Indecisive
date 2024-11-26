extends Node

signal process #manual process for when time gets sped up or slowed down
signal physics_process #same but for physics process
signal update_UI_interact(new_text: StringName) #when interactable undertext updates
signal set_text_request(new_text: StringName)

signal level_end(next_scene: StringName, sanity_change: int, knowledge_change: int)

# Dream 3 signals
signal set_new_path_request(path: Curve3D)
signal path_move_request(speed: float)
signal reset_request
