extends Control

@onready var item_rect = $MarginContainer/ItemSlot
@onready var highlight = $Highlight

var index : int = 0
var item

func set_highlighted(highlighted):
	highlight.visible = highlighted

func set_item(item):
	self.item = item
	if item == null:
		item_rect.visible = false
	else:
		item_rect.visible = true
		item_rect.texture = item.texture
