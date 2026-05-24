extends CharacterBody2D

@export var speed = 250
@export var dash_speed = 700
@export var dash_time = 0.15

var can_dash = true
var is_dashing = false

func _physics_process(delta):

	var direction = Vector2.ZERO

	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	direction = direction.normalized()

	if not is_dashing:
		velocity = direction * speed

	if Input.is_action_just_pressed("dash") and can_dash:
		start_dash(direction)

	move_and_slide()

func start_dash(direction):

	if direction == Vector2.ZERO:
		return

	can_dash = false
	is_dashing = true

	velocity = direction * dash_speed

	await get_tree().create_timer(dash_time).timeout

	is_dashing = false

	$dash_timer.start()

func _on_dash_timer_timeout():
	can_dash = true
