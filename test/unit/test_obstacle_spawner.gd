extends GutTest

const FPS = 60
const DELTA = 1.0 / FPS

var obstacle_spawner_script = load("res://src/obstacle_spawner.gd")
var obstacle_spawner = null
func before_each():
    obstacle_spawner = add_child_autofree(obstacle_spawner_script.new())

func test_spawn_obstacle():
    obstacle_spawner.spawn(20, Vector3(2, 3, 4))
    var obstacles = obstacle_spawner.obstacles
    assert_eq(obstacles.size(), 1)
    assert_eq(obstacles[0].size, Vector3(2, 3, 4))
    assert_eq(obstacles[0].speed, 20)
