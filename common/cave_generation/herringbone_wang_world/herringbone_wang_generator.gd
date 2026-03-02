class_name HerringboneWangGenerator
extends Node

@export var tilemap: TileMapLayer 
@export var herringbone_wang_data_set: HerringboneWangDataSet 

func _ready():
	randomize()
	generate_herringbone_map()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func generate_herringbone_map(width = 20, height = 20) -> void:
	for row in height:
		if row % 4 == 3:
			# Last row, offset by -1 horizontally from the first row
			for col in range(0, width, 4):
				_place_dual_corner_tiles(row, col - 1)
		else:
			# First 3 sequential rows
			for col in range(0, width, 4):
				_place_dual_corner_tiles(row, col + row % 4)

func _place_dual_corner_tiles(row: int, col: int) -> void:
	herringbone_wang_data_set.copy_random_hbwt_horizontal_to_tile_map_layer(col * Vector2i.RIGHT + row * Vector2i.DOWN, tilemap)
	herringbone_wang_data_set.copy_random_hbwt_vertical_to_tile_map_layer((col + 2) * Vector2i.RIGHT + Vector2i.UP + row * Vector2i.DOWN, tilemap)
