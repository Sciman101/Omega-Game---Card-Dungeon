extends Node

var Items = {
	'house_key': {
		"name": "House Key",
		"texture": preload("res://textures/items/key.png"),
		"description": "A common house key",
		"key_item": true
	},
	'burger': {
		"name": "Hamburger",
		"texture": preload("res://textures/items/burger.png"),
		"description": "A juicy quarter-pound hamburger",
		"key_item": false
	}
}

var player
var inventory = [Items.burger, Items.burger, Items.house_key, Items.house_key, Items.house_key, Items.house_key, Items.house_key, Items.house_key, Items.house_key, Items.burger]

func _ready():
	# Populate items with their id
	for item_id in Items:
		Items[item_id].id = item_id

func lock_player():
	if player: player.set_physics_process(false)

func unlock_player():
	if player: player.set_physics_process(true)

func is_player_locked():
	if player:
		return not player.is_physics_processing()
	else:
		return false
