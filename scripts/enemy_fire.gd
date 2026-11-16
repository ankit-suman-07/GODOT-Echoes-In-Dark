extends CharacterBody2D

@export var SPEED := 150.0
# Center distance: clears the 32-radius player and 80x80 enemy even diagonally.
@export_range(96.0, 250.0, 1.0) var stopping_distance := 96.0
@export_range(1.0, 2000.0, 1.0) var detection_radius := 250.0

var player: Node2D
@onready var fire_light = $fire_light

var player_chase := false

func _ready() -> void:
	# Each instance owns its radius, including instances of the same PackedScene.
	var collider: CollisionShape2D = $Area2D/CollisionShape2D
	collider.shape = collider.shape.duplicate()
	collider.shape.radius = detection_radius

func _physics_process(delta: float) -> void:
	
	if not is_instance_valid(player) or player.is_queued_for_deletion():
		player = null
		player_chase = false
		fire_light.enabled = false

	if player_chase:
		var offset := player.global_position - global_position
		var remaining := offset.length() - stopping_distance
		velocity = Vector2.ZERO
		if remaining > 0.01 and delta > 0.0:
			# Cap the final step so a long physics frame cannot cross the clearance.
			velocity = offset.normalized() * minf(SPEED, remaining / delta)
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		fire_light.enabled = true
		player_chase = true
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		fire_light.enabled = false
		player_chase = false
		player = null
