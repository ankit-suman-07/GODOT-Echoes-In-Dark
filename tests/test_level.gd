extends SceneTree
## Engine-backed integration checks; no test framework or manual-play claims.
var failures := 0
var checks := 0
var level: Node2D

func _initialize() -> void:
	_run.call_deferred()

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)

func _run() -> void:
	for file_name in DirAccess.get_files_at("res://scenes"):
		if file_name.ends_with(".tscn"):
			check(load("res://scenes/" + file_name) is PackedScene, "Scene resource loads: " + file_name)
	level = load("res://scenes/level.tscn").instantiate()
	root.add_child(level)
	await physics_frame
	await physics_frame
	var geometry: Node2D = level.get_node("Geometry")
	var player: CharacterBody2D = level.get_node("player")
	# Freeze actors while exercising physics explicitly.
	for actor_name in ["player", "enemy", "enemy_fire"]:
		level.get_node(actor_name).set_physics_process(false)
	check(geometry.ROOM_RECTS.size() == 8, "Eight peripheral rooms plus Main Hall required")
	check(geometry.CONNECTIONS.size() == 10, "Every map connection must be represented")
	check(player.position.distance_to(Vector2(1713, 447)) < 1, "Security spawn")
	check(not player.get_node("flashlight").enabled, "Flashlight starts off")
	check(not player.get_node("light_all_around").enabled, "Round light starts off")
	check(InputMap.action_has_event("interact", _interaction_event()), "E interaction binding")
	# Verify the entire structural floor graph is connected, including both upper room doors.
	var cells: Dictionary = geometry.floor_cells
	var pending: Array[Vector2i] = [Vector2i(53, 14)]
	var seen := {}
	while not pending.is_empty():
		var cell: Vector2i = pending.pop_back()
		if seen.has(cell):
			continue
		seen[cell] = true
		for direction in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			if cells.has(cell + direction) and not seen.has(cell + direction):
				pending.append(cell + direction)
	check(seen.size() == cells.size(), "All intended floors connect geometrically")
	for id in ["B01", "B02", "N01", "N02", "N03", "key", "S01", "E01"]:
		var node: Node2D = level.get_node(id)
		check(cells.has(Vector2i((node.position / 32.0).floor())), id + " must be on floor")
	check(not level.has_node("B03"), "Do not invent third battery location")
	# Body-shape casts test real physics, not merely map cell membership.
	var body_shape := CircleShape2D.new()
	body_shape.radius = 32
	for id in ["D01", "D02", "D03", "D04", "D05", "D06", "D07", "D08", "D09"]:
		var door: Area2D = level.get_node(id)
		var normal := Vector2.RIGHT if door.doorway_size.x < door.doorway_size.y else Vector2.DOWN
		check(_blocked(door.position - normal * 80, normal * 160, body_shape), id + " closed barrier must block player")
		if door.locked:
			door.interact()
			check(not door.is_open, id + " stays locked without approved policy")
		else:
			door.interact()
			await physics_frame
			await physics_frame
			check(door.is_open, id + " opens")
			check(not _blocked(door.position - normal * 80, normal * 160, body_shape), id + " open doorway clearance")
			player.position = door.position
			await physics_frame
			door.interact()
			check(door.is_open, id + " refuses close on actor")
			player.position = Vector2(1713, 447)
			await physics_frame
			door.interact()
			await physics_frame
			check(not door.is_open, id + " closes after threshold clear")
	# Remove barriers temporarily to test every connector against unchanged 80x80 enemy hitbox.
	for id in ["D01", "D02", "D03", "D04", "D05", "D06", "D07", "D08", "D09"]:
		level.get_node(id).get_node("Barrier/CollisionShape2D").set_deferred("disabled", true)
	await physics_frame
	await physics_frame
	var enemy_shape := RectangleShape2D.new()
	enemy_shape.size = Vector2(80, 80)
	for id: String in geometry.CONNECTIONS:
		var rect: Rect2i = geometry.CONNECTIONS[id]
		var center := (Vector2(rect.position) + Vector2(rect.size) / 2) * 32
		var normal := Vector2.DOWN if rect.size.x >= rect.size.y else Vector2.RIGHT
		if id == "D01": normal = Vector2.DOWN
		if id == "D03" or id == "D05": normal = Vector2.DOWN
		check(not _blocked(center - normal * 64, normal * 128, enemy_shape), id + " fits existing enemy shape when open")
	check(_blocked(Vector2(1450, 150), Vector2(0, -120), body_shape), "Security north wall contains player")
	check(_blocked(Vector2(900, 1080), Vector2(0, 220), body_shape), "Storage south wall has no unmarked shortcut")
	# Interaction selection and occlusion: proximity alone must not reach through walls.
	player.position = Vector2(951, 1120)
	level._physics_process(0.016)
	check(level.focused == null, "No interactables in empty part of Storage")
	player.position = Vector2(2100, 2550)
	level._physics_process(0.016)
	check(level.focused == level.get_node("key"), "Nearby key selected")
	level._on_exit_entered(player)
	check(not level.completed, "Keyless exit does not complete")
	var key: Area2D = level.get_node("key")
	var collected := [0]
	key.collected.connect(func(): collected[0] += 1)
	key.interact()
	key.interact()
	check(collected[0] == 1, "Key collected signal once")
	check(level.has_exit_key, "Session owns collected key")
	await process_frame
	check(not level.has_node("key"), "Collected key removed")
	var exit_door: Area2D = level.get_node("D09")
	exit_door.interact()
	check(exit_door.is_open and not exit_door.locked, "Exit key unlocks final door")
	player.position = level.get_node("ExitTrigger").position
	await physics_frame
	await physics_frame
	await physics_frame
	await physics_frame
	check(level.completed, "Physics exit trigger completes with key and open door")
	level._on_exit_entered(player)
	check(level.completed and not player.is_physics_processing(), "Completion stops movement and is repeat-safe")
	level.queue_free()
	await process_frame
	level = load("res://scenes/level.tscn").instantiate()
	root.add_child(level)
	await physics_frame
	check(not level.has_exit_key and level.has_node("key") and not level.completed, "Fresh level resets key and completion state")
	print("LEVEL CHECKS: %d; FAILURES: %d" % [checks, failures])
	level.queue_free()
	quit(1 if failures else 0)

func _interaction_event() -> InputEventKey:
	var event := InputEventKey.new()
	event.physical_keycode = KEY_E
	return event

func _blocked(origin: Vector2, motion: Vector2, shape: Shape2D) -> bool:
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0, origin)
	query.motion = motion
	query.collision_mask = 1
	query.exclude = [level.get_node("player").get_rid(), level.get_node("enemy").get_rid(), level.get_node("enemy_fire").get_rid()]
	var result: PackedFloat32Array = level.get_world_2d().direct_space_state.cast_motion(query)
	return result[0] < 0.999
