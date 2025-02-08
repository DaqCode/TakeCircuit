extends Control

func _ready() -> void:
	self.position = Vector2(1200,0)
	Global.connect("show_pause_screen", Callable(self, "go_show_the_screen"))

func _on_volume_value_changed(value:float) -> void:
	if(value == -25):
		AudioServer.set_bus_volume_db(0, -200)
	AudioServer.set_bus_volume_db(0, value)

func _on_music_value_changed(value:float) -> void:
	if(value == -25):
		AudioServer.set_bus_volume_db(0, -200)
	AudioServer.set_bus_volume_db(1, value)

func _on_sfx_value_changed(value:float) -> void:
	if(value == -25):
		AudioServer.set_bus_volume_db(0, -200)
	AudioServer.set_bus_volume_db(2, value)


func _on_return_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/UI/main_menu.tscn")

func _on_back_pressed() -> void:
	get_tree().paused = false
	self.position = Vector2(1200,0)

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func go_show_the_screen() -> void:
	print("GO SHOW THE SETTING SCREEN PLEASE????")  # Debug check
	get_tree().paused = true
	self.position = Vector2(0,0)
