extends CharacterBody3D

@export var rotation_speed : float
@export var rotation_acceleration : float
@export var move_speed : float
@export var sprint_speed : float
@export var gravity : float
@export var jump_speed : float

@export var headbob_rate : float
@export var headbob_rate_sprint : float
@export var headbob_amplitude : float

@onready var camera = $Camera3D
@onready var ray = $InteractRay

signal in_proximity_to_interactible(other)
signal interact(other)

var rotation_velocity : float
var headbob_anim : float

var current_interactible

func _ready():
	Game.player = self

func _physics_process(delta):
	var input_hor = Input.get_axis("left", "right")
	var input_vert = Input.get_axis("up", "down")
	var sprint = Input.is_action_pressed("sprint")
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
		else:
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
	
	var interactable = ray.get_collider()
	if interactable and interactable.is_in_group("Interactible"):
		if current_interactible != interactable:
			in_proximity_to_interactible.emit(interactable)
			current_interactible = interactable
	elif interactable == null and current_interactible != null:
		current_interactible = null
		in_proximity_to_interactible.emit(null)
	
	# Interact
	if Input.is_action_just_pressed("interact"):
		if current_interactible:
			interact.emit(current_interactible)
