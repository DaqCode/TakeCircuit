extends Area2D

func _on_body_entered(body:Node2D) -> void:
	if body.name == "Mortis":
		var mortis = get_tree().current_scene.get_node("Mortis")
		mortis.take_damage(15, Vector2(750, -700))  # Knockback right and slightly up

		$AudioStreamPlayer.stream = load("res://resource/Sounds/sfx/enemyHurt.wav")
		$AudioStreamPlayer.play()
		Global.apply_poison_damage(30)
		print("YOU HURT ME >:(")



func _on_area_entered(area:Area2D) -> void:
	print("Yeah something enterred. What are you gonna do abouit it FOR THE ENMY?")
	if area.name == "PoisonBall":
		$AudioStreamPlayer.stream = load("res://resource/Sounds/sfx/enemyHurt.wav")
		$AudioStreamPlayer.pitch_scale = 0.75
		$AudioStreamPlayer.play()
		print("I GOT HIT BY BALL >:(")
		$AnimationPlayer.play("heDed")
		await get_tree().create_timer(0.5).timeout
		Global.heal_poison(10)
		queue_free()
