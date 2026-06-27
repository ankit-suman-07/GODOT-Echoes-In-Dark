extends CharacterBody2D

@export var SPEED := 200.0

@onready var player = $"../player"

var player_chase := false

func _physics_process(delta):
	
	if player_chase:
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()



func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_chase = true
		player = body



func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_chase = false
