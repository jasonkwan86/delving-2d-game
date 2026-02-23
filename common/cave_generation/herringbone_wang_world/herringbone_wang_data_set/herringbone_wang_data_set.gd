class_name HerringboneWangDataSet
extends TileMapLayer

@export var HBWT_SMALLER_DIMENSION: int = 20
@export var HBWT_LARGER_DIMENSION: int = 40

@export var HBW_HORIZONTAL_TILE_GAP: int = 50
@export var HBW_VERTICAL_TILE_GAP: int = 50

@export var HBWT_VERTICAL_TILE_START_OFFSET: int = 50

@export var HBWT_COUNT_HORIZONTAL: int = 6
@export var HBWT_COUNT_VERTICAL: int = 2

func copy_random_hbwt_horizontal_to_tile_map_layer(copy_to_coords: Vector2i, copy_to_tile_map_layer: TileMapLayer) -> void:
	copy_hbwt_horizontal_to_tile_map_layer(randi_range(0, HBWT_COUNT_HORIZONTAL) * Vector2i.RIGHT, copy_to_coords, copy_to_tile_map_layer)

func copy_random_hbwt_vertical_to_tile_map_layer(copy_to_coords: Vector2i, copy_to_tile_map_layer: TileMapLayer) -> void:
	copy_hbwt_vertical_to_tile_map_layer(randi_range(0, HBWT_COUNT_VERTICAL) * Vector2i.RIGHT, copy_to_coords, copy_to_tile_map_layer)

func copy_hbwt_horizontal_to_tile_map_layer(copy_from_hbwt_coords: Vector2i, copy_to_hbwt_coords: Vector2i, copy_to_tile_map_layer: TileMapLayer) -> void:
	var copy_to_coord: Vector2i = Vector2i(copy_to_hbwt_coords.x * HBWT_SMALLER_DIMENSION, copy_to_hbwt_coords.y * HBWT_LARGER_DIMENSION)
	for row in HBWT_SMALLER_DIMENSION:
		for col in HBWT_LARGER_DIMENSION:
			copy_to_tile_map_layer.set_cell(
				copy_to_coord + Vector2i(col, row),
				0,
				_get_atlas_coord_of_horizontal_hbwt_at(copy_from_hbwt_coords, row, col)
			)

func copy_hbwt_vertical_to_tile_map_layer(copy_from_coords: Vector2i, copy_to_coords: Vector2i, copy_to_tile_map_layer: TileMapLayer) -> void:
	var copy_to_coord: Vector2i = Vector2i(copy_to_coords.x * HBWT_LARGER_DIMENSION, copy_to_coords.y * HBWT_SMALLER_DIMENSION)
	for row in HBWT_LARGER_DIMENSION:
		for col in HBWT_SMALLER_DIMENSION:
			copy_to_tile_map_layer.set_cell(
				copy_to_coord + Vector2i(col, row),
				0,
				_get_atlas_coord_of_vertical_hbwt_at(copy_from_coords, row, col)
			)

# TODO: Make this less rigid
func _get_atlas_coord_of_horizontal_hbwt_at(hbwt_coords: Vector2i, row: int, col: int) -> Vector2i:
	return get_cell_atlas_coords(hbwt_coords * HBW_HORIZONTAL_TILE_GAP + Vector2i(col, row))

func _get_atlas_coord_of_vertical_hbwt_at(hbwt_coords: Vector2i, row: int, col: int) -> Vector2i:
	return get_cell_atlas_coords(hbwt_coords * HBW_HORIZONTAL_TILE_GAP + Vector2i(col, row) + HBWT_VERTICAL_TILE_START_OFFSET * Vector2i.DOWN)
