extends CharacterBody3D
class_name Box

const SPEED = 5.0
const DASH_SPEED = 10.0
const JUMP_VELOCITY = 4.5
const FLICTION = 0.1

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity"):
	get:
		return gravity
		
var jump_height: float = 2:
	get:
		return jump_height
	set(value):
		jump_height = value

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(abs(2 * gravity * jump_height))
	elif (Input.is_action_just_released("jump") and not is_on_floor()):
		velocity.y = 0
	
		
	# Get the input direction and handle the movement/deceleration.
	var speed = SPEED
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dash_dir = Input.get_vector("dash_left", "dash_right", "dash_forward", "dash_backward")
	if (not dash_dir.is_zero_approx()):
		input_dir = dash_dir
		speed = DASH_SPEED
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = lerp(velocity.x, 0.0, FLICTION)
		velocity.z = lerp(velocity.z, 0.0, FLICTION)

	move_and_slide()
