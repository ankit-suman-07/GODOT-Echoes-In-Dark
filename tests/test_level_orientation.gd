extends SceneTree
## Regression signatures capture all pre-correction floor/wall geometry at 4bfb5a6.
## Comparing inverse-reflected runtime geometry detects omissions and extra passages.
const ORIGINAL_FLOOR_HASH := "391be591b9222f27308185ce0056d501d152e3fe98909c7a60dddf3ad8427a7d"
const ORIGINAL_WALL_HASH := "f428f78f51591922225e728fb740cf6524dec13fe1e43b8c0bce320f9c4852e9"
const ORIGINAL_POSITIONS := {
	"player": Vector2(1713, 447),
	"enemy": Vector2(2100, 1536),
	"enemy_fire": Vector2(1152, 1536),
	"key": Vector2(2100, 2619),
	"D01": Vector2(1712, 864),
	"D02": Vector2(1296, 1008),
	"D03": Vector2(1152, 1264),
	"D04": Vector2(2128, 1008),
	"D05": Vector2(2240, 1264),
	"D06": Vector2(1008, 1696),
	"D07": Vector2(2352, 1696),
	"D08": Vector2(1728, 1824),
	"B01": Vector2(951, 978),
	"B02": Vector2(2487, 1005),
	"N01": Vector2(675, 1746),
	"N02": Vector2(1497, 1548),
	"N03": Vector2(2682, 1746),
	"S01": Vector2(1716, 2262),
	"SecurityDesk": Vector2(1450, 330),
	"ElectricalTerminal": Vector2(2780, 800),
	"C01": Vector2(1713, 2400),
	"D09": Vector2(1728, 2800),
	"E01": Vector2(1716, 3096),
	"ExitTrigger": Vector2(1716, 3096),
	"SafeRoomGlow": Vector2(1716, 2110),
}

var checks := 0
var failures := 0
var level: Node2D

