class_name HerringboneWangGenerator
extends Node

@export var tilemap: TileMapLayer 
@export var herringbone_wang_data_set: HerringboneWangDataSet 

func _ready():
	randomize()
	generate_herringbone_map(Vector2i(-5, 5), Vector2i(20, 20))

#func _input(event):
	#if event.is_action_pressed("ui_accept"):
		#get_tree().reload_current_scene()

func generate_herringbone_map(offset: Vector2i = Vector2i(0, 0), dimensions: Vector2i = Vector2i(20, 20)) -> void:
	for row in dimensions.y:
		if row % 4 == 3:
			# Last row, offset by -1 horizontally from the first row
			for col in range(0, dimensions.x, 4):
				_place_dual_corner_tiles(row + offset.y, col - 1 + offset.x)
		else:
			# First 3 sequential rows
			for col in range(0, dimensions.x, 4):
				_place_dual_corner_tiles(row + offset.y, col + row % 4 + offset.x)

func _place_dual_corner_tiles(row: int, col: int) -> void:
	herringbone_wang_data_set.copy_random_hbwt_horizontal_to_tile_map_layer(col * Vector2i.RIGHT + row * Vector2i.DOWN, tilemap)
	herringbone_wang_data_set.copy_random_hbwt_vertical_to_tile_map_layer((col + 2) * Vector2i.RIGHT + Vector2i.UP + row * Vector2i.DOWN, tilemap)
