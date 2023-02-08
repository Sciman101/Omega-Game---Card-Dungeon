extends CharacterBody3D

@export var rotation_speed : float
@export var rotation_acceleration : float
@export var move_speed : float

@onready var spin_timer = $SpinTimer

var rotation_velocity : float

var spin_tween : Tween

func _physics_process(delta):
	var input_hor = Input.get_axis("ui_left", "ui_right")
	var input_vert = Input.get_axis("ui_up", "ui_down")
	
	if spin_timer.is_stopped():
		if Input.is_action_just_pressed("ui_down"):
			spin_timer.start()
	
	if input_hor != 0:
		rotation_velocity -= input_hor * delta * rotation_acceleration
	else:
		rotation_velocity = move_toward(rotation_velocity,0,delta * rotation_acceleration)
	rotation_velocity = clamp(rotation_velocity,-rotation_speed,rotation_speed)
	
	rotate_y(rotation_velocity * delta)
	
	velocity = transform.basis.z * input_vert * move_speed

	move_and_slide()


func _on_spin_timer_timeout():
	if not Input.is_action_pressed("ui_down"):
		if not spin_tween or not spin_tween.is_running():
			# Spin 180
			var target_angle = rotation.y + PI
			spin_tween = get_tree().create_tween()
			spin_tween.tween_property(self,'rotation:y',target_angle,0.2)
