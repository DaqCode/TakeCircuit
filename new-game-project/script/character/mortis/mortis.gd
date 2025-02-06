# Player.gd
extends CharacterBody2D

signal fireball_launched
signal dash_bar
signal fireball_bar

@export var fireball_scene: PackedScene  # assign Fireball.tscn in the Inspector
@export var fireball_offset: Vector2 = Vector2(20, 0)  # adjust offset as needed

@export var speed: float = 200.0
@export var jump_speed: float = -400.0
@export var dash_speed: float = 500.0
@export var gravity: float = 800.0
@export var coyote_time_max: float = 0.1  # Grace period for coyote jump in seconds

var can_dash: bool = true
var is_dashing: bool = false
var is_dashing_animating: bool = false
var is_dead: bool = false


var dash_direction: int = 1
var can_shoot: bool = true

# Timer for coyote jump (not a Node; just a float)
var coyote_time: float = 0.25

@onready var mortis_animation := $MortisAnimations

func _ready() -> void:
	# Connect signals if you plan to use them for extra logic
	connect("dash_bar", Callable(self, "_on_dash_bar_updated"))
	connect("fireball_bar", Callable(self, "_on_fireball_bar_updated"))

func _process(_delta: float) -> void:
	# Update the UI cooldown bars every frame
	update_dash_bar()
	update_fireball_bar()

func update_dash_bar() -> void:
	# Check if the dash timer is still counting down.
	if $DashTimer.time_left > 0:
		$Cooldowns/Dash.visible = true
		$Cooldowns/Dash.max_value = $DashTimer.wait_time
		$Cooldowns/Dash.value = $DashTimer.time_left
	else:
		$Cooldowns/Dash.visible = false

func update_fireball_bar() -> void:
	# Check if the fire timer is still counting down.
	if $FireTimer.time_left > 0:
		$Cooldowns/Shooting.visible = true
		$Cooldowns/Shooting.max_value = $FireTimer.wait_time
		$Cooldowns/Shooting.value = $FireTimer.time_left
	else:
		$Cooldowns/Shooting.visible = false



func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Vector2.ZERO

	if is_dead:
		# Optionally, set velocity to zero to stop any movement.
		velocity = Vector2.ZERO
		move_and_slide()
		return  

	if is_dashing:
		velocity.y = 0

	# Fireball attack
	if Input.is_action_just_pressed("fire") and can_shoot:
		mortis_animation.play("PoisonBall")
		emit_signal("fireball_launched")  # Emit the fireball_launched signal
		Global.apply_poison_damage(7)
		launch_fireball()
	elif Input.is_action_just_pressed("fire") and not can_shoot:
		print("CANT SHOOT ON COOLDOWN")

	# Basic horizontal movement (when not dashing)
	if Input.is_action_pressed("left") and not is_dashing and not is_dashing_animating:
		input_direction.x -= 1
		mortis_animation.flip_h = true
		mortis_animation.play("Run")
	elif Input.is_action_pressed("right") and not is_dashing and not is_dashing_animating:
		input_direction.x += 1
		mortis_animation.flip_h = false
		mortis_animation.play("Run")
	else:
		# Only play idle animation if not already in an airborne state.
		if is_on_floor() and not is_dashing_animating and not is_dashing:
			mortis_animation.play("Idle")

	input_direction = input_direction.normalized()
	velocity.x = input_direction.x * speed

	# Coyote time update: if on floor, reset coyote_time; otherwise, count down.
	if is_on_floor():
		coyote_time = coyote_time_max
	else:
		coyote_time = max(coyote_time - delta, 0)

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Jump with coyote time support
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_time > 0):
		velocity.y = jump_speed
		coyote_time = 0
		$SFX.stream = load("res://resource/Sounds/sfx/jump.wav")
		$SFX.play()
		Global.apply_poison_damage(3)

	# Airborne animation handling (only update if not dashing)
	if not is_on_floor() and not is_dashing and not is_dashing_animating:
		if velocity.y < 0:
			mortis_animation.play("Jump")
		elif velocity.y > 0 and not is_dashing_animating:
			mortis_animation.play("Fall")
		
	# Dash ability
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		dash()
		mortis_animation.play("Dash")
		
		is_dashing_animating = true  # Prevent other animations from playing
		mortis_animation.connect("animation_finished", Callable(self, "_on_dash_animation_finished"), CONNECT_ONE_SHOT)

		can_dash = false
		is_dashing = true
		emit_signal("dash_bar")
		input_direction = Vector2.ZERO

		# Determine dash direction based on input
		if Input.is_action_pressed("left"):
			input_direction.x -= 1
		elif Input.is_action_pressed("right"):
			input_direction.x += 1

		if input_direction.x < 0:
			dash_direction = -12
			Global.apply_poison_damage(7)
		elif input_direction.x > 0:
			dash_direction = 12
			Global.apply_poison_damage(7)
		else:
			print("NO input, no dashing")
			dash_direction = 0

		velocity.x = dash_direction * dash_speed

		if velocity.y > 0:
			velocity.y = 0

		is_dashing = false
		$DashTimer.start()

	    # --- Moving Platform Handling (Detect TileMap Velocity) ---
	var platform_velocity = Vector2.ZERO
	if is_on_floor():
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()

			if collider is TileMap and collider.has_method("get_platform_velocity"):
				platform_velocity = collider.get_platform_velocity()
				break  # Only consider the first moving platform encountered

	# Add the platform's velocity to the player's velocity
		velocity += platform_velocity

	move_and_slide()

