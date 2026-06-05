extends Node2D

@export var zombie_scene: PackedScene

const SPAWN_INTERVAL = 2.0
const SPAWN_DISTANCE = 500.0

var score = 0
var spawn_timer = 0.0

func _ready():
	if zombie_scene == null:
		print("ERROR: Zombie Scene not assigned in Inspector!")

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_zombie()
		spawn_timer = SPAWN_INTERVAL

	$ScoreLabel.text = "Score: " + str(score)

func spawn_zombie():
	if zombie_scene == null:
		return
	
	var zombie = zombie_scene.instantiate()
	add_child(zombie)

	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var angle = randf() * TAU
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * SPAWN_DISTANCE
	zombie.global_position = spawn_pos

func zombie_killed():
	score += 10
