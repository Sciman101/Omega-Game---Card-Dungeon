extends MarginContainer

@onready var inventory_slots = $HBoxContainer/InventoryGrid.get_children()
@onready var textbox_label = $HBoxContainer/TextBox/Margins/Label

func present_text(text:String) -> void:
	textbox_label.text = text
	textbox_label.visible_characters = 0
	for x in text:
		textbox_label.visible_characters += 1
		await get_tree().create_timer(0.05).timeout
