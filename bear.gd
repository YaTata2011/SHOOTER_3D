extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const rotate_value = 0.05
@onready var start_pos = position
@export var path_length = 8

const time_recharge = 0.5
var recharge_timer = time_recharge

var hp = 3

# Стани
const STATE_PATROOL = 0

var STATE = STATE_PATROOL

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var anim = $bear/AnimationPlayer

var is_rotate = false
var rotate_angle = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3.FORWARD).normalized()
	
	if STATE == STATE_PATROOL:
		anim.play("move")
		if start_pos.distance_to(position) >= path_length/2:
			is_rotate = true
						
			
		if is_rotate == true:
			rotate_y(rotate_value)
			rotate_angle += rotate_value
			if rotate_angle >= deg_to_rad(180):
				is_rotate = false
				rotate_angle = 0
			else:
				direction = 0
	
	# Рух
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	recharge_timer += delta
	
	move_and_slide()
	
func damage():
	hp -= 1
	if hp <= 0:
		anim.play("die_bear")
		queue_free()
