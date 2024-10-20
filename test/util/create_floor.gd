class_name CreateFloor

func create():
	var staticBody = StaticBody3D.new()
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size.x = 10
	box_shape.size.z = 10
	collision_shape.shape = box_shape
	staticBody.add_child(collision_shape)
	staticBody.position.y = -1
	return staticBody
