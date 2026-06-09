extends CharacterBody2D

# === MOVEMENT ===
const SPEED = 400.0
const DASH_SPEED = 800.0
const DASH_TIME = 0.2
const DASH_COOLDOWN = 0.5

# === HEALTH ===
const MAX_HEALTH = 100

# === STATE ===
var health = MAX_HEALTH
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector2.ZERO

func _ready():
	add_to_group("player")
	health = MAX_HEALTH

func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

func _physics_process(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	direction = direction.normalized()
	
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and direction != Vector2.ZERO:
		is_dashing = true
		dash_timer = DASH_TIME
		dash_cooldown_timer = DASH_COOLDOWN
		dash_direction = direction
	
	if is_dashing:
		velocity = dash_direction * DASH_SPEED
	else:
		velocity = direction * SPEED
	
	move_and_slide()

func shoot():
	var gun_point = $GunPoint
	var bullet = load("res://bullet.tscn").instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = gun_point.global_position
	bullet.direction = (get_global_mouse_position() - gun_point.global_position).normalized()

func take_damage(amount):
	health -= amount
	print("Player health: ", health)

func die():
	print("GAME OVER")
	get_tree().reload_current_scene()
