extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$AnimationPlayer.play("show_place")

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "show_place":
		$AnimationPlayer.play("hebounce")
	elif anim_name == "hebounce":
		$AnimationPlayer.play("hebounce")


func _on_play_mouse_entered() -> void:
	$SFX.play()

func _on_levels_mouse_entered() -> void:
	$SFX.play()

func _on_levels_pressed() -> void:
	pass # Replace with function body.

func _on_play_pressed() -> void:
	print ("YES YOURE CLICKING FOOL")
	get_tree().change_scene_to_file("res://scene/levels/level1.tscn")
