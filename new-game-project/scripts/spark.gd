extends CharacterBody2D

# Constants
const GRAVITY = 1300.0  # Downward force
const JUMP_FORCE = -500.0  # Upward force
const DASH_FORCE = 400.0  # Dash velocity
const WALL_SLIDE_SPEED = 100.0  # Maximum downward speed when sliding
const COYOTE_TIME = 0.15  # Buffer time after leaving a platform to still jump
const DASH_TIME = 0.2  # Duration of a dash
const MOVE_SPEED = 200.0  # Horizontal movement speed

# Variables
var is_dashing = false
var dash_timer = 0.0
var coyote_timer = 0.0
var can_dash = true
var is_wall_clinging = false

# References
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
    # Gravity
    if not is_dashing:
        velocity.y += GRAVITY * delta

    # Horizontal movement
    var direction = 0
    if Input.is_action_pressed("right"):
        direction += 1
    if Input.is_action_pressed("left"):
        direction -= 1

    # Update velocity based on input
    if not is_dashing and not is_wall_clinging:
        velocity.x = direction * MOVE_SPEED

    # Wall sliding
    if is_on_wall() and not is_on_floor() and velocity.y > 0:
        is_wall_clinging = true
        velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
    else:
        is_wall_clinging = false

    # Jumping with coyote time
    if is_on_floor():
        coyote_timer = COYOTE_TIME  # Reset coyote timer when on the ground
    elif coyote_timer > 0:
        coyote_timer -= delta

    if Input.is_action_just_pressed("up") and (coyote_timer > 0 or is_wall_clinging):
        velocity.y = JUMP_FORCE
        coyote_timer = 0  # Consume coyote time
        is_wall_clinging = false

    # Dashing
    if Input.is_action_just_pressed("dash") and can_dash:
        is_dashing = true
        dash_timer = DASH_TIME
        can_dash = false
        velocity = Input.get_vector("left", "right", "up", "down").normalized() * DASH_FORCE

    if is_dashing:
        dash_timer -= delta
        if dash_timer <= 0:
            is_dashing = false

    # Reset dash on landing
    if is_on_floor() and not is_dashing:
        await get_tree().create_timer(5.0)
        can_dash = true

    # Apply velocity
    move_and_slide()

