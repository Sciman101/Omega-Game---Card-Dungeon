extends CharacterBody3D

@export var rotation_speed : float
@export var rotation_acceleration : float
@export var move_speed : float
@export var sprint_speed : float
@export var gravity : float

@export var headbob_rate : float
@export var headbob_rate_sprint : float
@export var headbob_amplitude : float

@onready var camera = $Camera3D

var rotation_velocity : float
var headbob_anim : float

var yspeed : float

func _physics_process(delta):
	var input_hor = Input.get_axis("left", "right")
	var input_vert = Input.get_axis("up", "down")
	var sprint = Input.is_action_pressed("sprint")
	
	if is_on_floor():
		velocity.y = -gravity
	else:
		velocity.y -= gravity
	
	if input_hor != 0:
		rotation_velocity -= input_hor * delta * rotation_acceleration
	else:
		rotation_velocity = move_toward(rotation_velocity,0,delta * rotation_acceleration)
	rotation_velocity = clamp(rotation_velocity,-rotation_speed,rotation_speed)
	
	if input_vert != 0:
		if sprint:
			headbob_anim += delta * headbob_rate_sprint
		else:
			headbob_anim += delta * headbob_rate
		if headbob_anim > PI:
			headbob_anim -= PI
	else:
		headbob_anim = move_toward(headbob_anim,0,delta)
	camera.v_offset = sin(headbob_anim) * headbob_amplitude
	
	rotate_y(rotation_velocity * delta * (2 if sprint else 1))
	
	var move
	if sprint:
		move = transform.basis.z * input_vert * sprint_speed
	else:
		move = transform.basis.z * input_vert * move_speed
	velocity.x = move.x
	velocity.z = move.z

	move_and_slide()
