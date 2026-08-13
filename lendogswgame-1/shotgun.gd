extends Area2D

const PICKUP_DISTANCE = 50.0

var player = null

func _ready():
	add_to_group("shotguns")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	
	var distance = global_position.distance_to(player.global_position)
	if distance < PICKUP_DISTANCE:
		print("Player picked up shotgun!")
		player.activate_shotgun()
		get_tree().current_scene.shotgun_picked_up()
		queue_free()
