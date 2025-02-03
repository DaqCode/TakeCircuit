extends Control


func _ready() -> void:
	# Assumes you have a ProgressBar node as a child named "PoisonBar".
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
	# Here you could trigger a game over screen or restart the level.
