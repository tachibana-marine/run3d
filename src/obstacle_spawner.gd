@tool
class_name ObstacleSpawner
extends Node3D

var obstacle_script = load("res://src/obstacle.gd")

@export var max_interval: float = 1:
	get: return max_interval
	set(value):
		if (value <= 0 or value < min_interval):
			return
		max_interval = value
		_change_interval()

@export var min_interval: float = 1:
	get: return min_interval
	set(value):
		if (value <= 0 or value > max_interval):
			return
		min_interval = value
		_change_interval()

@export var max_size: Vector3 = Vector3(1, 1, 1):
	get: return max_size
	set(value):
		if (value < min_size or value <= Vector3.ZERO):
			return
		max_size = value


@export var min_size: Vector3 = Vector3(1, 1, 1):
	get: return min_size
	set(value):
		if (value > max_size or value <= Vector3.ZERO):
			return
		min_size = value

func spawn(speed = 10, _position = Vector3(0, 0, 0), size = Vector3(1, 1, 1)):
	var obstacle = obstacle_script.new()
	obstacle.speed = speed
	obstacle.position = _position
	obstacle.size = size
	$Obstacles.add_child(obstacle)

func start():
	_change_interval()
	$Timer.start()

func stop():
	$Timer.stop()

func _on_timer_timeout():
	spawn(10, Vector3(randf_range(-2, 2), 0, 0), Vector3(randf_range(0.5, 1.5), randf_range(0.5, 1.5), 1))
	start()

func _change_interval():
	$Timer.stop()
	$Timer.wait_time = randf_range(min_interval, max_interval)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		add_child(obstacle_script.new())
		return
	var timer = Timer.new()
	timer.name = "Timer"
	timer.one_shot = true
	timer.autostart = false
	timer.process_callback = Timer.TimerProcessCallback.TIMER_PROCESS_PHYSICS
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)

	var container = Node3D.new()
	container.name = "Obstacles"
	add_child(container)
