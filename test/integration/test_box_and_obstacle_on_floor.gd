extends GutTest

var box_scene = load("res://scene/box.tscn")
var obstacle_script = load("res://src/obstacle.gd")
var box = null
var obstacle = null

func before_each():
    add_child_autofree(CreateFloor.new().create())
    add_child_autofree(CreateCamera.new().create())
    box = add_child_autofree(box_scene.instantiate())
    obstacle = add_child_autofree(obstacle_script.new())
    await wait_until(func(): return box.is_on_floor(), 1)
    
func test_obstacle_moves_the_box():
    obstacle.speed = 10
    obstacle.position.z = 0
    obstacle.color = Color(1, 0, 0)
    box.position.z = 1
    await wait_seconds(.5)
    assert_almost_eq(box.position.z, 6.0, 0.25)
