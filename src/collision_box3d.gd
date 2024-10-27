@tool
extends AnimatableBody3D
class_name CollisionBox3D

@export var size: Vector3 = Vector3(1, 1, 1):
    get:
        return size
    set(value):
        if (value <= Vector3.ZERO):
            return
        size = value
        $Collision.shape.size = value
        $Box.size = value

@export var color: Color = Color(1, 1, 1):
    get:
        return color
    set(value):
        color = value
        $Box.material.albedo_color = value


func _init():
    var box = CSGBox3D.new()
    box.name = "Box"
    box.material = StandardMaterial3D.new()
    add_child(box)

    var collision = CollisionShape3D.new()
    collision.name = "Collision"
    collision.shape = BoxShape3D.new()
    add_child(collision)
