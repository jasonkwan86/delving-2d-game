class_name OnWinMenu
extends Node

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://common/main_menu/main_menu.tscn")
