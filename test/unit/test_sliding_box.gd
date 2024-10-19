extends GutTest
var sender = InputSender.new(Input)
var box_on_surface = load("res://test/scene/sliding_box_on_surface.tscn")
var scene = null
var box = null

func before_each():
	scene = add_child_autofree(box_on_surface.instantiate())
	box = scene.get_node("SlidingBox")
	await wait_until(func(): return box.is_on_floor(), 1)
	

func after_each():
	sender.release_all()
	sender.clear()

func test_jump_when_jump_action_is_pressed():
	var z = box.position.z
	assert_true(box.is_on_floor())
	await wait_frames(5)
	assert_gt(box.position.z, z)
