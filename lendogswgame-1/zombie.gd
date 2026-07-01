extends Area2D

const SPEED = 250.0
const MAX_HEALTH = 25
const DAMAGE = 10
const ATTACK_COOLDOWN = 0.2

var health = MAX_HEALTH
var player = null
var attack_timer = 0.0
var health_bar = null

func _ready():
	add_to_group("zombies")
	player = get_tree().get_first_node_in_group("player")
	area_entered.connect(_on_area_entered)
	print("Zombie ready, player: ", player)


func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * SPEED * delta
	
	if attack_timer > 0:
		attack_timer -= delta
	
	# Check distance and damage continuously
	var distance = global_position.distance_to(player.global_position)
	if distance < 50 and attack_timer <= 0:
		player.take_damage(DAMAGE)
		attack_timer = ATTACK_COOLDOWN
		print("ZOMBIE DAMAGE! Player health: ", player.health)

func _on_area_entered(area):
	print("Area entered: ", area.name)
	if area.is_in_group("player"):
		print("Hit player!")

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
