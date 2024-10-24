@tool
extends AnimatableBody3D
class_name Obstacle

@export var size: Vector3 = Vector3(1, 1, 1):
	get:
		return size
	set(value):
		size = value
		$CollisionShape.shape.size = value
		$Box.size = value

@export var speed: int = 20:
	get:
		return speed
	set(value):
		speed = value

@export var color: Color = Color(1, 1, 1):
	get:
		return color
	set(value):
		color = value
		$Box.material.albedo_color = value

# Called when the node enters the scene tree for the first time.
func _init():
	var box = CSGBox3D.new()
	box.name = "Box"
	box.material = StandardMaterial3D.new()
	add_child(box)

	var collision = CollisionShape3D.new()
	collision.name = "CollisionShape"
	collision.shape = BoxShape3D.new()
	add_child(collision)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	position.z += speed * delta
