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

func generate_herringbone_map(_width = 12, _height = 8) -> void:
	tilemap.clear()
	herringbone_wang_data_set.copy_hbwt_horizontal_to_tile_map_layer(Vector2.ZERO, Vector2.ZERO, tilemap)
	#herringbone_wang_data_set.copy_hbwt_horizontal_to_tile_map_layer(Vector2.RIGHT, Vector2.RIGHT * 2, tilemap)
	#herringbone_wang_data_set.copy_hbwt_horizontal_to_tile_map_layer(Vector2.RIGHT, Vector2.RIGHT * 2, tilemap)
	herringbone_wang_data_set.copy_hbwt_vertical_to_tile_map_layer(Vector2.RIGHT, Vector2.DOWN, tilemap)
	#for col in range(5):
		#print(col * Vector2.RIGHT)
		#herringbone_wang_data_set.copy_random_hbw_tile_to_tile_map_layer(col * Vector2.RIGHT, tilemap)
