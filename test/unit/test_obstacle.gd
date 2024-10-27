extends GutTest
var obstacle_script = load("res://src/obstacle.gd")
var obstacle = null

func before_each():
    obstacle = add_child_autofree(obstacle_script.new())
    add_child_autofree(CreateCamera.new().create())

func test_move_with_specified_speed():
    obstacle.speed = 40
    assert_eq(obstacle.speed, 40)
    await wait_seconds(.5)
    assert_almost_eq(obstacle.position, Vector3(0, 0, 20), Vector3(0, 0, 0.01))
