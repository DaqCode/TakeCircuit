extends Control

func _ready() -> void:
	# Assumes you have a ProgressBar node as a child named "PoisonBar".
	Global.connect("poison_changed", Callable( self, "_on_poison_changed"))
	Global.connect("player_died", Callable(self, "_on_player_died"))

func _on_poison_changed(current: float, max: float) -> void:
	var poison_bar = $PoisonBar
	poison_bar.value = (current / max) * poison_bar.max_value

func _on_player_died() -> void:
	print("Player has died – Game Over!")
	# Here you could trigger a game over screen or restart the level.
