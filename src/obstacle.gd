extends CollisionBox3D
class_name Obstacle
@export var speed: int = 20:
	get:
		return speed
	set(value):
		speed = value


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	position.z += speed * delta
