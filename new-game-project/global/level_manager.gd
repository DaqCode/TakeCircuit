extends Node

# Array of level scenes preloaded as PackedScene objects
var levels = [
    preload("res://scene/levels/level1.tscn"),
    preload("res://scene/levels/level2.tscn"),
    preload("res://scene/levels/level3.tscn"),
    preload("res://scene/levels/level4.tscn"),
    preload("res://scene/levels/level5.tscn"),
    preload("res://scene/levels/level6.tscn"),
    preload("res://scene/levels/level7.tscn"),
    preload("res://scene/UI/ending.tscn")

]

var current_level_index: int = 0

func get_current_level_path() -> String:
    return levels[current_level_index].resource_path

func load_next_level() -> void:
    current_level_index += 1
    if current_level_index >= levels.size():
        current_level_index = 0  # or handle game completion differently
    get_tree().change_scene_to_file(levels[current_level_index].resource_path)

func reload_current_level() -> void:
    get_tree().change_scene_to_file(levels[current_level_index].resource_path)

func load_selected_level(level: int) -> void:    
    current_level_index = level - 1  # Convert level (1-7) to index (0-6)
    get_tree().change_scene_to_file(levels[current_level_index].resource_path)
