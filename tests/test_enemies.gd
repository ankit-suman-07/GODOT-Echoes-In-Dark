extends SceneTree
## Real Area2D overlap transitions in an unobstructed physics arena.
var checks := 0
var failures := 0

func _initialize() -> void:
	_run.call_deferred()

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)

func settle() -> void:
	for tick in range(5):
		await physics_frame

func _run() -> void:
	var arena := Node2D.new()
	root.add_child(arena)
	var player: CharacterBody2D = load("res://scenes/player.tscn").instantiate()
	player.name = "player"
	player.rotation = 0.0
	player.position = Vector2(0, 1000)
	arena.add_child(player)
	player.set_physics_process(false)
	var enemies: Array[CharacterBody2D] = []
	for index in range(3):
		var scene := "enemy_fire" if index == 1 else "enemy"
		var enemy: CharacterBody2D = load("res://scenes/" + scene + ".tscn").instantiate()
		enemy.position = Vector2(index * 1000, 0)
		if index == 2:
			enemy.detection_radius = 350.0
		arena.add_child(enemy)
		enemy.set_physics_process(false)
		enemies.append(enemy)
	var first_shape: Shape2D = enemies[0].get_node("DetectionArea/CollisionShape2D2").shape
	var third_shape: Shape2D = enemies[2].get_node("DetectionArea/CollisionShape2D2").shape
	check(first_shape != third_shape and first_shape.radius == 250 and third_shape.radius == 350, "Instanced radii are configurable and independent")
	await settle()
	for index in range(3):
		var enemy := enemies[index]
		player.position = enemy.position + Vector2(150, 0)
		await settle()
		check(enemy.player_chase, "Physics entry starts pursuit " + str(index))
		for other in enemies:
			if other != enemy:
				check(not other.player_chase, "Other enemies stay idle")
		enemy._physics_process(1.0 / 60.0)
		check(enemy.velocity.x > 0 and is_equal_approx(enemy.velocity.length(), 150), "Detected target is chased at configured speed")
		if index == 1:
			check(enemy.get_node("fire_light").enabled, "Fire light follows detection")
		player.position = enemy.position + Vector2(enemy.detection_radius + 100, 0)
		await settle()
		enemy._physics_process(1.0 / 60.0)
		check(not enemy.player_chase and enemy.velocity == Vector2.ZERO, "Physics exit stops pursuit " + str(index))
		if index == 1:
			check(not enemy.get_node("fire_light").enabled, "Fire light stops on exit")
	# Exercise actual unchanged player input speeds and relative escape over time.
	player.position = Vector2(0, 1000)
	Input.action_press("forward")
	player._physics_process(1.0 / 60.0)
	check(player.velocity.length() == 200, "Player walking remains 200")
	Input.action_press("sprint")
	player._physics_process(1.0 / 60.0)
	check(player.velocity.length() == 500, "Player sprint remains 500")
	Input.action_release("sprint")
	Input.action_release("forward")
	for enemy in enemies:
		player.position = enemy.position + Vector2(0, -150)
		await settle()
		var distance := player.position.distance_to(enemy.position)
		for tick in range(330):
			Input.action_press("forward")
			player._physics_process(1.0 / 60.0)
			enemy._physics_process(1.0 / 60.0)
			await physics_frame
		Input.action_release("forward")
		check(player.position.distance_to(enemy.position) > distance and not enemy.player_chase, "Walking escapes pursuit")
	# An oversized diagonal movement step must not overshoot the stopping gap.
	for enemy in enemies:
		player.position = enemy.position + Vector2(120, -120)
		await settle()
		var original_speed: float = enemy.SPEED
		enemy.SPEED = 10000.0
		enemy._physics_process(1.0 / 60.0)
		enemy.SPEED = original_speed
		check(absf(player.position.distance_to(enemy.position) - enemy.stopping_distance) < 0.1, "Oversized diagonal step ends at stopping clearance")
		player.position = enemy.position + Vector2(50, 0)
		await settle()
		enemy._physics_process(1.0 / 60.0)
		check(enemy.velocity == Vector2.ZERO, "Player entering stopping gap does not trigger pushing")
	# Pin the player against a real wall, then escape parallel to it.
	for index in range(enemies.size()):
		var enemy := enemies[index]
		enemy.position = Vector2(index * 1000, 0)
		var wall := StaticBody2D.new()
		var collider := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = Vector2(20, 800)
		collider.shape = shape
		wall.add_child(collider)
		wall.position = enemy.position + Vector2(200, 0)
		arena.add_child(wall)
		player.position = enemy.position + Vector2(157.9, 0)
		await settle()
		for tick in range(80):
			enemy._physics_process(1.0 / 60.0)
			await physics_frame
		check(player.position.distance_to(enemy.position) >= 95.9, "Enemy leaves clearance at wall")
		check(enemy.velocity == Vector2.ZERO and enemy.get_slide_collision_count() == 0, "Enemy stops before continuous actor contact")
		var start := player.position
		Input.action_press("forward")
		for tick in range(60):
			player._physics_process(1.0 / 60.0)
			enemy._physics_process(1.0 / 60.0)
			await physics_frame
		Input.action_release("forward")
		check(player.position.y < start.y - 190, "Player can walk along wall to escape")
		player.rotation = PI / 2
		Input.action_press("forward")
		for tick in range(15):
			player._physics_process(1.0 / 60.0)
			await physics_frame
		Input.action_release("forward")
		check(player.position.x <= wall.position.x - 41.9, "Wall still blocks player")
		player.rotation = 0.0
		enemy.position = wall.position + Vector2(150, -200)
		await settle()
		for tick in range(90):
			enemy._physics_process(1.0 / 60.0)
			await physics_frame
		check(enemy.position.x >= wall.position.x + 49.9, "Wall still blocks enemy")
		wall.queue_free()
		await settle()
	# Deleted references must clear chase/velocity, even without an exit callback.
	for enemy in enemies:
		if enemy.has_method("_on_area_2d_body_entered"):
			enemy._on_area_2d_body_entered(player)
		else:
			enemy._on_detection_area_body_entered(player)
	player.free()
	for enemy in enemies:
		enemy._physics_process(1.0 / 60.0)
		check(not enemy.player_chase and enemy.velocity == Vector2.ZERO, "Deleted target safely clears pursuit")
	arena.queue_free()
	await process_frame
	var level: Node2D = load("res://scenes/level.tscn").instantiate()
	root.add_child(level)
	await settle()
	var actors := [level.get_node("enemy"), level.get_node("enemy_fire"), level.get_node("enemy_2")]
	for actor in actors:
		var cell := Vector2i((actor.position / 32).floor())
		check(level.get_node("Geometry").floor_cells.has(cell), "Enemy spawn is on existing floor")
	level.has_exit_key = true
	level.get_node("D09").is_open = true
	level._on_exit_entered(level.get_node("player"))
	for actor in actors:
		check(not actor.is_physics_processing() and actor.velocity == Vector2.ZERO, "Escape stops every enemy")
	level.queue_free()
	await process_frame
	print("Enemy checks: %d, failures: %d" % [checks, failures])
	quit(1 if failures else 0)
