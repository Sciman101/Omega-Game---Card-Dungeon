extends ColorRect

@onready var textbox_label = $Margins/Label

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
