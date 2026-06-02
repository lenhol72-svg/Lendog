extends Node2D

# === Drag zombie.tscn here in the Inspector ===
@export var zombie_scene: PackedScene

# === SETTINGS ===
const SPAWN_INTERVAL = 2.0   # seconds between spawns
const SPAWN_DISTANCE = 400.0 # how far off screen zombies appear

var score = 0
var spawn_timer = 0.0

func _process(delta):
	# === SPAWN TIMER ===
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_zombie()
		spawn_timer = SPAWN_INTERVAL

	# === UPDATE SCORE DISPLAY ===
	$ScoreLabel.text = "Score: " + str(score)

func spawn_zombie():
	var zombie = zombie_scene.instantiate()
	add_child(zombie)

	# Spawn at a random position around the edge of the screen
	var screen_size = get_viewport_rect().size
	var center = screen_size / 2
	var angle = randf() * TAU  # random angle in a full circle
	zombie.global_position = center + Vector2(cos(angle), sin(angle)) * SPAWN_DISTANCE

func zombie_killed():
	score += 10
