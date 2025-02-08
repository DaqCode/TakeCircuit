extends Area2D

func _on_body_entered(body:Node2D) -> void:
	print("SOMETHING TOUCHED ME >:(")
	if body.name == "Mortis":
		$AudioStreamPlayer.playing = true
		print("MORTIS TOUCHED ME >:(")
		Global.heal_poison(50)
		await get_tree().create_timer(0.2).timeout
		queue_free()
	
