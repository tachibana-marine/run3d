extends GutTest


var collision_box_script = load("res://src/collision_box3d.gd")
var collision_box = null
var box = null
var box_material = null
var collision = null
var collision_shape = null

func before_each():
    collision_box = add_child_autofree(collision_box_script.new())
    box = collision_box.get_node("Box")
    box_material = box.material
    collision = collision_box.get_node("Collision")
    collision_shape = collision.shape

func test_change_size():
    collision_box.size = Vector3(1, 2, 3)
    assert_eq(collision_box.size, Vector3(1, 2, 3))
    assert_eq(box.size, Vector3(1, 2, 3))
    assert_eq(collision_shape.size, Vector3(1, 2, 3))

func test_size_is_greater_than_zero():
    collision_box.size = Vector3.ZERO
    assert_eq(collision_box.size, Vector3(1, 1, 1))
    
func test_change_color():
    collision_box.color = Color(0.3, 0.2, 0.1)
    assert_eq(collision_box.color, Color(0.3, 0.2, 0.1))
    assert_eq(box_material.albedo_color, Color(0.3, 0.2, 0.1))
