extends Area2D

const HEAL_AMOUNT = 30
const PICKUP_DISTANCE = 50.0

var player = null

func _ready():
	add_to_group("healing_packs")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	
	var distance = global_position.distance_to(player.global_position)
	if distance < PICKUP_DISTANCE:
		player.health += HEAL_AMOUNT
		if player.health > player.MAX_HEALTH:
			player.health = player.MAX_HEALTH
		print("Healed! Health: ", player.health)
		get_tree().current_scene.healing_pack_picked_up()
		queue_free()
