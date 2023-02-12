extends HBoxContainer

const ButtonNameMap = {
	BtnLeft = 'turn_left',
	BtnRight = 'turn_right',
	BtnFwd = 'move_forwards',
	BtnBack = 'move_backwards',
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for btn in get_children():
		btn.button_down.connect(button_event.bind(btn.name,true))
		btn.button_up.connect(button_event.bind(btn.name,false))

func button_event(btn_name, state):
	var action = ButtonNameMap[btn_name]
	if state:
		Input.action_press(action)
	else:
		Input.action_release(action)
