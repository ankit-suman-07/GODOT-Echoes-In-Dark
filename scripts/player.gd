extends CharacterBody2D

@export var SPEED := 200.0
@export var TURN_SPEED := 3.0   # Retained for scene compatibility; mouse aim is immediate.

@onready var flashlight = $flashlight
@onready var round_light = $light_all_around

func _physics_process(_delta: float) -> void:
	
	# Toggle flashlight
	if Input.is_action_just_pressed("flashlight"):
		if flashlight.enabled == true:
			flashlight.enabled = false
			round_light.enabled = false
		else:
			flashlight.enabled = true
			round_light.enabled = true
	
	# The authored flashlight points along local -Y.
	var aim_direction := get_global_mouse_position() - global_position
	if not aim_direction.is_zero_approx():
		global_rotation = aim_direction.angle() + PI / 2.0
	
	if Input.is_action_pressed("sprint"):
		SPEED = 500.0
	else:
		SPEED = 200.0

	# Input.get_vector limits diagonal length; movement stays in world axes.
	var direction := Input.get_vector("left", "right", "forward", "back")

	velocity = direction * SPEED

	# Apply movement
	move_and_slide()
