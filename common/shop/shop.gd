extends Area2D

@onready var prompt_layer: CanvasLayer = $PromptLayer

var player_in_range: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	prompt_layer.visible = false

func _get_player() -> Node:
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return null
	return players[0]

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		prompt_layer.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		prompt_layer.visible = false
		var p := _get_player()
		if p != null and p.has_method("force_close_shop"):
			p.force_close_shop()

func _unhandled_input(event: InputEvent) -> void:
	if not player_in_range or not event.is_action_pressed("interact"):
		return
	# When unlocked, the player handles E globally (one shop UI instance).
	if GameState.shop_unlocked:
		return
	var p := _get_player()
	if p != null and p.has_method("toggle_shop_ui"):
		p.toggle_shop_ui()
