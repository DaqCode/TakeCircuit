class_name Battery
extends Area2D


func _on_battery_entered(body:Node2D) -> void:
	if body.name == "Spark":
		print("TOUCHED")
		EventBus.emit_battery_collected()