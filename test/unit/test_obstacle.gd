extends GutTest

const FPS = 60
const DELTA = 1.0 / FPS

var obstacle_script = load("res://src/obstacle.gd")
var obstacle = null
var collision = null
var shape = null

func before_each():
    obstacle = add_child_autofree(obstacle_script.new())
    collision = CollisionShape3D.new()
    shape = BoxShape3D.new()
    collision.shape = shape
    collision.name = "CollisionShape"
    obstacle.add_child(collision)

func test_move_with_specified_speed():
    obstacle.speed = 40
    await wait_seconds(1)
    assert_eq(obstacle.speed, 40)
    assert_almost_eq(obstacle.position, Vector3(0, 0, 40), Vector3(0, 0, 0.01))

func test_change_geometry_of_shape():
    obstacle.width = 4
    obstacle.height = 2
    obstacle.depth = 3
    assert_eq(shape.size.x, 4)
    assert_eq(shape.size.y, 2)
    assert_eq(shape.size.z, 3)