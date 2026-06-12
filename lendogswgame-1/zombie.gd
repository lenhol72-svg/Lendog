extends Area2D

const SPEED = 100.0
const MAX_HEALTH = 50
const DAMAGE = 10
const ATTACK_COOLDOWN = 1.0

var health = MAX_HEALTH
var player = null
var attack_timer = 0.0
var health_bar = null
var is_touching_player = false

func _ready():
	add_to_group("zombies")
	player = get_tree().get_first_node_in_group("player")
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
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
	
	if is_touching_player and attack_timer <= 0:
		player.take_damage(DAMAGE)
		attack_timer = ATTACK_COOLDOWN
		print("Zombie damaging player! Health: ", player.health)

func _on_area_entered(area):
	if area.name == "CharacterBody2D" or area.is_in_group("player"):
		is_touching_player = true
		print("Zombie touching player!")

func _on_area_exited(area):
	if area.name == "CharacterBody2D" or area.is_in_group("player"):
		is_touching_player = false
		print("Zombie left player")

func take_damage(amount):
	health -= amount
	print("Zombie took damage: ", amount, " HP: ", health)
	if health_bar:
		health_bar.value = health
	
	if health <= 0:
		die()

func die():
	print("Zombie died!")
	queue_free()
