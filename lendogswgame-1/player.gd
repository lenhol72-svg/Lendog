extends CharacterBody2D

# --- Stats ---
@export var speed: float = 200.0
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 0.8
@export var max_health: int = 100
@export var bullet_scene: PackedScene

# --- State ---
var health: int = max_health
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO
var can_dash: bool = true

# --- Node refs ---
@onready var sprite: Sprite2D = $Sprite2D
@onready var marker: Marker2D = $Marker2D       # bullet spawn point
@onready var camera: Camera2D = $Camera2D
@onready var dash_timer: Timer = $dash_timer

# Separate cooldown timer (add a Timer node named "dash_cooldown_timer" to Player)
@onready var dash_cooldown_timer: Timer = $dash_cooldown_timer

func _ready() -> void:
	dash_timer.wait_time = dash_duration
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_on_dash_timer_timeout)

	dash_cooldown_timer.wait_time = dash_cooldown
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)

func _physics_process(delta: float) -> void:
	_rotate_toward_mouse()

	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		var input_dir := _get_input_direction()
		velocity = input_dir * speed

	move_and_slide()

func _input(event: InputEvent) -> void:
	# Shoot
	if event.is_action_pressed("shoot"):
		_shoot()

	# Dash
	if event.is_action_pressed("dash") and can_dash and not is_dashing:
		_start_dash()

# --- Movement ---

func _get_input_direction() -> Vector2:
	return Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

func _rotate_toward_mouse() -> void:
	var mouse_pos := get_global_mouse_position()
	rotation = (mouse_pos - global_position).angle()

# --- Dash ---

func _start_dash() -> void:
	var dir := _get_input_direction()
	if dir == Vector2.ZERO:
		# Dash in the direction the player is facing if no input
		dir = Vector2.RIGHT.rotated(rotation)
	dash_direction = dir
	is_dashing = true
	can_dash = false
	dash_timer.start()

	# Visual feedback
	sprite.modulate = Color(0.5, 0.8, 1.0, 0.7)

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	sprite.modulate = Color.WHITE
	dash_cooldown_timer.start()

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

# --- Shooting ---

func _shoot() -> void:
	if bullet_scene == null:
		push_warning("Player: bullet_scene is not set!")
		return
	var bullet = bullet_scene.instantiate()
	# Spawn at the Marker2D so it comes from the gun tip
	bullet.global_position = marker.global_position
	bullet.global_rotation = marker.global_rotation
	get_tree().current_scene.add_child(bullet)

# --- Health ---

func take_damage(amount: int) -> void:
	health -= amount
	health = clamp(health, 0, max_health)

	# Flash red on hit
	sprite.modulate = Color(1.0, 0.2, 0.2)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

	if health <= 0:
		_die()

func _die() -> void:
	# Replace with your game-over logic
	queue_free()
