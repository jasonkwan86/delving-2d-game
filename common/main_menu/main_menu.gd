extends Control

@onready var main_menu_holder: Control = $MainMenuHolder
@onready var options_holder: Control = $OptionsHolder

@onready var start_button: Button = $MainMenuHolder/MainPanel/MainMargin/MainVBox/Start
@onready var option_button: Button = $MainMenuHolder/MainPanel/MainMargin/MainVBox/Option
@onready var exit_button: Button = $MainMenuHolder/MainPanel/MainMargin/MainVBox/Exit

@onready var sound_slider: HSlider = $OptionsHolder/OptionsPanel/OptionsMargin/OptionsVBox/SoundSlider
@onready var back_button: Button = $OptionsHolder/OptionsPanel/OptionsMargin/OptionsVBox/Back

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	option_button.pressed.connect(_on_option_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	back_button.pressed.connect(_on_back_pressed)

	sound_slider.value_changed.connect(_on_sound_slider_changed)

	_show_main_menu()


func _show_main_menu() -> void:
	main_menu_holder.visible = true
	options_holder.visible = false


func _show_options_menu() -> void:
	main_menu_holder.visible = false
	options_holder.visible = true


func _on_start_pressed() -> void:

	main_menu_holder.visible = false
	options_holder.visible = false

	animation_player.play("start_animation")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://common/world_levels/hub_level/hub_level.tscn")


func _on_option_pressed() -> void:
	_show_options_menu()


func _on_back_pressed() -> void:
	_show_main_menu()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_sound_slider_changed(value: float) -> void:
	print("Sound volume:", value)
