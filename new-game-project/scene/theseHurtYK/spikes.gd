extends Area2D

func _on_body_entered(body:Node2D) -> void:
	if body.name == "Mortis":
		Global.apply_poison_damage(35)
		print("YOU HURT ME >:(")