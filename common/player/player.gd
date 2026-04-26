extends CharacterBody2D

const BASE_SPEED: float = 100.0
const BOOSTED_SPEED: float = 150.0
const JUMP_VELOCITY: float = -200.0

var speed: float = BASE_SPEED
var can_double_jump: bool = false
var has_double_jumped: bool = false

@export var max_health: int = 5
var health: int
var invincible: bool = false
 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var hud: CanvasLayer
var health_bar: ProgressBar
var pickup_label: Label
var pickup_timer: Timer
var shop_ui_scene: PackedScene = preload("res://common/shop/shop_ui.tscn")
var shop_ui: CanvasLayer = null
var shop_open: bool = false

var is_hurt: bool = false

func _ready():
	add_to_group("player")
	health = max_health
	_setup_hud()
	_setup_shop()
	apply_upgrades()
	GameState.gem_pickup_message.connect(_show_pickup_message)

func _setup_hud():
	hud = CanvasLayer.new()
	add_child(hud)

	var panel = PanelContainer.new()
	panel.position = Vector2(10, 10)
	hud.add_child(panel)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	var label = Label.new()
	label.text = "Player Health"
	vbox.add_child(label)

	health_bar = ProgressBar.new()
	health_bar.min_value = 0
	health_bar.max_value = max_health
	health_bar.value = health
	health_bar.custom_minimum_size = Vector2(120, 16)
	vbox.add_child(health_bar)

	pickup_label = Label.new()
	pickup_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pickup_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	pickup_label.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	pickup_label.position = Vector2(-200, -80)
	pickup_label.size = Vector2(400, 40)
	pickup_label.visible = false
	hud.add_child(pickup_label)

	pickup_timer = Timer.new()
	pickup_timer.one_shot = true
	pickup_timer.wait_time = 2.5
	pickup_timer.timeout.connect(func(): pickup_label.visible = false)
	add_child(pickup_timer)

func _setup_shop():
	shop_ui = shop_ui_scene.instantiate()
	add_child(shop_ui)
	shop_ui.visible = false
	shop_ui.shop_closed.connect(func(): shop_open = false)

func _show_pickup_message(text: String) -> void:
	pickup_label.text = text
	pickup_label.visible = true
	pickup_timer.start()

func apply_upgrades() -> void:
	speed = BOOSTED_SPEED if GameState.has_speed_boost else BASE_SPEED
	can_double_jump = GameState.has_double_jump

func toggle_shop_ui() -> void:
	shop_open = not shop_open
	if shop_open:
		shop_ui.open()
	else:
		shop_ui.close()

func force_close_shop() -> void:
	shop_open = false
	shop_ui.close()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and GameState.shop_unlocked:
		toggle_shop_ui()

func _physics_process(delta: float) -> void:
	if shop_open:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		has_double_jumped = false

	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif can_double_jump and not has_double_jumped:
			velocity.y = JUMP_VELOCITY
			has_double_jumped = true

	var direction := Input.get_axis("move_left", "move_right")
	
	#flip character
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true 
	
	#play animations
	if not is_hurt:
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("run") 
		else:
			animated_sprite_2d.play("fall")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

	# Stomp detection
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision == null:
			continue
		var body = collision.get_collider()
		if body == null:
			continue
		
		if body.is_in_group("enemy"):
			# Check if player is falling onto enemy
			if velocity.y > 0:
				if body.has_method("take_damage"):
					body.take_damage(1)
					# Bounce player up after stomp
					velocity.y = -250

func take_damage(amount: int):
	if invincible:
		return
	
	health -= amount
	health_bar.value = health
	if health <= 0:
		die()
		return
	invincible = true
	#play hurt animatoin
	is_hurt = true
	animated_sprite_2d.play("hurt")
	await get_tree().create_timer(0.3).timeout
	is_hurt = false
	
	await get_tree().create_timer(1.0).timeout
	invincible = false

func die():
	set_physics_process(false)
	set_process_input(false)
	#play die animation
	animated_sprite_2d.play("die")
	await get_tree().create_timer(2.5).timeout
	
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.6)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	hud.add_child(overlay)

	var label = Label.new()
	label.text = "PLAYER DIED\nGAME OVER"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.add_theme_font_size_override("font_size", 48)
	hud.add_child(label)
	
	await get_tree().create_timer(2.5).timeout
	
	get_tree().change_scene_to_file("res://common/main_menu/main_menu.tscn")
