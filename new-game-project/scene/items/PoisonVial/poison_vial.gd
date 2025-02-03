extends Area2D

func _on_body_entered(body:Node2D) -> void:
	print("SOMETHING TOUCHED ME >:(")
	if body.name == "Mortis":
		print("MORTIS TOUCHED ME >:(")
		Global.heal_poison(50)
		queue_free()
	

