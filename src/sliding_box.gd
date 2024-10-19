class_name SlidingBox
extends Box

const SLIDING_ACC = 490
func _physics_process(delta: float) -> void:
	velocity.z += SLIDING_ACC * delta
	super._physics_process(delta)
