extends CharacterBody2D

@export var SPEED := 200.0
@export var TURN_SPEED := 3.0   # Radians per second

@onready var flashlight = $flashlight
@onready var round_light = $light_all_around

func _physics_process(delta):
	
	# Toggle flashlight
	if Input.is_action_just_pressed("flashlight"):
		if flashlight.enabled == true:
			flashlight.enabled = false
			round_light.enabled = false
		else:
			flashlight.enabled = true
			round_light.enabled = true
	
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
