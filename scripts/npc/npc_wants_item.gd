extends "res://scripts/npc/npc_base.gd"

@export var encounter_text : PackedStringArray
@export var short_encounter_text : PackedStringArray

@export var bad_item_text: PackedStringArray
@export var good_item_text: PackedStringArray

@export var post_encounter_text: PackedStringArray

@export var valid_item_ids : PackedStringArray

signal on_item_received

var state := 0

func do_npc_interaction(hud):
	
	if state != 2:
		await do_dialogue_sequence(hud, encounter_text if state == 0 else short_encounter_text)
		await hud.wait_for_input()
		state = 1
		hud.inventory.start_browsing()
		
		var result = await hud.inventory.on_item_selected
		var item = result[0]
		var slot = result[1]
		
		if valid_item_ids.has(item.id):
			state = 2
			
			Game.inventory.remove_at(slot)
			hud.inventory.update_inventory_slots()
			
			await do_dialogue_sequence(hud, good_item_text)
			await hud.wait_for_input()
			on_item_received.emit()
		else:
			await do_dialogue_sequence(hud, bad_item_text)
			await hud.wait_for_input()
		
	else:
		await do_dialogue_sequence(hud, post_encounter_text)
