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
	await physics_frame
	var player: CharacterBody2D = level.get_node("player")
	var beam: PointLight2D = player.get_node("flashlight")
	var halo: PointLight2D = player.get_node("light_all_around")
	check(not beam.enabled and not halo.enabled, "Existing initial off state")
	check(beam.texture.resource_path == "res://resources/lighting/flashlight_beam.svg", "New beam mask loads")
	check(beam.texture.get_size() == Vector2(512, 512), "Beam mask dimensions")
	check(halo.texture is GradientTexture2D, "Native radial light, not icon sprite")
	for light: PointLight2D in [beam, halo, level.get_node("enemy_fire/fire_light"), level.get_node("SafeRoomGlow")]:
		check(light.texture != null and light.shadow_enabled, "All functional lights have textures and shadows")
	check(is_equal_approx(beam.energy, 2.0) and is_equal_approx(halo.energy, 0.8), "Existing player energies retained")
	var image: Image = beam.texture.get_image()
	check(image.get_pixel(256, 450).a > image.get_pixel(256, 50).a, "Beam fades with distance")
	check(image.get_pixel(0, 256).a < 0.01 and image.get_pixel(256, 511).a < 0.01, "Beam does not fill sides/behind emitter")
	var gradient: Gradient = halo.texture.gradient
	check(gradient.sample(0).a > 0.9 and gradient.sample(1).a < 0.01, "Radial halo gradient has bounded falloff")
	for angle in [0.0, PI / 2, PI, -PI / 2]:
		player.rotation = angle
		var relative_forward := -player.global_transform.y.normalized()
		check((-beam.global_transform.y.normalized()).dot(relative_forward) > 0.999, "Beam follows body orientation")
		check((beam.global_position - player.global_position).normalized().dot(relative_forward) > 0.999, "Light source stays ahead of body")
	# Actual input-action injection exercises the unchanged controller's toggle handler.
	Input.action_press("flashlight")
	await physics_frame
	await physics_frame
	check(beam.enabled and halo.enabled, "Controller toggles both real lights on")
	Input.action_release("flashlight")
	await physics_frame
	await physics_frame
	Input.action_press("flashlight")
	await physics_frame
	await physics_frame
	check(not beam.enabled and not halo.enabled, "Controller toggles both lights off")
	Input.action_release("flashlight")
	for actor_name in ["player", "enemy", "enemy_fire"]:
		level.get_node(actor_name).set_physics_process(false)
	player.position = Vector2(1713, 447)
	var door: Area2D = level.get_node("D08")
	var shadow: LightOccluder2D = door.get_node("Shadow")
	check(shadow.visible and shadow.occluder.polygon.size() == 4, "Closed door casts rectangular shadow")
	check(shadow.occluder.polygon[2] == door.doorway_size / 2, "Door shadow matches unchanged collision footprint")
	door.interact()
	shadow.update_shadow()
	check(not shadow.visible, "Opened door stops occluding")
	await physics_frame
	await physics_frame
	door.interact()
	shadow.update_shadow()
	check(shadow.visible, "Closed door resumes occlusion")
	var fire: CharacterBody2D = level.get_node("enemy_fire")
	fire._on_area_2d_body_entered(player)
	check(fire.get_node("fire_light").enabled, "Fire light still responds to detection")
	fire._on_area_2d_body_exited(player)
	check(not fire.get_node("fire_light").enabled, "Fire light still switches off on exit")
	print("LIGHTING CHECKS: %d; FAILURES: %d" % [checks, failures])
	level.queue_free()
	quit(1 if failures else 0)
