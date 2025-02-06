extends Control

func _ready() -> void:
	self.visible = false
	print("Win screen loaded!")  # Debugging
	Global.connect("show_win_screen", Callable(self, "call_animation"))

func call_animation() -> void:
	# Update the score text.
	$Panel/ShowScore.text = "Your score is: " + str(Global.poison_current) + " of " + str(Global.poison_max)
	$AnimationPlayer.play("appear")
	self.visible = true  # Show the win screen
	var mortis = get_tree().current_scene.get_node("Mortis")
	mortis.ShowSmallDanceIguess()


func _on_main_menu_pressed() -> void:
	get_tree().reload_current_scene()

func _on_retry_pressed() -> void:
	LevelManager.load_next_level()
