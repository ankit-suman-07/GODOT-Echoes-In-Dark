extends CharacterBody2D

@export var SPEED := 200.0
@export var TURN_SPEED := 3.0   # Radians per second

func _physics_process(delta):
	# Rotate left/right
	if Input.is_action_pressed("left"):
		rotation -= TURN_SPEED * delta

	if Input.is_action_pressed("right"):
		rotation += TURN_SPEED * delta
	
	if Input.is_action_pressed("sprint"):
		SPEED = 500.0
	else:
		SPEED = 200.0

	# Move forward/backward
	var direction = Vector2.ZERO

	if Input.is_action_pressed("forward"):
		direction = -transform.y

	if Input.is_action_pressed("back"):
		direction = transform.y

	velocity = direction * SPEED

	# Apply movement
	move_and_slide()
