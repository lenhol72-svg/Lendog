extends CharacterBody2D

# === SETTINGS ===
const SPEED = 200.0
const DASH_SPEED = 600.0
const DASH_DURATION = 0.15
const DASH_COOLDOWN = 1.0
const MAX_HEALTH = 100

# === BULLET ===
# Drag your bullet.tscn into this variable in the Inspector
@export var bullet_scene: PackedScene

# === STATE ===
var health = MAX_HEALTH
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector2.ZERO

func _process(delta):
	# === ROTATE PLAYER TO FACE MOUSE ===
	look_at(get_global_mouse_position())

	# === SHOOT ON CLICK ===
	if Input.is_action_just_pressed("shoot"):
		shoot()

	# === DASH COOLDOWN TICK ===
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	# === DASH TIMER TICK ===
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

func _physics_process(delta):
	# === GET MOVEMENT INPUT ===
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	# Normalize so diagonal isn't faster
	direction = direction.normalized()

	# === START DASH ===
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and direction != Vector2.ZERO:
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_cooldown_timer = DASH_COOLDOWN
		dash_direction = direction

	# === APPLY VELOCITY ===
	if is_dashing:
		velocity = dash_direction * DASH_SPEED
	else:
		velocity = direction * SPEED

	move_and_slide()

func shoot():
	# Spawn bullet at the GunPoint marker
	var gun_point = $GunPoint
	var bullet = bullet_scene.instantiate()
	# Add bullet to the main scene so it doesn't move with the player
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = gun_point.global_position
	# Bullet travels toward the mouse
	bullet.direction = (get_global_mouse_position() - gun_point.global_position).normalized()

func take_damage(amount):
	health -= amount
	print("Player HP: ", health)
	if health <= 0:
		die()

func die():
	print("YOU DIED")
	get_tree().reload_current_scene()
