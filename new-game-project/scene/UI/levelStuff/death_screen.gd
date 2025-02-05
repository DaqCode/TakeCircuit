extends Control

func _ready() -> void:
	self.visible = false
	print("Death screen loaded!")  # Debugging
	Global.connect("show_death_screen", Callable(self, "call_animation"))


func call_animation() -> void:
	print("Death screen animation triggered!")  # Debugging
	await get_tree().create_timer(2.0).timeout
	$AnimationPlayer.play("appear")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/UI/main_menu.tscn")

func _on_retry_pressed() -> void:
	set_process_input(true)
	get_tree().reload_current_scene()