func dash() -> void:
	if not can_dash:
		return

	print("Dashing started")  # Debugging
	can_dash = false
	is_dashing_animating = true

	mortis_animation.play("Dash")
	$SFX.stream = load("res://resource/Sounds/sfx/teleport.wav")
	$SFX.play()
	print("Playing Dash animation")  # Debugging

	is_dashing_animating = false
	mortis_animation.play("Idle")  # Return to idle after dashing

	# Start

func launch_fireball() -> void:
	var fireball = fireball_scene.instantiate()
	
	var spawn_position = global_position
	mortis_animation.play("PoisonBall")
	if mortis_animation.flip_h:
		spawn_position -= Vector2(fireball_offset.x, fireball_offset.y)
	else:
		spawn_position += fireball_offset
	
	fireball.position = spawn_position

	fireball.direction = Vector2(1, 0)
	if mortis_animation.flip_h:
		fireball.direction.x = -1

	fireball.rotation = fireball.direction.angle()

	get_parent().add_child(fireball)
	$FireTimer.start()
	can_shoot = false
	$SFX.stream = load("res://resource/Sounds/sfx/poisonball.wav")
	$SFX.play()
	emit_signal("fireball_bar")
	
	
func _on_dash_timer_timeout() -> void:
	can_dash = true
	is_dashing = false

func _on_fire_timer_timeout() -> void:
	can_shoot = true

func take_damage(amount: float, knockback: Vector2) -> void:
	Global.apply_poison_damage(amount)
	velocity += knockback

func _on_mortis_animation_finished() -> void:
	if mortis_animation.animation == "Dash":
		await get_tree().create_timer(0.2).timeout  
		is_dashing_animating = false
		is_dashing = false
		mortis_animation.play("Idle")

func _on_dash_animation_finished() -> void:
	if mortis_animation.animation == "Dash":
		is_dashing_animating = false
		mortis_animation.play("Idle") 
	elif mortis_animation.animation == "PoisonBall":
		mortis_animation.play("Idle")


func _on_dash_bar_updated() -> void:
	update_dash_bar()

func _on_fireball_bar_updated() -> void:
	update_fireball_bar()

func when_die() -> void:
	is_dead = true  # Set the flag so that movement code stops
	mortis_animation.play("Death")
	await get_tree().create_timer(1.0).timeout
	Global.emit_signal("show_death_screen")

func ShowSmallDanceIguess() -> void:
	is_dead = true  # Set the flag so that movement code stops
	mortis_animation.play("Win")
	await get_tree().create_timer(1.0).timeout
