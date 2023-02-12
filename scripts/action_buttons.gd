extends GridContainer

func _ready():
	for node in get_children():
		node.connect('button_down',Input.action_press.bind(node.name))
		node.connect('button_up',Input.action_release.bind(node.name))
