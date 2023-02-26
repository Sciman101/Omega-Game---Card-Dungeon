extends StaticBody3D

@export var talksprite : SpriteFrames
@export var talk_speed : float = 1

func do_npc_interaction(hud): pass

func do_dialogue(hud, text):
	var idx = text.find(':')
	if idx != -1:
		var animation_name = text.substr(0,idx)
		if animation_name != '' and talksprite.has_animation(animation_name):
			hud.talksprite.animation = animation_name
		else:
			print('Unknown animation ', animation_name)
		text = text.substr(idx + 1).strip_edges()
	
	hud.talksprite.play()
	await hud.textbox.present_text(text,talk_speed)
	hud.talksprite.stop()

func do_dialogue_sequence(hud, sequence):
	for line in sequence:
		await do_dialogue(hud, line)
		await hud.wait_for_input()
