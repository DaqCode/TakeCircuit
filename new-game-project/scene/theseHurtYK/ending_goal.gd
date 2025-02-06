extends Area2D

func _on_body_entered(body:Node2D) -> void:
	if body.name == "Mortis":
		Global.emit_signal("show_win_screen")
		
		
