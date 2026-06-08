extends Area2D

const SPEED = 100.0
const MAX_HEALTH = 50
const DAMAGE = 10
const ATTACK_COOLDOWN = 1.0

var health = MAX_HEALTH
var player = null
var attack_timer = 0.0

func _ready():
	add_to_group("zombies")
	player = get_tree().get_first_node_in_group("player")
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	# Find player if not found
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	
	# Chase player
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * SPEED * delta
	
	# Tick attack cooldown
	if attack_timer > 0:
		attack_timer -= delta

func _on_area_entered(area):
	# Damage player on contact
	if area.is_in_group("player") and attack_timer <= 0:
		player.take_damage(DAMAGE)
		attack_timer = ATTACK_COOLDOWN
		print("Zombie hit player!")

func take_damage(amount):
	health -= amount
	print("Zombie HP: ", health)
	if health <= 0:
		die()

func die():
	print("Zombie died!")
	queue_free()
