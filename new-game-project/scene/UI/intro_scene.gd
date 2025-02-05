extends Control

func _on_video_stream_player_finished() -> void:
	$VideoStreamPlayer.queue_free()
	$Animation.play("animationForIntro")
	$Button.visible = false


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "animationForIntro":
		get_tree().change_scene_to_file("res://scene/UI/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if event:
		$Button.visible = true
		await get_tree().create_timer(5.0).timeout
		$Button.visible = false

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/UI/main_menu.tscn")
