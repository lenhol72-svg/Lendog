extends Area2D

const SPEED = 200.0
const MAX_HEALTH = 100
const DAMAGE = 10
const ATTACK_COOLDOWN = 2.0

var health = MAX_HEALTH
var player = null
var attack_timer = 0.0

func _ready():
	add_to_group("zombies")
	player = get_tree().get_first_node_in_group("player")
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	
	var dir = (player.global_position - global_position).normalized()
	global_position += dir * SPEED * delta

	if attack_timer > 0:
		attack_timer -= delta

func _on_area_entered(area):
	if area.is_in_group("player") and attack_timer <= 0:
		player.take_damage(DAMAGE)
		attack_timer = ATTACK_COOLDOWN

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	get_tree().current_scene.zombie_killed()
	queue_free()
