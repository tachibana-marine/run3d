extends GutTest

var run_3d_script = load("res://src/run_3d.gd")
var run_3d = null
var obstacle_spawner = null
var obstacle_spawner_script = load("res://src/obstacle_spawner.gd")

# func before_each():
#     run_3d = add_child_autofree(run_3d_script.new())
#     obstacle_spawner = double(obstacle_spawner_script).new()
#     obstacle_spawner.name = "ObstacleSpawner"
#     run_3d.add_child(obstacle_spawner)

# func test_spawns_a_obstacle():
#     await wait_seconds(.1)
#     assert_call_count(obstacle_spawner, "spawn", 1)

# func test_spawn_obstacles_randomly():
#     await wait_seconds(.1)
