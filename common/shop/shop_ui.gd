extends CanvasLayer

signal shop_closed

@onready var gem_count_label: Label = $Panel/VBox/GemCountLabel
@onready var speed_button: Button = $Panel/VBox/SpeedButton
@onready var double_jump_button: Button = $Panel/VBox/DoubleJumpButton
@onready var close_button: Button = $Panel/VBox/CloseButton

func _ready() -> void:
	visible = false
	speed_button.pressed.connect(_on_speed_pressed)
	double_jump_button.pressed.connect(_on_double_jump_pressed)
	close_button.pressed.connect(close)
	GameState.gems_changed.connect(_on_gems_changed)
	GameState.upgrades_changed.connect(_refresh)

func toggle() -> void:
	if visible:
		close()
	else:
		open()

func open() -> void:
	visible = true
	_refresh()

func close() -> void:
	if not visible:
		return
	visible = false
	shop_closed.emit()

func _on_gems_changed(_new_amount: int) -> void:
	if visible:
		_refresh()

func _refresh() -> void:
	gem_count_label.text = "Gems: %d" % GameState.gem_count

	if GameState.has_speed_boost:
		speed_button.text = "Speed Boost (OWNED)"
		speed_button.disabled = true
	else:
		speed_button.text = "Speed Boost (%d gems)" % GameState.SPEED_BOOST_COST
		speed_button.disabled = not GameState.can_afford(GameState.SPEED_BOOST_COST)

	if GameState.has_double_jump:
		double_jump_button.text = "Double Jump (OWNED)"
		double_jump_button.disabled = true
	else:
		double_jump_button.text = "Double Jump (%d gems)" % GameState.DOUBLE_JUMP_COST
		double_jump_button.disabled = not GameState.can_afford(GameState.DOUBLE_JUMP_COST)

func _on_speed_pressed() -> void:
	if GameState.buy_speed_boost():
		_apply_upgrades_to_player()
		_refresh()

func _on_double_jump_pressed() -> void:
	if GameState.buy_double_jump():
		_apply_upgrades_to_player()
		_refresh()

func _apply_upgrades_to_player() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return
	var player := players[0]
	if player.has_method("apply_upgrades"):
		player.call("apply_upgrades")
