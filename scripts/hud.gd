extends MarginContainer

const DEFAULT_TEXT = "..."

@onready var inventory = $HBoxContainer/InventoryGrid
@onready var textbox = $HBoxContainer/TextBox
@onready var talksprite_container = $"../PlayerView/EnvironmentViewport/Talksprite"
@onready var talksprite = $"../PlayerView/EnvironmentViewport/Talksprite/Talksprite"
@onready var interactable_prompt = $"../PlayerView/EnvironmentViewport/IntractivePopup"

var player

func _ready():
	await get_tree().process_frame
	if Game.player:
		Game.player.interact.connect(_on_player_interact)
		Game.player.in_proximity_to_interactible.connect(_show_hide_interactive_prompt)
	else:
		print("Warning! No player node found!!")

func do_npc_interaction(npc):
	interactable_prompt.hide()
	talksprite_container.visible = true
	talksprite.sprite_frames = npc.talksprite
	talksprite.play()
	
	Game.lock_player()
	
	await npc.do_npc_interaction(self)
	
	talksprite.stop()
	
	await wait_for_input()
	
	talksprite_container.visible = false
	textbox.present_text(DEFAULT_TEXT, 0)
	Game.unlock_player()
	interactable_prompt.show()

func wait_for_input():
	var tree = get_tree()
	while not Input.is_action_pressed("interact"):
		await tree.process_frame

func _on_player_interact(thing):
	if thing.is_in_group("Npc"):
		await do_npc_interaction(thing)

func _on_inventory_grid_on_item_selected(item, slot_number):
	textbox.present_text(DEFAULT_TEXT, 0)

func _on_inventory_grid_on_item_hovered(item, slot_number):
	if item:
		textbox.present_text(item.name + ":\n" + item.description)

func _show_hide_interactive_prompt(other):
	if other:
		interactable_prompt.show()
	else:
		interactable_prompt.hide()
