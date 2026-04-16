extends Area2D

@onready var prompt_layer: CanvasLayer = $PromptLayer
@onready var shop_ui: CanvasLayer = $ShopUI

var player_in_range: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	prompt_layer.visible = false
	shop_ui.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		prompt_layer.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		prompt_layer.visible = false
		shop_ui.close()

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		shop_ui.toggle()
