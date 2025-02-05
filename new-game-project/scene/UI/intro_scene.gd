extends Control

func _on_video_stream_player_finished() -> void:
	$VideoStreamPlayer.queue_free()
	$Animation.play("animationForIntro")


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "animationForIntro":
		get_tree().change_scene_to_file("res://scene/main_menu.tscn")
