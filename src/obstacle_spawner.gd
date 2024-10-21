class_name ObstacleSpawner
extends Node3D

var obstacle_scene = load("res://scene/obstacle.tscn")

var obstacles: Array[Obstacle] = []:
	get: return obstacles

var interval: float = 1:
	get: return interval
	set(value):
		$Timer.stop()
		interval = value
		$Timer.wait_time = value
		$Timer.start()

func spawn(speed = 10, _position = Vector3(0, 0, 0), size = Vector3(1, 1, 1)):
	var obstacle = obstacle_scene.instantiate()
	obstacle.speed = speed
	obstacle.position = _position
	obstacle.size = size
	obstacles.append(obstacle)
	add_child(obstacle)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = interval
	$Timer.connect("timeout", spawn)
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
