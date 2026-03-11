extends Area2D

@onready var canvas_layer = $CanvasLayer
@export var display_time: float = 4.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	canvas_layer.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		show_text()

func show_text() -> void:
	canvas_layer.visible = true
	await get_tree().create_timer(display_time).timeout
	canvas_layer.visible = false
