extends AnimatableBody3D
class_name Obstacle

var speed: int = 20:
	get:
		return speed
	set(value):
		speed = value

var width: int = 1:
	get:
		return width
	set(value):
		width = value
		$CollisionShape.shape.size.x = value

var height: int = 1:
	get:
		return height
	set(value):
		height = value
		$CollisionShape.shape.size.y = value

var depth: int = 1:
	get:
		return depth
	set(value):
		depth = value
		$CollisionShape.shape.size.z = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	move_and_collide(Vector3(0, 0, speed) * delta)
