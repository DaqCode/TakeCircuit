# Player.gd
extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_speed: float = -400.0
@export var dash_speed: float = 500.0
@export var gravity: float = 800.0

var can_dash: bool = true
var dash_direction: int = 1

@onready var mortis_animation := $MortisAnimations

func _physics_process(delta: float) -> void:
    var input_direction: Vector2 = Vector2.ZERO

    # Basic horizontal movement
    if Input.is_action_pressed("left"):
        input_direction.x -= 1
        mortis_animation.flip_h = true
        mortis_animation.play("Run")
    elif Input.is_action_pressed("right"):
        input_direction.x += 1
        mortis_animation.flip_h = false
        mortis_animation.play("Run")
    else:
        mortis_animation.play("Idle")

    input_direction = input_direction.normalized()
    velocity.x = input_direction.x * speed

    # Apply gravity if not on the floor.
    if not is_on_floor():
        velocity.y += gravity * delta
    else:
        # Reset vertical speed when on the ground.
        velocity.y = 0

    # Jump (only if on the floor)
    if Input.is_action_just_pressed("jump") and is_on_floor():
        mortis_animation.play("Jump")
        velocity.y = jump_speed
        # Jumping costs poison.
        Global.apply_poison_damage(10)

    # Dash (can be used only if not on cooldown)
    if Input.is_action_just_pressed("dash") and can_dash:
        # Determine dash direction based on input.
        if input_direction.x < 0:
            dash_direction = -17
        elif input_direction.x > 0:
            dash_direction = 17
		
        # Apply the dash impulse immediately. Remove * delta.
        velocity.x = dash_direction * dash_speed
        can_dash = false
        # Dashing costs more poison.
        Global.apply_poison_damage(15)
        $DashTimer.start()

    # Perform movement.
    move_and_slide()

# Called when the DashTimer times out.
func _on_dash_timer_timeout() -> void:
    can_dash = true

# Called when you take damage from an enemy or hazard.
# 'knockback' is a Vector2 that adds a force on top of your current velocity.
func take_damage(amount: float, knockback: Vector2) -> void:
    Global.apply_poison_damage(amount)
    velocity += knockback
