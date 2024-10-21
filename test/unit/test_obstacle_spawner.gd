extends GutTest

var obstacle_spawner_script = load("res://src/obstacle_spawner.gd")
var obstacle_spawner = null
func before_each():
    obstacle_spawner = autofree(obstacle_spawner_script.new())
    var timer = Timer.new()
    timer.name = "Timer"
    obstacle_spawner.add_child(timer)
    add_child(obstacle_spawner)

func test_spawn_obstacles():
    obstacle_spawner.spawn()
    obstacle_spawner.spawn(20, Vector3(4, 3, 2), Vector3(2, 3, 4))
    var obstacles = obstacle_spawner.obstacles
    # default parameters
    assert_eq(obstacles.size(), 2)
    assert_eq(obstacles[0].position, Vector3(0, 0, 0))
    assert_eq(obstacles[0].size, Vector3(1, 1, 1))
    assert_eq(obstacles[0].speed, 10)
    # custom parameters
    assert_eq(obstacles[1].position, Vector3(4, 3, 2))
    assert_eq(obstacles[1].size, Vector3(2, 3, 4))
    assert_eq(obstacles[1].speed, 20)

func test_has_interval_property():
    assert_property(obstacle_spawner, "interval", 1, 0.1)

func test_spawn_obstacle_with_interval():
    obstacle_spawner.interval = .1
    await wait_seconds(1)
    var obstacles = obstacle_spawner.obstacles
    assert_eq(obstacles.size(), 10)