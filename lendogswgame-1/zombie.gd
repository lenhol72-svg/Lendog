extends CharacterBody2D

# === SETTINGS ===
const SPEED = 60.0
const MAX_HEALTH = 50
const DAMAGE = 10
const ATTACK_COOLDOWN = 1.0

var health = MAX_HEALTH
var player = null
var attack_timer = 0.0

func _ready():
	# Put zombie in the "zombies" group so bullets can find it
	add_to_group("zombies")
	# Find the player node
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	# === CHASE THE PLAYER ===
	if player:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * SPEED
		move_and_slide()

	# === ATTACK COOLDOWN ===
	if attack_timer > 0:
		attack_timer -= delta

func _on_player_area_entered(area):
	# This is called when zombie overlaps the player hitbox
	if attack_timer <= 0:
		player.take_damage(DAMAGE)
		attack_timer = ATTACK_COOLDOWN

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	# Tell the game a zombie died (for score)
	get_tree().current_scene.zombie_killed()
	queue_free()
