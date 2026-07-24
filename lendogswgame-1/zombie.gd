extends Area2D

const SPEED = 250.0
const MAX_HEALTH = 25
const DAMAGE = 10
const ATTACK_COOLDOWN = 0.4

var health = MAX_HEALTH
var player = null
var attack_timer = 0.0
var health_bar = null

func _ready():
	add_to_group("zombies")
	player = get_tree().get_first_node_in_group("player")
	create_health_bar()

func create_health_bar():
	health_bar = ProgressBar.new()
	health_bar.max_value = MAX_HEALTH
	health_bar.value = MAX_HEALTH
	health_bar.custom_minimum_size = Vector2(50, 10)
	add_child(health_bar)
	health_bar.position = Vector2(-25, -40)

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * SPEED * delta
	
	if attack_timer > 0:
		attack_timer -= delta
	
	var distance = global_position.distance_to(player.global_position)
	if distance < 50 and attack_timer <= 0:
		player.take_damage(DAMAGE)
		attack_timer = ATTACK_COOLDOWN

func take_damage(amount):
	health -= amount
	if health_bar:
		health_bar.value = health
	
	if health <= 0:
		die()

func die():
	get_tree().current_scene.zombie_killed()
	queue_free()
