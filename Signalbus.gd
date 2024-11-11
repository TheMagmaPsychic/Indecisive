extends Node

signal process #manual process for when time gets sped up or slowed down
signal physics_process #same but for physics process
signal talk_to_npc #when talk to npc
signal talk_to_npc_stop #when stopped talk to npc
signal update_UI_interact(new_text) #when interactable undertext updates
