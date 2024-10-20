extends GutTest

const FPS = 60
const DELTA = 1.0 / FPS

var obstacle_script = load("res://src/obstacle.gd")
var obstacle = null
var collision = null
var collision_shape = null
var box = null
var box_material = null

func before_each():
    obstacle = add_child_autofree(obstacle_script.new())
    add_child_autofree(CreateCamera.new().create())

    # create collisions
    collision = CollisionShape3D.new()
    collision_shape = BoxShape3D.new()
    box = CSGBox3D.new()
    box_material = StandardMaterial3D.new()
    box.material = box_material
    collision.shape = collision_shape

    # name the children
    collision.name = "CollisionShape"
    box.name = "Box"

    obstacle.add_child(collision)
    obstacle.add_child(box)

func test_move_with_specified_speed():
    obstacle.speed = 40
    assert_eq(obstacle.speed, 40)
    await wait_seconds(.5)
    assert_almost_eq(obstacle.position, Vector3(0, 0, 20), Vector3(0, 0, 0.01))

func test_change_geometry_of_shape():
    obstacle.width = 4
    obstacle.height = 2
    obstacle.depth = 3
    assert_eq(collision_shape.size.x, 4.0)
    assert_eq(collision_shape.size.y, 2.0)
    assert_eq(collision_shape.size.z, 3.0)
    assert_eq(box.size.x, 4.0)
    assert_eq(box.size.y, 2.0)
    assert_eq(box.size.z, 3.0)

func test_obstacle_has_color_property():
    assert_property(obstacle, "color", Color(1, 1, 1), Color(.5, .5, 0))
    assert_eq(box_material.albedo_color, Color(.5, .5, 0))
