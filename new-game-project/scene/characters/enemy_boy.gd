extends Area2D

func _ready() -> void:
	await get_tree().create_timer(randf_range(1.0, 3.0)).timeout
	$AnimationPlayer.play("small bob")

func _on_body_entered(body:Node2D) -> void:
	if body.name == "Mortis":
		var mortis = get_tree().current_scene.get_node("Mortis")
		mortis.take_damage(15, Vector2(750, -750))  # Knockback right and slightly up

		$AudioStreamPlayer.stream = load("res://resource/Sounds/sfx/enemyHurt.wav")
		$AudioStreamPlayer.play()
		Global.apply_poison_damage(25)
		print("YOU HURT ME >:(")



func _on_area_entered(area:Area2D) -> void:
	print("Yeah something enterred. What are you gonna do abouit it FOR THE ENMY?")
	if area.name == "PoisonBall":
		call_deferred("_disable_collision")
		$AudioStreamPlayer.stream = load("res://resource/Sounds/sfx/enemyHurt.wav")
		$AudioStreamPlayer.pitch_scale = 0.75
		$AudioStreamPlayer.play()
		print("I GOT HIT BY BALL >:(")
		$AnimationPlayer.play("heDed")
		await get_tree().create_timer(0.5).timeout
		Global.heal_poison(10)
		queue_free()

func _disable_collision():
	$CollisionShape2D.disabled = true

