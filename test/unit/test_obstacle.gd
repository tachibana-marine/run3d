extends GutTest
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

func test_has_size_property():
    assert_property(obstacle, "size", Vector3(1, 1, 1), Vector3(2, 3, 4))

func test_changing_size_also_changes_shape():
    obstacle.size = Vector3(4, 2, 3)
    assert_eq(collision.shape.size, Vector3(4, 2, 3))
    assert_eq(box.size, Vector3(4, 2, 3))

func test_obstacle_has_color_property():
    assert_property(obstacle, "color", Color(1, 1, 1), Color(.5, .5, 0))
    assert_eq(box_material.albedo_color, Color(.5, .5, 0))
