extends AnimatableBody3D
class_name Obstacle

var size: Vector3 = Vector3(1, 1, 1):
	get:
		return size
	set(value):
		size = value
		$CollisionShape.shape.size = value
		$Box.size = value

var speed: int = 20:
	get:
		return speed
	set(value):
		speed = value

var color: Color = Color(1, 1, 1):
	get:
		return color
	set(value):
		color = value
		$Box.material.albedo_color = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	position.z += speed * delta
