extends SceneTree
## Physical keyboard events and mouse-relative world positions on the existing player.
var checks := 0
var failures := 0
var player: CharacterBody2D

func _initialize() -> void:
	_run.call_deferred()

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)

func key_event(code: Key, pressed: bool) -> void:
	var event := InputEventKey.new()
	event.device = 0
	event.physical_keycode = code
	event.pressed = pressed
	Input.parse_input_event(event)
	Input.flush_buffered_events()

func place_relative_to_mouse(direction: Vector2) -> void:
	# Headless DisplayServer has no movable OS cursor. Exercise the real mouse
	# query by placing the actor relative to the viewport's current cursor.
	player.global_position = player.get_global_mouse_position() - direction * 200

func _run() -> void:
	player = load("res://scenes/player.tscn").instantiate()
	root.add_child(player)
	player.set_physics_process(false)
	var camera: Camera2D = player.get_node("Camera2D")
	camera.force_update_scroll()
	await physics_frame
	var cases := [
		[[KEY_W], Vector2.UP], [[KEY_S], Vector2.DOWN],
		[[KEY_A], Vector2.LEFT], [[KEY_D], Vector2.RIGHT],
		[[KEY_UP], Vector2.UP], [[KEY_DOWN], Vector2.DOWN],
		[[KEY_LEFT], Vector2.LEFT], [[KEY_RIGHT], Vector2.RIGHT],
		[[KEY_W, KEY_D], Vector2(1, -1).normalized()],
		[[KEY_S, KEY_D], Vector2(1, 1).normalized()],
		[[KEY_S, KEY_A], Vector2(-1, 1).normalized()],
		[[KEY_W, KEY_A], Vector2(-1, -1).normalized()],
		[[KEY_UP, KEY_RIGHT], Vector2(1, -1).normalized()],
		[[KEY_DOWN, KEY_LEFT], Vector2(-1, 1).normalized()],
		[[KEY_W, KEY_S, KEY_A, KEY_D], Vector2.ZERO],
	]
	for entry in cases:
		for code in entry[0]:
			key_event(code, true)
		place_relative_to_mouse(Vector2.RIGHT)
		player._physics_process(1.0 / 60.0)
		check(player.velocity.is_equal_approx(entry[1] * 200), "Keyboard world-axis velocity: " + str(entry[0]))
		for code in entry[0]:
			key_event(code, false)
	# Sprint must retain its speed on a diagonal too.
	for code in [KEY_W, KEY_D, KEY_SHIFT]:
		key_event(code, true)
	place_relative_to_mouse(Vector2.LEFT)
	player._physics_process(1.0 / 60.0)
	check(is_equal_approx(player.velocity.length(), 500), "Diagonal sprint stays 500")
	for code in [KEY_W, KEY_D, KEY_SHIFT]:
		key_event(code, false)
	var beam: PointLight2D = player.get_node("flashlight")
	var visual: Sprite2D = player.get_node("Sprite2D")
	for direction in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2(1, -1).normalized()]:
		place_relative_to_mouse(direction)
		player._physics_process(1.0 / 60.0)
		check((-player.global_transform.y).normalized().dot(direction) > 0.999, "Body follows viewport mouse position")
		check((-beam.global_transform.y).normalized().dot(direction) > 0.999, "Beam follows mouse aim")
		check((beam.global_position - player.global_position).normalized().dot(direction) > 0.999, "Emitter stays ahead of player")
		camera.force_update_scroll()
		check(camera.ignore_rotation and is_zero_approx(root.get_canvas_transform().get_rotation()), "Camera view stays upright while aiming")
		visual.update_visual(0.0)
		if direction == Vector2.LEFT:
			check(visual.texture == visual.left_sheet, "Idle artwork faces mouse")
	place_relative_to_mouse(Vector2.ZERO)
	var previous_rotation := player.rotation
	player._physics_process(1.0 / 60.0)
	check(is_finite(player.rotation) and is_equal_approx(player.rotation, previous_rotation), "Mouse at actor center retains facing")
	# F and legacy Space toggle both existing lights via physical input events.
	for code in [KEY_F, KEY_SPACE]:
		await physics_frame
		var was_enabled: bool = beam.enabled
		key_event(code, true)
		await physics_frame
		player._physics_process(1.0 / 60.0)
		check(beam.enabled != was_enabled and beam.enabled == player.get_node("light_all_around").enabled, "Keyboard toggles both existing lights")
		key_event(code, false)
	check(is_equal_approx(beam.energy, 2.0) and beam.texture.get_size() == Vector2(512, 512), "Beam brightness and range resource unchanged")
	player.queue_free()
	await process_frame
	print("PLAYER CONTROL CHECKS: %d; FAILURES: %d" % [checks, failures])
	quit(1 if failures else 0)
