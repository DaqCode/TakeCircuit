extends Node2D

func _ready() -> void:
	Global.poison_current = 50
	Global.poison_max = 100

func _on_fall_boundary_body_entered(body:Node2D) -> void:
	if body.name == "Mortis":
		Global.emit_signal("show_death_screen")
		print("You fell, tou died, reset.")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		print("Detected the pause")
		Global.emit_signal("show_pause_screen")