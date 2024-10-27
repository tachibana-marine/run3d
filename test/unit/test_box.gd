extends GutTest


const GRAVITY = 98
const JUMP_VELOCITY_DEFAULT = sqrt(abs(2 * GRAVITY * 2))
const JUMP_VELOCITY_3_METERS = sqrt(abs(2 * GRAVITY * 3))
const TIME_TO_REACH_APEX_DEFAULT = JUMP_VELOCITY_DEFAULT / GRAVITY
const TIME_TO_REACH_APEX_3_METERS = JUMP_VELOCITY_3_METERS / GRAVITY
const TIME_TO_REACH_HALF_THE_APEX_DEFAULT = (JUMP_VELOCITY_DEFAULT - sqrt(pow(JUMP_VELOCITY_DEFAULT, 2) - GRAVITY * 2)) / GRAVITY
# const TIME_TO_REACH_APEX_DEFAULT = 0.20
# const TIME_TO_REACH_APEX_3_METERS = 0.24
# const TIME_TO_REACH_HALF_THE_APEX_DEFAULT = 0.059

var sender = InputSender.new(Input)
var box_script = load("res://src/box.gd")
var box = null

func before_each():
	add_child_autofree(CreateFloor.new().create())
	add_child_autofree(CreateCamera.new().create())

	box = add_child_autofree(box_script.new())

	# add Collison to the box
	box.add_child(CSGBox3D.new())
	var collision = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	collision.shape = box_shape
	box.add_child(collision)

	# add visible shape to the box
	var csgbox = CSGBox3D.new()
	box.add_child(csgbox)

	await wait_until(func(): return box.is_on_floor(), 1)
	

func after_each():
	sender.release_all()
	sender.clear()

# expect 5% error in jump height
func test_unit_jump_when_jump_action_is_pressed():
	var y = box.position.y
	assert_true(box.is_on_floor())
	sender.action_down("jump").hold_for(TIME_TO_REACH_APEX_DEFAULT)
	await (sender.idle)
	await wait_until(func(): return not box.is_on_floor(), 1)
	# wait until the box reaches the apex of the jump
	await wait_until(func(): return box.velocity.y < 0.0, 1)
	# default jump height is 2
	assert_almost_eq(box.position.y, 2.0, 0.1)
	assert_false(box.is_on_floor())

func test_setting_jump_height():
	box.jump_height = 3
	assert_true(box.is_on_floor())
	sender.action_down("jump").hold_for(TIME_TO_REACH_APEX_3_METERS)
	await (sender.idle)
	# wait until the box reaches the apex of the jump
	await wait_until(func(): return box.velocity.y < 0.0, 1)
	assert_almost_eq(box.position.y, 3.0, 0.15)
	
func test_change_jump_height_depending_on_button_hold():
	assert_true(box.is_on_floor())
	# I did the math
	sender.action_down("jump").hold_for(TIME_TO_REACH_HALF_THE_APEX_DEFAULT)
	await (sender.idle)
	await wait_until(func(): return box.velocity.y < 0.0, 1)
	# hold for half the time to jump half the height
	assert_almost_eq(box.position.y, 1.0, 0.05)

func test_move():
	assert_true(box.is_on_floor())
	sender.action_down("move_forward").hold_for(.1)
	await (sender.idle)
	assert_eq(box.velocity.z, -Box.MOVE_SPEED)

	box.position = Vector3.ZERO
	sender.action_down("move_backward").hold_for(.1)
	await (sender.idle)
	assert_eq(box.velocity.z, Box.MOVE_SPEED)

	box.position = Vector3.ZERO
	sender.action_down("move_left").hold_for(.1)
	await (sender.idle)
	assert_eq(box.velocity.x, -Box.MOVE_SPEED)

	box.position = Vector3.ZERO
	sender.action_down("move_right").hold_for(.1)
	await (sender.idle)
	assert_eq(box.velocity.x, Box.MOVE_SPEED)

func test_dash():
	# I don't care how fast the dash is.
	assert_true(box.is_on_floor())
	sender.action_down("dash_forward").hold_for(.1)
	await (sender.idle)
	assert_eq(box.velocity.z, -Box.DASH_SPEED)

	box.position = Vector3.ZERO
	sender.action_down("dash_backward").hold_for(.1)
	await (sender.idle)
	assert_eq(box.velocity.z, Box.DASH_SPEED)

	box.position = Vector3.ZERO
	sender.action_down("dash_left").hold_for(.1)
	await (sender.idle)
	assert_eq(box.velocity.x, -Box.DASH_SPEED)

	box.position = Vector3.ZERO
	sender.action_down("dash_right").hold_for(.1)
	await (sender.idle)
	assert_eq(box.velocity.x, Box.DASH_SPEED)

func test_diagonal_move_velocity_is_normalized(params = use_parameters([["move_right", "move_forward"], ["move_left", "move_forward"], \
	 ["move_right", "move_backward"], ["move_left", "move_backward"]])):
	sender.action_down(params[0]).action_down(params[1]).hold_for(.1)
	await wait_frames(1)
	print(Vector2(box.velocity.x, box.velocity.z))
	assert_almost_eq(Vector2(box.velocity.x, box.velocity.z).length(), Box.MOVE_SPEED, 0.001)
	await (sender.idle)

func test_diagonal_dash_velocity_is_normalized(params = use_parameters([["dash_right", "dash_forward"], ["dash_left", "dash_forward"], \
	 ["dash_right", "dash_backward"], ["dash_left", "dash_backward"]])):
	sender.action_down(params[0]).action_down(params[1]).hold_for(.1)
	await wait_frames(1)
	print(Vector2(box.velocity.x, box.velocity.z))
	assert_almost_eq(Vector2(box.velocity.x, box.velocity.z).length(), Box.DASH_SPEED, 0.001)
	await (sender.idle)


func test_move_with_intertia():
	assert_true(box.is_on_floor())
	sender.action_down("move_forward").hold_for(.1)
	await (sender.idle)
	assert_lt(box.velocity.z, 0.0)
