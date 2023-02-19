extends Node

var Items = {
	'house_key': {
		"name": "House Key",
		"texture": preload("res://textures/items/key.png"),
		"key_item": true
	},
	'burger': {
		"name": "Hamburger",
		"texture": preload("res://textures/items/burger.png"),
		"key_item": false
	}
}

var player
var inventory = [Items.burger, Items.burger, Items.house_key, Items.house_key, Items.house_key, Items.house_key, Items.house_key, Items.house_key, Items.house_key, Items.burger]

func lock_player():
	if player: player.set_physics_process(false)

func unlock_player():
	if player: player.set_physics_process(true)
