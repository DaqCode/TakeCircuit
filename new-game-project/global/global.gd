# Global.gd
extends Node

signal poison_changed(current: float, max: float)
signal player_died
signal show_death_screen
signal show_win_screen
signal show_pause_screen

# The maximum poison (like health); starts full.
var poison_max: float
var poison_current: float

# Call this function when an action costs you poison (jumping, dashing, enemy hit, etc.)
func apply_poison_damage(amount: float) -> void:
	poison_current -= amount
	poison_current = clamp(poison_current, 0.0, poison_max)
	emit_signal("poison_changed", poison_current, poison_max)
	if poison_current <= 0.0:
		mortis_died()

func mortis_died() -> void:
	if poison_current <= 0.0:
		print("Mortis has died!")  # Debugging
		emit_signal("player_died")
		emit_signal("show_death_screen")


# Call this function when you pick up a healing item.
func heal_poison(amount: float) -> void:
	poison_current += amount
	poison_current = clamp(poison_current, 0.0, poison_max)
	emit_signal("poison_changed", poison_current, poison_max)
