extends CharacterBody2D

const SPEED = 60.0
const PATROL_DISTANCE = 3

@export var tile_size: int = 16
@export var damage: int = 1
@export var max_health: int = 3

@onready var anim = $AnimatedSprite2D
@onready var health_bar = $ProgressBar

var start_position: Vector2
var patrol_limit: float
var direction: int = -1
var initialized: bool = false

var health: int
var can_damage: bool = true
var is_dead: bool = false
var hover_time: float = 0.0
@export var hover_amplitude: float = 8.0   
@export var hover_speed: float = 2.0      

func _ready() -> void:
	add_to_group("enemy")
	patrol_limit = PATROL_DISTANCE * tile_size
	health = max_health
	anim.play("idle")
	health_bar.max_value = max_health
	health_bar.value = health

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not initialized:
		start_position = global_position
		initialized = true
		return
	
	# Horizontal patrol
	var dist = global_position.x - start_position.x
	if dist >= patrol_limit:
		direction = -1
	elif dist <= -patrol_limit:
		direction = 1

	velocity.x = direction * SPEED

	# Vertical hover via sine wave
	hover_time += delta
	velocity.y = sin(hover_time * hover_speed) * hover_amplitude * 2.0
	
	anim.flip_h = direction < 0
	move_and_slide()
	
	if velocity.x != 0:
		if anim.animation != "walk":
			anim.play("walk")
	else:
		if anim.animation != "idle":
			anim.play("idle")

	check_player_collision()

func check_player_collision():
	if not can_damage:
		return
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision == null:
			continue
		var body = collision.get_collider()
		if body == null:
			continue
		
		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				body.take_damage(damage)

				anim.play("attack")

				can_damage = false
				await get_tree().create_timer(1.0).timeout
				can_damage = true

func take_damage(amount: int):
	if is_dead:
		return
	health -= amount
	health_bar.value = health
	anim.play("hit")
	if health <= 0:
		die()
		return

func die():
	is_dead = true
	velocity = Vector2.ZERO
	#set_physics_process(false)
	anim.play("death")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://common/on_win_menu/on_win_menu.tscn")

func _on_head_hit_box_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	if body.is_in_group("player"):
		if body.velocity.y >= 0:
			take_damage(1)
			body.velocity.y = -300
