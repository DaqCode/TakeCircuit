# Fireball.gd
extends Area2D

@export var speed: float = 400.0
@export var damage: int = 25
@export var lifetime: float = 3.0  # seconds

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Optionally, connect to collision signals if you want to detect hits.
	$AnimatedSprite2D.play("go")
	$Timer.start()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	# Move the fireball along its set direction.
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	# If the fireball hits an enemy, apply damage.
	if body.is_in_group("enemies"):
		# Assuming enemy has a 'take_damage()' method.
		body.take_damage(damage)
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
	