func _initialize() -> void:
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _run() -> void:
	level = load("res://scenes/level.tscn").instantiate()
	root.add_child(level)
	await physics_frame
	await physics_frame
	var geometry: Node2D = level.get_node("Geometry")
	var player: CharacterBody2D = level.get_node("player")
	var start := player.position
	var floor_rows: Array[String] = []
	for cell: Vector2i in geometry.floor_cells:
		floor_rows.append("%d,%d" % [cell.x, 103 - cell.y])
	floor_rows.sort()
	check(geometry.floor_cells.size() == 3640, "Floor cell count preserved")
	check("\n".join(floor_rows).sha256_text() == ORIGINAL_FLOOR_HASH, "Every floor cell is an exact vertical reflection")
	var wall_rows: Array[String] = []
	for child in geometry.walls.get_children():
		if child is CollisionShape2D:
			wall_rows.append("%d,%d,%d,%d" % [child.position.x, 3328 - child.position.y, child.shape.size.x, child.shape.size.y])
	wall_rows.sort()
	check(wall_rows.size() == 710, "Wall collider count preserved")
	check("\n".join(wall_rows).sha256_text() == ORIGINAL_WALL_HASH, "Every collision boundary is reflected with unchanged size")
	for name: String in ORIGINAL_POSITIONS:
		var original: Vector2 = ORIGINAL_POSITIONS[name]
		check(level.get_node(name).position == Vector2(original.x, 3328 - original.y), name + " vertical placement")
	var security: Rect2i = geometry.ROOM_RECTS["Security Room"]
	var exit_room: Rect2i = geometry.ROOM_RECTS["Exit"]
	check(security.position.y > exit_room.end.y, "Security bottom, Exit top")
	check(security.has_point(Vector2i((start / 32).floor())), "Player inside bottom Security Room")
	check(exit_room.has_point(Vector2i((level.get_node("ExitTrigger").position / 32).floor())), "Exit trigger inside top Exit")
	check(is_zero_approx(player.rotation), "Player initially faces screen up")
	var positive_transforms := true
	for node in level.find_children("*", "Node2D", true, false):
		positive_transforms = positive_transforms and node.transform.determinant() > 0
	check(positive_transforms, "All world transforms keep positive determinant")
	for label in level.find_children("*", "Label", true, false):
		check(label.get_global_transform().determinant() > 0 and is_zero_approx(label.rotation), "Text stays upright")
	var camera: Camera2D = player.get_node("Camera2D")
	check(camera.enabled and camera.ignore_rotation and camera.global_position == player.global_position, "Camera follows without flipping view")
	check(camera.limit_top == -10000000 and camera.limit_bottom == 10000000, "Existing unrestricted camera limits retained")
	check(level.get_node("MainHallLabel").get_rect() == Rect2(1632, 1708, 218, 36), "Hall label rectangle mirrored without flipping text")
	check(level.get_node("prompt/Label").offset_top == 40, "Screen-space prompt not moved with world")
	# Actual controller input: initial W/up forward goes north; S/down goes south.
	Input.action_press("forward")
	await physics_frame
	await physics_frame
	check(player.velocity.y < 0 and player.position.y < start.y, "Forward input moves upward from spawn")
	Input.action_release("forward")
	await physics_frame
	await physics_frame
	Input.action_press("back")
	await physics_frame
	await physics_frame
	check(player.velocity.y > 0, "Backward input moves downward")
	Input.action_release("back")
	await physics_frame
	await physics_frame
	for actor_name in ["player", "enemy", "enemy_fire", "enemy_2"]:
		level.get_node(actor_name).set_physics_process(false)
	player.position = start
	var initial_reachable := _reachable(geometry, start)
	check(not initial_reachable.has(_cell(level.get_node("key").position)), "Closed start door still gates route")
	level.get_node("D01").interact()
	level.get_node("D08").interact()
	var reachable := _reachable(geometry, start)
	check(reachable.has(_cell(level.get_node("key").position)), "Openable doors still allow route upward to key")
	check(not reachable.has(_cell(level.get_node("ExitTrigger").position)), "Locked final door still blocks exit route")
	for room_name in ["Storage Room", "Electrical Room", "Utility Room", "Observation Room"]:
		check(not reachable.has(geometry.ROOM_RECTS[room_name].get_center()), "Existing locked-door gating retained: " + room_name)
	level.get_node("key").interact()
	level.get_node("D09").interact()
	check(_reachable(geometry, start).has(_cell(level.get_node("ExitTrigger").position)), "Exit key opens the same progression route")
	# Repositioned AI uses the existing detection callbacks and moves toward its target.
	for actor_name in ["enemy", "enemy_fire"]:
		var enemy: CharacterBody2D = level.get_node(actor_name)
		player.position = enemy.position + Vector2(0, -120)
		if actor_name == "enemy":
			enemy._on_detection_area_body_entered(player)
		else:
			enemy._on_area_2d_body_entered(player)
		var before := enemy.position
		enemy._physics_process(1.0 / 60.0)
		check(enemy.player_chase and enemy.velocity.y < 0 and enemy.position.y < before.y, "Existing chase works at reflected spawn: " + actor_name)
		if actor_name == "enemy":
			enemy._on_detection_area_body_exited(player)
		else:
			enemy._on_area_2d_body_exited(player)
		check(not enemy.player_chase, "Existing detection exit stops chase")
	print("ORIENTATION CHECKS: %d; FAILURES: %d" % [checks, failures])
	level.queue_free()
	quit(1 if failures else 0)

func _cell(point: Vector2) -> Vector2i:
	return Vector2i((point / 32).floor())

func _reachable(geometry: Node2D, start: Vector2) -> Dictionary:
	# Structural graph applies actual closed-door states; physical clearances are
	# separately covered by test_level.gd's body-shape casts through every doorway.
	var blocked := {}
	for name: String in geometry.CONNECTIONS:
		if name == "C01":
			continue
		var door: Area2D = level.get_node(name)
		if not door.is_open:
			var rect: Rect2i = geometry.CONNECTIONS[name]
			for x in range(rect.position.x, rect.end.x):
				for y in range(rect.position.y, rect.end.y):
					blocked[Vector2i(x, y)] = true
	var pending: Array[Vector2i] = [_cell(start)]
	var seen := {}
	while not pending.is_empty():
		var cell: Vector2i = pending.pop_back()
		if seen.has(cell):
			continue
		seen[cell] = true
		for direction in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			var next: Vector2i = cell + direction
			if geometry.floor_cells.has(next) and not blocked.has(next) and not seen.has(next):
				pending.append(next)
	return seen
