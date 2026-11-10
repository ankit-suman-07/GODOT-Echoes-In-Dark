extends "res://scripts/interactables.gd"
## Locked-door key policy is deliberately unset until LD-Q02 is resolved.
signal unlock_requested(door: Area2D)
@export var locked := false
@export var doorway_size := Vector2(128, 16)
var is_open := false
@onready var barrier: StaticBody2D = $Barrier
@onready var visual: Sprite2D = $Sprite2D

func _ready() -> void:
	var shape := RectangleShape2D.new()
	shape.size = doorway_size
	$Barrier/CollisionShape2D.shape = shape
	visual.scale = doorway_size / Vector2(32, 48)
	_update_visual()
	add_to_group("level_interactables")

func get_prompt() -> String:
	if locked:
		return "Locked"
	return "E — Close door" if is_open else "E — Open door"

func interact() -> void:
	if locked:
		unlock_requested.emit(self)
		if locked:
			return
	if is_open:
		# Do not close a door through an actor occupying its threshold.
		var query := PhysicsShapeQueryParameters2D.new()
		query.shape = $Barrier/CollisionShape2D.shape
		query.transform = global_transform
		query.exclude = [barrier.get_rid()]
		for hit in get_world_2d().direct_space_state.intersect_shape(query):
			if hit.collider is CharacterBody2D:
				return
	is_open = not is_open
	$Barrier/CollisionShape2D.set_deferred("disabled", is_open)
	_update_visual()

func _update_visual() -> void:
	if is_open:
		visual.texture = preload("res://assets/echoes_assets/doors/door_open.svg")
	elif locked:
		visual.texture = preload("res://assets/echoes_assets/doors/door_locked.svg")
	else:
		visual.texture = preload("res://assets/echoes_assets/doors/door_closed.svg")
