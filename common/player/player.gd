extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0

@export var max_health: int = 5
var health: int
var invincible: bool = false

var hud: CanvasLayer
var health_bar: ProgressBar

func _ready():
	add_to_group("player")
	health = max_health
	_setup_hud()

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

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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
	await get_tree().create_timer(1.0).timeout
	invincible = false

func die():
	set_physics_process(false)
	set_process_input(false)

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
