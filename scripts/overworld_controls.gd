extends MarginContainer

@onready var textbox_label = $HBoxContainer/TextBox/MarginContainer/Label

func present_text(text:String) -> void:
	textbox_label.text = text
	textbox_label.visible_characters = 0
	for x in text:
		textbox_label.visible_characters += 1
		await get_tree().create_timer(0.05).timeout
