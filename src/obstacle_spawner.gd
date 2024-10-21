extends Node3D

var obstacle_scene = load("res://scene/obstacle.tscn")

var obstacles: Array[Obstacle] = []:
	get:
		return obstacles
		
func spawn(speed = 10, size = Vector3(1, 1, 1)):
	var obstacle = obstacle_scene.instantiate()
	obstacle.speed = speed
	obstacle.size = size
	obstacles.append(obstacle)
	add_child(obstacle)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
