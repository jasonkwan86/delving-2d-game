extends PointLight2D

@export var base_energy: float = 1.0
@export var flicker_strength: float = 0.3
@export var flicker_speed: float = 2.0

func _process(_delta: float) -> void:
	energy = base_energy + sin(Time.get_ticks_msec() * 0.001 * flicker_speed) * flicker_strength
