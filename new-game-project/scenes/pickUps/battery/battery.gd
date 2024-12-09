class_name Battery
extends Area2D


func _on_battery_entered(body:Node2D) -> void:
	if body.name == "Spark":
		EventBus.emit_battery_collected()
		queue_free()