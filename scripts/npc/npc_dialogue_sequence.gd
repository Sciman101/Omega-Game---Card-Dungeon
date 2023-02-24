extends "res://scripts/npc/npc_base.gd"

@export var messages : PackedStringArray
@export var loop : bool

var current_dialogue_index : int = 0

func do_npc_interaction(hud):
	var text = messages[current_dialogue_index]
	if current_dialogue_index < messages.size() - 1:
		current_dialogue_index += 1
	elif loop:
		current_dialogue_index = 0
	
	await do_dialogue(hud, text)
