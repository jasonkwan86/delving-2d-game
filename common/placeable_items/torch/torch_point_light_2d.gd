extends PointLight2D

@export var base_energy: float = 1.2
@export var flicker_strength: float = 0.3
@export var flicker_speed: float = 0.8

func _process(_delta: float) -> void:
	energy = base_energy + sin(Time.get_ticks_msec() * 0.001 * flicker_speed) * flicker_strength
