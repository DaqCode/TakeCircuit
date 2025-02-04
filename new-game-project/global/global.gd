# Global.gd
extends Node

signal poison_changed(current: float, max: float)
signal player_died

# The maximum poison (like health); starts full.
var poison_max: float
var poison_current: float

func _ready() -> void:
	# You might initialize arrays here to manage enemy instances or level events.
	pass

# Call this function when an action costs you poison (jumping, dashing, enemy hit, etc.)
func apply_poison_damage(amount: float) -> void:
	poison_current -= amount
	poison_current = clamp(poison_current, 0.0, poison_max)
	emit_signal("poison_changed", poison_current, poison_max)
	if poison_current <= 0.0:
		mortis_died()

func mortis_died() -> void:
	if poison_current <= 0.0:
		emit_signal("player_died")

# Call this function when you pick up a healing item.
func heal_poison(amount: float) -> void:
	poison_current += amount
	poison_current = clamp(poison_current, 0.0, poison_max)
	emit_signal("poison_changed", poison_current, poison_max)
