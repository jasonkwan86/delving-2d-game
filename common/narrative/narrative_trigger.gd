extends Area2D

@onready var canvas_layer = $CanvasLayer
@export var display_time: float = 4.0  # seconds the text stays up

var triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if body.is_in_group("player"):
		triggered = true
		canvas_layer.visible = true
		await get_tree().create_timer(display_time).timeout
		canvas_layer.visible = false
