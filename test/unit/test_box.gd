extends GutTest

const FPS = 60
const DELTA = 1.0 / FPS
const TIME_TO_REACH_APEX_DEFAULT = 0.20
const TIME_TO_REACH_APEX_3_METERS = 0.24
const TIME_TO_REACH_HALF_THE_APEX_DEFAULT = 0.059

var sender = InputSender.new(Input)
var box_on_surface = load("res://test/scene/box_on_surface.tscn")
var scene = null
var box = null

func before_each():
	scene = add_child_autofree(box_on_surface.instantiate())
	box = scene.get_node("Box")
	await wait_until(func(): return box.is_on_floor(), 1)
	

func after_each():
	# Calculate and print values for parameters
	# var v = sqrt(abs(2 * box.gravity * box.jump_height))
	# gut.p(v / box.gravity)
	# gut.p((v - sqrt(v * v - box.gravity * box.jump_height)) / box.gravity)
	sender.release_all()
	sender.clear()

# expect 5% error in jump height
func test_jump_when_jump_action_is_pressed():
	var y = box.position.y
	assert_true(box.is_on_floor())
	# sqrt(abs(2 * box.gravity * box.jump_height)) / box.gravity = 0.64
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
	assert_lt(box.velocity.z, 0.0)

	box.position = Vector3.ZERO
	sender.action_down("move_backward").hold_for(.1)
	await (sender.idle)
	assert_gt(box.velocity.z, 0.0)

	box.position = Vector3.ZERO
	sender.action_down("move_left").hold_for(.1)
	await (sender.idle)
	assert_lt(box.velocity.x, 0.0)

	box.position = Vector3.ZERO
	sender.action_down("move_right").hold_for(.1)
	await (sender.idle)
	assert_gt(box.velocity.x, 0.0)

func test_dash():
	# I don't care how fast the dash is.
	assert_true(box.is_on_floor())
	sender.action_down("dash_forward").hold_for(.1)
	await (sender.idle)
	assert_lt(box.velocity.z, 0.0)

	box.position = Vector3.ZERO
	sender.action_down("dash_backward").hold_for(.1)
	await (sender.idle)
	assert_gt(box.velocity.z, 0.0)

	box.position = Vector3.ZERO
	sender.action_down("dash_left").hold_for(.1)
	await (sender.idle)
	assert_lt(box.velocity.x, 0.0)

	box.position = Vector3.ZERO
	sender.action_down("dash_right").hold_for(.1)
	await (sender.idle)
	assert_gt(box.velocity.x, 0.0)

func test_move_with_intertia():
	assert_true(box.is_on_floor())
	sender.action_down("move_forward").hold_for(.1)
	await (sender.idle)
	assert_lt(box.velocity.z, 0.0)
