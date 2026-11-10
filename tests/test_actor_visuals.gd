extends SceneTree
var checks := 0
var failures := 0

func _initialize() -> void:
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _run() -> void:
	var level: Node2D = load("res://scenes/level.tscn").instantiate()
	root.add_child(level)
	await physics_frame
	var player: CharacterBody2D = level.get_node("player")
	var visual: Sprite2D = player.get_node("Sprite2D")
	visual.set_process(false)
	check(visual.hframes == 4, "Four-frame player sheet")
	check(visual.get_rect().size == Vector2(32, 32), "Frame crops to 32x32")
	check(visual.scale == Vector2(2, 2), "Player art spans 64 world units")
	check(is_equal_approx(player.get_node("CollisionShape2D").shape.radius, 5.3333335), "Player shape unchanged")
	check(player.get_node("CollisionShape2D").scale == Vector2(6, 6), "Player collider scaling unchanged")
	for direction in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		player.velocity = direction * 200
		var before := player.transform
		var previous_frame := visual.frame
		visual.update_visual(0.2)
		var expected: Texture2D = visual.up_sheet if direction == Vector2.UP else visual.down_sheet
		if direction == Vector2.LEFT: expected = visual.left_sheet
		if direction == Vector2.RIGHT: expected = visual.right_sheet
		check(visual.texture == expected, "Correct player sheet: " + str(direction))
		check(player.transform == before, "Visual does not rotate or move body")
		check(visual.frame != previous_frame and visual.frame < 4, "Moving player animates")
	player.velocity = Vector2.ZERO
	player.rotation = PI / 2
	visual.update_visual(0.5)
	check(visual.texture == visual.right_sheet and visual.frame == 0, "Idle turn follows body facing")
	check(is_zero_approx(visual.global_rotation), "Player art stays upright")
	player.set_physics_process(false)
	player.velocity = Vector2(500, 0)
	visual.update_visual(0.5)
	check(visual.frame == 0, "Animation stops when actor stops processing")
	for actor_name in ["enemy", "enemy_fire"]:
		var enemy: CharacterBody2D = level.get_node(actor_name)
		var enemy_visual: Sprite2D = enemy.get_node("Sprite2D")
		enemy_visual.set_process(false)
		check(enemy_visual.texture.resource_path == "res://assets/echoes_assets/characters/enemy_down.svg", "Enemy uses supplied art")
		check(enemy_visual.hframes == 4 and enemy_visual.get_rect().size == Vector2(32, 32), "Enemy frame crop")
		check(enemy_visual.scale == Vector2(2.5, 2.5), "Enemy visual spans existing 80-unit body")
		check(enemy.get_node("CollisionShape2D").shape.size == Vector2(80, 80), "Enemy hitbox unchanged")
		var area_name := "DetectionArea" if actor_name == "enemy" else "Area2D"
		var expected_radius := 304.42078 if actor_name == "enemy" else 192.0
		var shape_name := "CollisionShape2D2" if actor_name == "enemy" else "CollisionShape2D"
		check(is_equal_approx(enemy.get_node(area_name + "/" + shape_name).shape.radius, expected_radius), "Detection radius unchanged")
		for direction in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
			enemy.velocity = direction * 200
			var before := enemy.transform
			var previous_frame := enemy_visual.frame
			enemy_visual.update_visual(0.2)
			check(enemy_visual.global_transform.y.normalized().dot(direction) > 0.999, "Enemy faces movement")
			check(enemy_visual.frame != previous_frame, "Enemy movement animates")
			check(enemy.transform == before, "Visual leaves AI body untouched")
		enemy.velocity = Vector2.ZERO
		var angle := enemy_visual.global_rotation
		enemy_visual.update_visual(1.0)
		check(enemy_visual.frame == 0 and is_equal_approx(angle, enemy_visual.global_rotation), "Enemy idle retains facing")
	var fire: CharacterBody2D = level.get_node("enemy_fire")
	fire._on_area_2d_body_entered(player)
	check(fire.player_chase and fire.get_node("fire_light").enabled, "Fire detection and light activation preserved")
	fire._on_area_2d_body_exited(player)
	check(not fire.player_chase and not fire.get_node("fire_light").enabled, "Fire detection exit and light off preserved")
	print("ACTOR VISUAL CHECKS: %d; FAILURES: %d" % [checks, failures])
	level.queue_free()
	quit(1 if failures else 0)
