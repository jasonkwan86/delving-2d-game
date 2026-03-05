extends CharacterBody2D

const SPEED = 60.0
const PATROL_DISTANCE = 2

@export var tile_size: int = 16

var start_position: Vector2
var patrol_limit: float
var direction: int = -1
var initialized: bool = false

func _ready() -> void:
	patrol_limit = PATROL_DISTANCE * tile_size

func _physics_process(delta: float) -> void:
	# Wait one frame for global_position to be valid after spawning
	if not initialized:
		start_position = global_position
		initialized = true
		return

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Patrol: flip direction based on distance from spawn
	var dist = global_position.x - start_position.x
	if dist >= patrol_limit:
		direction = -1
	elif dist <= -patrol_limit:
		direction = 1

	velocity.x = direction * SPEED
	move_and_slide()
