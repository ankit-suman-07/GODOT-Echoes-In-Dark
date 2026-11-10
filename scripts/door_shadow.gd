extends LightOccluder2D
## A presentation-only reader of the existing door state and dimensions.
@onready var door: Area2D = get_parent()

func _ready() -> void:
	var half: Vector2 = door.doorway_size / 2.0
	occluder = OccluderPolygon2D.new()
	occluder.polygon = PackedVector2Array([-half, Vector2(half.x, -half.y), half, Vector2(-half.x, half.y)])
	update_shadow()

func _process(_delta: float) -> void:
	update_shadow()

func update_shadow() -> void:
	visible = not door.is_open
