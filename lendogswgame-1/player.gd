extends CharacterBody2D

# === MOVEMENT ===
const SPEED = 400.0
const DASH_SPEED = 800.0
const DASH_TIME = 0.2
const DASH_COOLDOWN = 0.5

# === HEALTH ===
const MAX_HEALTH = 100

# === SHOTGUN ===
var has_shotgun = false
var shotgun_timer = 0.0
const SHOTGUN_DURATION = 15.0

# === STATE ===
var health = MAX_HEALTH
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector2.ZERO
var is_dead = false

func _ready():
	add_to_group("player")
	health = MAX_HEALTH
	z_index = 10

func _process(delta):
	if is_dead:
		return
	
	# Shotgun timer
	if has_shotgun:
		shotgun_timer -= delta
		if shotgun_timer <= 0:
			has_shotgun = false
			print("Shotgun expired! Get the next one in 30 seconds")
	
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
	if is_dead:
		return
	
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
	
	if has_shotgun:
		# Shotgun: 5 bullets in a spread
		for i in range(5):
			var angle_offset = (i - 2) * 15
			var direction = (get_global_mouse_position() - gun_point.global_position).normalized()
			direction = direction.rotated(deg_to_rad(angle_offset))
			
			var bullet = load("res://bullet.tscn").instantiate()
			get_tree().current_scene.add_child(bullet)
			bullet.global_position = gun_point.global_position
			bullet.direction = direction
	else:
		# Normal: 1 bullet
		var bullet = load("res://bullet.tscn").instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = gun_point.global_position
		bullet.direction = (get_global_mouse_position() - gun_point.global_position).normalized()

func take_damage(amount):
	if is_dead:
		return
	
	health -= amount
	print("Player took ", amount, " damage! Health: ", health)
	
	if health <= 0:
		health = 0
		die()

func activate_shotgun():
	has_shotgun = true
	shotgun_timer = SHOTGUN_DURATION
	print("SHOTGUN ACTIVATED! 15 second duration")

func die():
	is_dead = true
	print("PLAYER DEAD! GAME OVER")
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
