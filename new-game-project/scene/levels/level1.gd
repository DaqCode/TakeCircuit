extends Node2D

func _ready() -> void:
	Global.poison_current = 50
	Global.poison_max = 100

func _on_fall_boundary_body_entered(body:Node2D) -> void:
	if body.name == "Mortis":
		print("You fell, tou died, reset.")
		get_tree().reload_current_scene()
