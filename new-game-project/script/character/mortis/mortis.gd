# Player.gd
extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_speed: float = -400.0
@export var dash_speed: float = 500.0
@export var gravity: float = 800.0
@export var coyote_time_max: float = 0.2  # Grace period for coyote jump in seconds

var can_dash: bool = true
var is_dashing: bool = false

var dash_direction: int = 1

# Timer for coyote jump (not a Node; just a float)
var coyote_time: float = 0.25

@onready var mortis_animation := $MortisAnimations

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Vector2.ZERO

	# Basic horizontal movement
	if Input.is_action_pressed("left") and not is_dashing:
		input_direction.x -= 1
		mortis_animation.flip_h = true
		mortis_animation.play("Run")

	elif Input.is_action_pressed("right") and not is_dashing:
		input_direction.x += 1
		mortis_animation.flip_h = false
		mortis_animation.play("Run")

	else:
		mortis_animation.play("Idle")

	input_direction = input_direction.normalized()
	velocity.x = input_direction.x * speed

	if is_on_floor():
		coyote_time = coyote_time_max
	else:
		coyote_time = max(coyote_time - delta, 0)

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_time > 0):
		velocity.y = jump_speed
		coyote_time = 0
		Global.apply_poison_damage(10)

	if not is_on_floor():
		if velocity.y < 0:
			mortis_animation.play("Jump")
		elif velocity.y > 0:
			mortis_animation.play("Fall")
		
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		input_direction= Vector2.ZERO

		# Basic horizontal movement
		if Input.is_action_pressed("left"):
			input_direction.x -= 1
		elif Input.is_action_pressed("right"):
			input_direction.x += 1
	
		can_dash = false
		is_dashing = true

		if input_direction.x < 0:
			dash_direction = -12
			Global.apply_poison_damage(15)
		elif input_direction.x > 0:
			dash_direction = 12
			Global.apply_poison_damage(15)
		else:
			print("NO input, no dashing")
			dash_direction = 0
			pass
		
		velocity.x = dash_direction * dash_speed
		if velocity.y > 0:
			velocity.y = 0
		
		is_dashing = false
		
		$DashTimer.start()
		

	move_and_slide()


func _on_dash_timer_timeout() -> void:
	can_dash = true
	is_dashing = false

func take_damage(amount: float, knockback: Vector2) -> void:
	Global.apply_poison_damage(amount)
	velocity += knockback
