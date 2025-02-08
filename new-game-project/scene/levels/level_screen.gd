extends Control

func _ready() -> void:
	pass

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/UI/main_menu.tscn")  # Change this to your actual menu scene path

func _on_level_1_pressed() -> void:
	LevelManager.load_selected_level(1)

func _on_level_2_pressed() -> void:
	LevelManager.load_selected_level(2)

func _on_level_3_pressed() -> void:
	LevelManager.load_selected_level(3)

func _on_level_4_pressed() -> void:
	LevelManager.load_selected_level(4)

func _on_level_5_pressed() -> void:
	LevelManager.load_selected_level(5)

func _on_level_6_pressed() -> void:
	LevelManager.load_selected_level(6)

func _on_level_7_pressed() -> void:
	LevelManager.load_selected_level(7)
