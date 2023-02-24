extends StaticBody3D

@export var talksprite : SpriteFrames

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
	
	await hud.textbox.present_text(text)
