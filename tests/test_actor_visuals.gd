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
	print("ACTOR VISUAL CHECKS: %d; FAILURES: %d" % [checks, failures])
	level.queue_free()
	quit(1 if failures else 0)
