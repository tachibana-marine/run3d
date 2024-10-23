extends GutTest

var obstacle_spawner_script = load("res://src/obstacle_spawner.gd")
var obstacle_spawner = null
var timer = null
func before_each():
    obstacle_spawner = autofree(obstacle_spawner_script.new())
    timer = Timer.new()
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

func test_changing_interval_resets_timer():
    assert_eq(timer.wait_time, 1)
    obstacle_spawner.min_interval = .1
    obstacle_spawner.max_interval = .2
    assert_between(timer.wait_time, .1, .2)

func test_removed_obstacle_is_removed_from_obstacles():
    obstacle_spawner.spawn()
    obstacle_spawner.obstacles[0].queue_free()
    assert_eq(obstacle_spawner.obstacles.size(), 0)

func test_assign_same_value_to_min_and_max_to_get_fixed_interval():
    # assign the same value to both min and max for constant interval
    obstacle_spawner.min_interval = .1
    obstacle_spawner.max_interval = .1
    assert_eq(timer.wait_time, .1)

    obstacle_spawner.max_interval = .4
    obstacle_spawner.min_interval = .4
    assert_eq(timer.wait_time, .4)

func test_interval_should_be_greater_than_zero():
    obstacle_spawner.min_interval = 0
    assert_ne(obstacle_spawner.min_interval, 0)
    obstacle_spawner.max_interval = 0
    assert_ne(obstacle_spawner.max_interval, 0)

func test_interval_max_should_be_greater_than_min():
    # default value is 1
    obstacle_spawner.min_interval = 2
    assert_ne(obstacle_spawner.min_interval, 2)

    obstacle_spawner.max_interval = .5
    assert_ne(obstacle_spawner.max_interval, .5)

func test_stop_spawning_obstacles():
    obstacle_spawner.min_interval = .1
    obstacle_spawner.max_interval = .1
    await wait_seconds(.2)
    assert_eq(obstacle_spawner.obstacles.size(), 0)

    obstacle_spawner.start()
    await wait_seconds(.2)
    var size = obstacle_spawner.obstacles.size()
    assert_gte(size, 1)

    obstacle_spawner.stop()
    await wait_seconds(.2)
    assert_eq(obstacle_spawner.obstacles.size(), size)

func test_obstacle_x_axis_randomly_changes():
    # assign the same value to both min and max for constant interval
    obstacle_spawner.min_interval = .1
    obstacle_spawner.max_interval = .1
    obstacle_spawner.start()
    # Timer is not that accurate so it needs some margin
    await wait_seconds(.55)
    var obstacles = obstacle_spawner.obstacles
    assert_eq(obstacles.size(), 5)
    
    var previous = 0.0
    var duplicate_num = 0
    for obstacle in obstacles:
        if (previous == obstacle.position.x):
            duplicate_num += 1
        previous = obstacle.position.x
    # [0,1,0,1,0] would pass this assert, but I don't care that much
    assert_eq(duplicate_num, 0)

func test_obstacle_interval_randomly_changes_between_min_and_max():
    obstacle_spawner.min_interval = .1
    obstacle_spawner.max_interval = .25
    obstacle_spawner.start()

    var intervals = []
    for i in range(1 / .25): # 1/.25 == 4
        await wait_seconds(.25)
        intervals.append(timer.wait_time)
    var obstacles = obstacle_spawner.obstacles
    assert_gte(obstacles.size(), 4)
    assert_lte(obstacles.size(), 10)
    
    var previous = 0.0
    var duplicate_num = 0
    for interval in intervals:
        if (previous == interval):
            duplicate_num += 1
        previous = interval
    assert_eq(duplicate_num, 0)
