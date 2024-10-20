class_name CreateCamera

func create():
	var camera = Camera3D.new()
	camera.position = Vector3(0, 1, 4)
	camera.rotation.x = 0
	return camera
