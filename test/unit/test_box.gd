extends GutTest

const FPS = 60
const DELTA = 1.0 / FPS

var sender = InputSender.new(Input)
var box_on_surface = load("res://test/scene/box_on_surface.tscn")
var scene

func before_each():
	scene = add_child_autofree(box_on_surface.instantiate())
	simulate(scene, 1, DELTA)

func after_each():
	sender.release_all()
	sender.clear()

func test_jump_when_jump_action_is_pressed():
	var box = scene.get_node("Box")
	var y = box.position.y
	assert_true(box.is_on_floor())
	sender.action_down("jump").hold_for(.1)
	await (sender.idle)
	await wait_until(func(): return not box.is_on_floor(), 1)
	simulate(box, 3, DELTA)
	assert_lt(y, box.position.y)
	assert_false(box.is_on_floor())

func test_limit_jump_height():
	var box = scene.get_node("Box")
	box.jump_height = 1
	assert_true(box.is_on_floor())
	sender.action_down("jump").hold_for(.1)
	await (sender.idle)
	# wait until the box reaches the apex of the jump
	await wait_until(func(): return box.velocity.y < 0, 1)
	assert_lt(box.position.y, 1)
	

#	var box: Box = test_scene.find_child("Box")
#	var y_before = box.position.y
#	test_scene.simulate_key_press(KEY_SPACE)
#	await test_scene.await_input_processed()
