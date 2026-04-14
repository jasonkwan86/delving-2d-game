extends CharacterBody2D

const SPEED = 60.0
const PATROL_DISTANCE = 2

@export var tile_size: int = 16
@export var damage: int = 1
@export var max_health: int = 3

@onready var anim = $AnimatedSprite2D

var start_position: Vector2
var patrol_limit: float
var direction: int = -1
var initialized: bool = false

var health: int
var can_damage: bool = true
var is_dead: bool = false

func _ready() -> void:
	patrol_limit = PATROL_DISTANCE * tile_size
	health = max_health
	anim.play("idle")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not initialized:
		start_position = global_position
		initialized = true
		return

	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Patrol logic
	var dist = global_position.x - start_position.x
	if dist >= patrol_limit:
		direction = -1
	elif dist <= -patrol_limit:
		direction = 1

	velocity.x = direction * SPEED

	# Flip sprite
	anim.flip_h = direction > 0

	# Movement
	move_and_slide()

	# Animation switching
	if velocity.x != 0:
		if anim.animation != "walk":
			anim.play("walk")
	else:
		if anim.animation != "idle":
			anim.play("idle")

	check_player_collision()
	
func check_player_collision():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
	
