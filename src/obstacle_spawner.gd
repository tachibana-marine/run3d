class_name ObstacleSpawner
extends Node3D

var obstacle_scene = load("res://scene/obstacle.tscn")

var obstacles: Array[Obstacle] = []:
	get: return obstacles

var max_interval: float = 1:
	get: return max_interval
	set(value):
		max_interval = value
		_change_interval()

var min_interval: float = 1:
	get: return min_interval
	set(value):
		min_interval = value
		_change_interval()

var next_interval: float = -1.0:
	get: return next_interval

func spawn(speed = 10, _position = Vector3(0, 0, 0), size = Vector3(1, 1, 1)):
	var obstacle = obstacle_scene.instantiate()
	obstacle.speed = speed
	obstacle.position = _position
	obstacle.size = size
	obstacles.append(obstacle)
	add_child(obstacle)

func start():
	_change_interval()

func stop():
	$Timer.stop()

func _spawn_random_x():
	spawn(10, Vector3(randf_range(-2, 2), 0, 0))
	_change_interval()

func _change_interval():
	$Timer.stop()
	next_interval = randf_range(min_interval, max_interval)
	$Timer.start(next_interval)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.one_shot = true
	$Timer.connect("timeout", _spawn_random_x)
	next_interval = randf_range(min_interval, max_interval)
	$Timer.start(next_interval)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
