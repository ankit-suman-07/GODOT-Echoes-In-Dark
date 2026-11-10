extends "res://scripts/interactables.gd"
signal collected
var picked_up := false

func _ready() -> void:
	add_to_group("level_interactables")

func get_prompt() -> String:
	return "E — Pick up exit key"

func interact() -> void:
	if picked_up:
		return
	picked_up = true
	remove_from_group("level_interactables")
	collected.emit()
	queue_free()
