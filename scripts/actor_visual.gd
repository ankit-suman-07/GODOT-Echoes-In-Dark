extends Sprite2D
## Presentation only: reads motion, never writes actor transforms or gameplay state.
@export var up_sheet: Texture2D
@export var down_sheet: Texture2D
@export var left_sheet: Texture2D
@export var right_sheet: Texture2D
@export var idle_follows_body := false
@export var rotate_to_motion := false
@export var frames_per_second := 6.0
var animation_time := 0.0
@onready var actor: CharacterBody2D = get_parent()

func _ready() -> void:
	hframes = 4
	update_visual(0.0)

func _process(delta: float) -> void:
	update_visual(delta)

func update_visual(delta: float) -> void:
	var moving := actor.is_physics_processing() and actor.velocity.length_squared() > 1.0
	var direction := actor.velocity.normalized() if moving else Vector2.ZERO
	if not moving and idle_follows_body:
		direction = -actor.global_transform.y.normalized()
	if rotate_to_motion:
		texture = down_sheet
		if moving:
			global_rotation = direction.angle() - PI / 2.0
	else:
		# Keep cardinal artwork upright despite the tank controller rotating its body.
		global_rotation = 0.0
		if not direction.is_zero_approx():
			if absf(direction.x) > absf(direction.y):
				texture = right_sheet if direction.x > 0 else left_sheet
			else:
				texture = down_sheet if direction.y > 0 else up_sheet
	if moving:
		var cadence := clampf(actor.velocity.length() / 200.0, 0.5, 2.5)
		animation_time = fmod(animation_time + delta * frames_per_second * cadence, 4.0)
		frame = int(animation_time)
	else:
		animation_time = 0.0
		frame = 0
