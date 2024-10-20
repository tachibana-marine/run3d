extends GutTest

var floor_scene = load("res://test/scene/Floor.tscn")
var box_scene = load("res://scene/box.tscn")
var obstacle_scene = load("res://scene/obstacle.tscn")
var box = null
var obstacle = null
var _floor = null

func before_each():
    _floor = add_child_autofree(floor_scene.instantiate())
    box = add_child_autofree(box_scene.instantiate())
    obstacle = add_child_autofree(obstacle_scene.instantiate())
    await wait_until(func(): return box.is_on_floor(), 1)
    
func test_obstacle_moves_the_box():
    obstacle.speed = 10
    obstacle.position.z = 0
    obstacle.color = Color(1, 0, 0)
    box.position.z = 1
    await wait_seconds(.5)
    assert_almost_eq(box.position.z, 6, 0.25)