extends Node2D
## Session-only key ownership. Save, battery and locked-door rules await design decisions.
const INTERACTION_RANGE := 144.0
var has_exit_key := false
var completed := false
var focused: Node2D
@onready var player: CharacterBody2D = $player
@onready var prompt: Label = $prompt/Label

func _ready() -> void:
	$key.collected.connect(_on_key_collected)
	$D09.unlock_requested.connect(_on_exit_unlock_requested)
	$ExitTrigger.body_entered.connect(_on_exit_entered)
	prompt.text = ""
	prompt.offset_left = -340
	prompt.offset_right = 340
	prompt.offset_top = 40
	prompt.offset_bottom = 130
	prompt.add_theme_font_size_override("font_size", 26)

func _physics_process(_delta: float) -> void:
	if completed:
		return
	focused = null
	var nearest := INTERACTION_RANGE
	for candidate: Node2D in get_tree().get_nodes_in_group("level_interactables"):
		var distance := player.global_position.distance_to(candidate.global_position)
		if distance > nearest:
			continue
		var ray := PhysicsRayQueryParameters2D.create(player.global_position, candidate.global_position, 1, [player.get_rid()])
		var hit := get_world_2d().direct_space_state.intersect_ray(ray)
		if not hit.is_empty() and not candidate.is_ancestor_of(hit.collider):
			continue
		nearest = distance
		focused = candidate
	prompt.text = focused.get_prompt() if is_instance_valid(focused) else ""

func _unhandled_input(event: InputEvent) -> void:
	if completed:
		if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_R:
			get_tree().reload_current_scene()
		return
	if event.is_action_pressed("interact") and is_instance_valid(focused):
		focused.interact()
		get_viewport().set_input_as_handled()

func _on_key_collected() -> void:
	has_exit_key = true

func _on_exit_unlock_requested(door: Area2D) -> void:
	if has_exit_key and door == $D09:
		door.locked = false

func _on_exit_entered(body: Node2D) -> void:
	if completed or body != player or not has_exit_key or not $D09.is_open:
		return
	completed = true
	focused = null
	for actor_name in ["player", "enemy", "enemy_fire"]:
		var actor: CharacterBody2D = get_node(actor_name)
		actor.velocity = Vector2.ZERO
		actor.set_physics_process(false)
	prompt.text = "You escaped.\nR — Restart"
