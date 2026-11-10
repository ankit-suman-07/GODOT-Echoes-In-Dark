extends Node2D
## Reference image is sampled on a 10 2/3 pixel grid; one cell is 32 world units.
## Rooms remain independent from actor scripts and preserve their existing hitboxes.

const CELL := 32
const ROOM_RECTS := {
	"Security Room": Rect2i(42, 3, 22, 17),
	"Storage Room": Rect2i(17, 22, 23, 16),
	"Electrical Room": Rect2i(67, 22, 22, 16),
	"Utility Room": Rect2i(13, 41, 18, 21),
	"Observation Room": Rect2i(74, 41, 19, 21),
	"Safe Room": Rect2i(42, 58, 22, 17),
	"Exit Corridor": Rect2i(48, 76, 21, 11),
	"Exit": Rect2i(44, 88, 19, 13),
}
const HALL_RECTS := [Rect2i(41, 29, 25, 5), Rect2i(50, 27, 7, 15), Rect2i(32, 41, 41, 15)]
# Each connector corresponds to exactly one registered threshold; no other room shortcuts.
const CONNECTIONS := {
	"D01": Rect2i(50, 20, 7, 9),
	"D02": Rect2i(40, 29, 1, 5),
	"D03": Rect2i(34, 38, 4, 3),
	"D04": Rect2i(66, 29, 1, 5),
	"D05": Rect2i(68, 38, 4, 3),
	"D06": Rect2i(31, 51, 1, 4),
	"D07": Rect2i(73, 51, 1, 4),
	"D08": Rect2i(52, 56, 4, 2),
	"C01": Rect2i(48, 75, 11, 1),
	"D09": Rect2i(52, 87, 4, 1),
}

var floor_cells: Dictionary = {}
var floors: TileMapLayer
var walls: StaticBody2D

func _ready() -> void:
	floors = TileMapLayer.new()
	floors.name = "Floors"
	var tiles := TileSet.new()
	tiles.tile_size = Vector2i(CELL, CELL)
	var atlas := TileSetAtlasSource.new()
	atlas.texture = preload("res://assets/echoes_assets/tiles/floor.svg")
	atlas.texture_region_size = Vector2i(CELL, CELL)
	atlas.create_tile(Vector2i.ZERO)
	tiles.add_source(atlas, 0)
	floors.tile_set = tiles
	add_child(floors)
	for rect in ROOM_RECTS.values() + HALL_RECTS + CONNECTIONS.values():
		for x in range(rect.position.x, rect.end.x):
			for y in range(rect.position.y, rect.end.y):
				var cell := Vector2i(x, y)
				floor_cells[cell] = true
				floors.set_cell(cell, 0, Vector2i.ZERO)
	walls = StaticBody2D.new()
	walls.name = "Walls"
	walls.collision_layer = 1
	walls.collision_mask = 0
	add_child(walls)
	for cell: Vector2i in floor_cells:
		for direction in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			if not floor_cells.has(cell + direction):
				_add_wall(cell, direction)
	for room_name: String in ROOM_RECTS:
		var rect: Rect2i = ROOM_RECTS[room_name]
		var label := Label.new()
		label.text = room_name
		label.position = Vector2(rect.position * CELL) + Vector2(24, 24)
		label.modulate = Color(0.65, 0.7, 0.72)
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(label)

func _add_wall(cell: Vector2i, direction: Vector2i) -> void:
	var center := (Vector2(cell) + Vector2(0.5, 0.5)) * CELL + Vector2(direction) * CELL * 0.5
	var size := Vector2(8, CELL + 8) if direction.x != 0 else Vector2(CELL + 8, 8)
	var shape := RectangleShape2D.new()
	shape.size = size
	var collider := CollisionShape2D.new()
	collider.position = center
	collider.shape = shape
	walls.add_child(collider)
	var sprite := Sprite2D.new()
	sprite.texture = preload("res://assets/echoes_assets/tiles/wall_edge.svg")
	sprite.position = center
	sprite.scale = size / 32.0
	walls.add_child(sprite)
	var occluder := LightOccluder2D.new()
	var polygon := OccluderPolygon2D.new()
	polygon.polygon = PackedVector2Array([-size / 2, Vector2(size.x, -size.y) / 2, size / 2, Vector2(-size.x, size.y) / 2])
	occluder.occluder = polygon
	occluder.position = center
	walls.add_child(occluder)
