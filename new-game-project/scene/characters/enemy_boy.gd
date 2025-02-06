extends Area2D



func _on_body_entered(body:Node2D) -> void:
	if body.name == "Mortis":
		Global.apply_poison_damage(30)
		print("YOU HURT ME >:(")



func _on_area_entered(area:Area2D) -> void:
	print("Yeah something enterred. What are you gonna do abouit it")
	if area.name == "PoisonBall":
		print("I GOT HIT BY BALL >:(")
		$AnimationPlayer.play("heDed")
		await get_tree().create_timer(0.5).timeout
		Global.heal_poison(10)
		queue_free()

