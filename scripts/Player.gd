extends CharacterBody3D

@export var rotation_speed : float
@export var move_speed : float
@export var gravity : float
@export var jump_speed : float

@export var headbob_rate : float
@export var headbob_rate_sprint : float
@export var headbob_amplitude : float

@onready var camera = $Camera3D
@onready var ray = $InteractRay

signal in_proximity_to_interactible(other)
signal interact(other)
signal view_inventory

var rotation_accum : float
var headbob_anim : float

var current_interactible

func _ready():
	Game.player = self

func _physics_process(delta):
	var input_hor = Input.get_axis("left", "right")
	var input_vert = Input.get_axis("up", "down")
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
		else:
			velocity.y = -gravity
	else:
		velocity.y -= gravity
	
	if input_hor != 0:
		rotate_y(rotation_speed * input_hor * -delta)
	
	if input_vert != 0:
		headbob_anim += delta * headbob_rate
		if headbob_anim > PI:
			headbob_anim -= PI
	else:
		headbob_anim = move_toward(headbob_anim,0,delta)
	camera.v_offset = sin(headbob_anim) * headbob_amplitude
	
	var move = transform.basis.z * input_vert * move_speed
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
	
	if Input.is_action_just_pressed("inventory"):
		view_inventory.emit()
	
	# Interact
	if Input.is_action_just_pressed("interact"):
		if current_interactible:
			if current_interactible.has_method('on_interact'):
				current_interactible.on_interact()
			interact.emit(current_interactible)
