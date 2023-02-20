extends MarginContainer

@onready var inventory_slots = $HBoxContainer/InventoryGrid.get_children()
@onready var textbox_label = $HBoxContainer/TextBox/Margins/Label
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

func present_text(text:String,text_speed:float=1) -> void:
	textbox_label.text = text
	if text_speed != 0:
		textbox_label.visible_characters = 0
		var delay = 0.05 / text_speed
		for x in text:
			textbox_label.visible_characters += 1
			await get_tree().create_timer(delay).timeout
	else:
		textbox_label.visible_characters = -1

func do_npc_dialogue(npc):
	talksprite_container.visible = true
	talksprite.sprite_frames = npc.talksprite
	talksprite.play()
	
	Game.lock_player()
	
	await present_text(npc.dialogue)
	talksprite.stop()
	talksprite.frame = 0
	
	var tree = get_tree()
	while not Input.is_action_pressed("interact"):
		await tree.process_frame
	
	talksprite_container.visible = false
	textbox_label.text = ""
	Game.unlock_player()

func _on_player_interact(thing):
	if thing.is_in_group("Npc"):
		do_npc_dialogue(thing)

func _on_inventory_grid_on_item_selected(item, slot_number):
	present_text("...", 0)

func _on_inventory_grid_on_item_hovered(item, slot_number):
	if item:
		present_text(item.name + ":\n" + item.description, 2)

func _show_hide_interactive_prompt(other):
	if other:
		interactable_prompt.show()
	else:
		interactable_prompt.hide()
