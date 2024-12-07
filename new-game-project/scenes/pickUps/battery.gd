extends StaticBody2D

func battery_collected(body: Node2D) -> void:
    if body.name == "Spark":
        queue_free()
