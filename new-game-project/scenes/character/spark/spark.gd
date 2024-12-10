class_name Spark
extends CharacterBody2D

#Onready variables
@onready var deathProgress := $UI/DeathProgress
@onready var lifeTimer := $Timers/DeathTimer
@onready var deathText := $UI/TimerCountdown
@onready var lightForce := $PointLight2D
@onready var runningPFX := $RunParticles

# Constants
const GRAVITY = 700.0  # Downward force
const JUMP_FORCE = -200.0  # Upward force
const DASH_FORCE = 400.0  # Dash velocity
const WALL_SLIDE_SPEED = 20.0  # Maximum downward speed when sliding
const COYOTE_TIME = 0.15  # Buffer time after leaving a platform to still jump
const DASH_TIME = 0.15  # Duration of a dash
const MOVE_SPEED = 150.0  # Horizontal movement speed
const WALL_JUMP_PUSHBACK = 500.0 # Wall jump pushing to prevent wall jump on one side

# Variables
var is_dashing = false
var dash_timer = 0.0
var coyote_timer = 0.0
var can_dash = true
var is_wall_clinging = false

# Checks
var is_jumping = false
var is_wall_jumping = false

# References
@onready var sprite := $SparkAnimatedSprite

func _ready() -> void:
	#Timer for text to see increase
	$Timers/Timer.start()

	lifeTimer.wait_time = 15
	lifeTimer.start()

	deathText.text = str(lifeTimer.time_left)

	EventBus.connect("battery_collected", Callable(self, "on_battery_collected"))


func _physics_process(delta):
	# Gravity
	if not is_dashing:
		velocity.y += GRAVITY * delta

	# Horizontal movement
	var direction = 0
	if Input.is_action_pressed("right"):
		direction = 1
	elif Input.is_action_pressed("left"):
		direction = -1

	if direction != 0:
		runningPFX.emitting = true
		sprite.flip_h = direction == -1
		if is_on_floor() and not is_jumping:
			sprite.play("run")
	else:
		if is_on_floor() and not is_jumping:
			sprite.play("idle")
			runningPFX.emitting = false

	# Jumping
	if Input.is_action_just_pressed("jump"):

		if is_on_floor():
			sprite.play("jump")
			velocity.y = JUMP_FORCE
			is_jumping = true

		if is_on_wall():
			var wall_side = get_wall_side()
			if wall_side == "left":
				velocity.x = WALL_JUMP_PUSHBACK
			elif wall_side == "right":
				velocity.x = -WALL_JUMP_PUSHBACK
			velocity.y = JUMP_FORCE

	# Falling
	if not is_on_floor() and velocity.y > 0:
		sprite.play("fall")


	# Update velocity based on input
	if not is_dashing and not is_wall_clinging:
		velocity.x = direction * MOVE_SPEED

	# Wall clinging
	if is_on_wall() and not is_on_floor() and velocity.y > 0:
		is_wall_clinging = true
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)

		# if Input.is_action_pressed("up"):
		# 	velocity.y = 0
	else:
		is_wall_clinging = false
	


	# Jumping with coyote time
	if is_on_floor():
		coyote_timer = COYOTE_TIME  # Reset coyote timer when on the ground
	elif coyote_timer > 0:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump") and (coyote_timer > 0 or is_wall_clinging):
		velocity.y = JUMP_FORCE
		coyote_timer = 0  # Consume coyote time
		is_wall_clinging = false
		sprite.play("jump")


	# Dashing
	if Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		dash_timer = DASH_TIME
		can_dash = false
		velocity = Input.get_vector("left", "right", "jump", "down").normalized() * DASH_FORCE

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# Reset dash on landing
	if is_on_floor() and not is_dashing:
		can_dash = true
	
	# Reset jumping flag when Spark lands
	if is_on_floor() and is_jumping:
		is_jumping = false

	# Apply velocity
	move_and_slide()

func get_wall_side():
	if is_on_wall() and position.x < get_global_mouse_position().x:
		return "left"
	elif is_on_wall() and position.x > get_global_mouse_position().x:
		return "right"
	return ""

func _process(_delta: float) -> void:	 
	#Updates the value of the progress bar.
	deathProgress.value = lifeTimer.time_left

	#Updates the size of the light by adjusting scale.
	lightForce.scale = Vector2(lifeTimer.time_left, lifeTimer.time_left)
	

func on_battery_collected() -> void:
	lifeTimer.wait_time += 5
	lifeTimer.start()

func _on_timer_timeout() -> void:
	deathText.text = "Time left: " + str(roundi(lifeTimer.time_left))