# MovingTileMap.gd
extends TileMap

var previous_position: Vector2

func _ready():
    previous_position = position  # Store initial position

func _process(delta):
    var current_position = position
    var velocity = (current_position - previous_position) / delta  # Calculate velocity
    previous_position = current_position  # Update previous position

func get_platform_velocity() -> Vector2:
    return (position - previous_position) / get_process_delta_time() * 0.01
