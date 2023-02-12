extends CharacterBody3D

@export var rotation_speed : float
@export var rotation_acceleration : float
@export var move_speed : float

var rotation_velocity : float

func _physics_process(delta):
	var input_hor = Input.get_axis("turn_left", "turn_right")
	var input_vert = Input.get_axis("move_forwards", "move_backwards")
	
	if input_hor != 0:
		rotation_velocity -= input_hor * delta * rotation_acceleration
	else:
		rotation_velocity = move_toward(rotation_velocity,0,delta * rotation_acceleration)
	rotation_velocity = clamp(rotation_velocity,-rotation_speed,rotation_speed)
	
	rotate_y(rotation_velocity * delta)
	
	velocity = transform.basis.z * input_vert * move_speed

	move_and_slide()
