class_name MiningComponent
extends Node2D

@export_category("World Properties")
@export var player: CharacterBody2D
@export var inventory: InventoryComponent
@export var world_tilemap: TileMapLayer
@export var break_tilemap: TileMapLayer
@export var block_break_states: int = 3

@export_category("Mining Properties")
@export var pickaxe_sprite: Sprite2D
@export var pickaxe_animation_speed: float = 2
@export var mine_range: float = 20
@export var mine_damage_per_second: float = 100

var cell_healths: Dictionary[Vector2i, float]
var pickaxe_animation_progress: float = 0.0

func _ready() -> void:
	pickaxe_sprite.visible = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("mine"):
		mine(delta)
	if Input.is_action_just_released("mine"):
		pickaxe_sprite.visible = false

func mine(delta: float) -> void:
	pickaxe_sprite.visible = true
	pickaxe_animation_progress = fposmod(pickaxe_animation_progress + delta * pickaxe_animation_speed, 1)
	pickaxe_sprite.rotation_degrees = lerpf(-90, 90, pickaxe_animation_progress)
	if player.global_position.distance_to(get_global_mouse_position()) > mine_range:
		return
	var cell_position: Vector2i = world_tilemap.local_to_map(world_tilemap.to_local(get_global_mouse_position()))
	if world_tilemap.get_cell_source_id(cell_position) == -1:
		return
	
	var tile_data = world_tilemap.get_cell_tile_data(cell_position)
	if tile_data.get_custom_data("is_breakable") as bool == false:
		return
	var max_health = tile_data.get_custom_data("health")
	if cell_position not in cell_healths:
		cell_healths[cell_position] = max_health
	cell_healths[cell_position] -= mine_damage_per_second * delta
	
	break_tilemap.set_cell(cell_position, 0, Vector2i(lerp(block_break_states + 1, 0, cell_healths[cell_position] / max_health), 0))
	if cell_healths[cell_position] <= 0:
		world_tilemap.erase_cell(cell_position)
		break_tilemap.erase_cell(cell_position)
		var mineral_type: Mineral = tile_data.get_custom_data("mineral_type")
		if mineral_type != null:
			inventory.add_mineral(mineral_type)
