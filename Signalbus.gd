extends Node

signal process #manual process for when time gets sped up or slowed down
signal physics_process #same but for physics process
signal talk_to_npc
signal talk_to_npc_stop

signal start_dialog(dialog_script) # signal to turn start the dialog box with the attached script
