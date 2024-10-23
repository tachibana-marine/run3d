class_name ObstacleSpawner
extends Node3D

var obstacle_scene = load("res://scene/obstacle.tscn")

var obstacles: Array[Obstacle] = []:
	get: return obstacles

var max_interval: float = 1:
	get: return max_interval
	set(value):
		if (value <= 0):
			return
		if (value < min_interval):
			return
		max_interval = value
		_change_interval()

var min_interval: float = 1:
	get: return min_interval
	set(value):
		if (value <= 0):
			return
		if (value > max_interval):
			return
		min_interval = value
		_change_interval()

func spawn(speed = 10, _position = Vector3(0, 0, 0), size = Vector3(1, 1, 1)):
	var obstacle = obstacle_scene.instantiate()
	obstacle.speed = speed
	obstacle.position = _position
	obstacle.size = size
	obstacles.append(obstacle)
	add_child(obstacle)

func start():
	_change_interval()
	$Timer.start()

func stop():
	$Timer.stop()

func _on_timer_timeout():
	spawn(10, Vector3(randf_range(-2, 2), 0, 0))
	start()

func _change_interval():
	$Timer.stop()
	$Timer.wait_time = randf_range(min_interval, max_interval)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.one_shot = true
	$Timer.process_callback = Timer.TimerProcessCallback.TIMER_PROCESS_PHYSICS
	$Timer.connect("timeout", _on_timer_timeout)
	$Timer.stop()
