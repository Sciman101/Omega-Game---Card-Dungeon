extends MarginContainer

@onready var inventory_slots = $HBoxContainer/InventoryGrid.get_children()
@onready var textbox_label = $HBoxContainer/TextBox/Margins/Label
@onready var talksprite_container = $"../PlayerView/EnvironmentViewport/Talksprite"
@onready var talksprite = $"../PlayerView/EnvironmentViewport/Talksprite/Talksprite"

var player

func _ready():
	await get_tree().process_frame
	if Game.player:
		Game.player.interact.connect(_on_player_interact)
	else:
		print("Warning! No player node found!!")

func present_text(text:String) -> void:
	textbox_label.text = text
	textbox_label.visible_characters = 0
	for x in text:
		textbox_label.visible_characters += 1
		await get_tree().create_timer(0.05).timeout

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
