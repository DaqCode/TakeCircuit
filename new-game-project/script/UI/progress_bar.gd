extends Control

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	$PoisonBar.value = Global.poison_current
	$PoisonBar.max_value = Global.poison_max
	Global.connect("poison_changed", Callable( self, "_on_poison_changed"))
	Global.connect("player_died", Callable(self, "_on_player_died"))

func _on_poison_changed(current: float, max: float) -> void:
	var poison_bar = $PoisonBar
	poison_bar.value = (current / max) * poison_bar.max_value

	if poison_bar.value <= poison_bar.max_value / 4:
		poison_bar.modulate = Color("#8fde5d")
	elif poison_bar.value <= poison_bar.max_value / 2:
		poison_bar.modulate = Color("#3ca370")
	elif poison_bar.value <= poison_bar.max_value / 1.5:
		poison_bar.modulate = Color("#3d6e70")
	else:
		poison_bar.modulate = Color("#cfff70")


func _on_player_died() -> void:
	print("Player has died – Game Over!")
	var mortis = get_tree().current_scene.get_node("Mortis")
	mortis.when_die()


func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.name == "Mortis":
		self.modulate = Color("#ffffff62")


func _on_area_2d_body_exited(body:Node2D) -> void:
	if body.name == "Mortis":
		self.modulate = Color("#ffffff")
