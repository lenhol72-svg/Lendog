extends Node2D

const SPAWN_INTERVAL = 0.33
const SPAWN_DISTANCE = 550.0
const HEALING_DROP_INTERVAL = 5
const HEALING_DROP_DISTANCE = 100.0

var spawn_timer = 0.0
var zombie_scene = preload("res://zombie.tscn")
var healing_pack_scene = preload("res://healing_pack.tscn")
var player = null
var player_health_bar = null
var kill_count = 0
var healing_packs_picked_up = 0
var kill_count_label = null
var healing_count_label = null

func _ready():
	print("GAME STARTED")
	player = get_tree().get_first_node_in_group("player")
	print("Player found: ", player)
	create_ui_health_bar()
	create_ui_counters()

func create_ui_health_bar():
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)
	
	player_health_bar = ProgressBar.new()
	player_health_bar.max_value = 100
	player_health_bar.value = 100
	player_health_bar.custom_minimum_size = Vector2(150, 15)
	canvas_layer.add_child(player_health_bar)
	
	player_health_bar.anchor_left = 0.0
	player_health_bar.anchor_top = 0.0
	player_health_bar.anchor_right = 0.3
	player_health_bar.anchor_bottom = 0.05
	player_health_bar.offset_left = 10
	player_health_bar.offset_top = 10
	player_health_bar.offset_right = 10
	player_health_bar.offset_bottom = 10

func create_ui_counters():
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)
	
	kill_count_label = Label.new()
	kill_count_label.text = "Kills: 0"
	kill_count_label.add_theme_font_size_override("font_size", 24)
	canvas_layer.add_child(kill_count_label)
	kill_count_label.anchor_left = 1.0
	kill_count_label.anchor_top = 0.0
	kill_count_label.offset_left = -150
	kill_count_label.offset_top = 10
	
	healing_count_label = Label.new()
	healing_count_label.text = "Healed: 0"
	healing_count_label.add_theme_font_size_override("font_size", 24)
	canvas_layer.add_child(healing_count_label)
	healing_count_label.anchor_left = 1.0
	healing_count_label.anchor_top = 0.0
	healing_count_label.offset_left = -150
	healing_count_label.offset_top = 50

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_zombie()
		spawn_timer = SPAWN_INTERVAL
	
	if player and player_health_bar:
		player_health_bar.value = player.health

func spawn_zombie():
	if zombie_scene == null or player == null:
		return
	
	var zombie = zombie_scene.instantiate()
	add_child(zombie)
	
	var angle = randf() * TAU
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * SPAWN_DISTANCE
	zombie.global_position = spawn_pos

func spawn_healing_pack(position):
	if healing_pack_scene == null:
		return
	
	var pack = healing_pack_scene.instantiate()
	add_child(pack)
	
	# Spawn away from player so it doesn't get picked up instantly
	var angle = randf() * TAU
	var drop_pos = position + Vector2(cos(angle), sin(angle)) * HEALING_DROP_DISTANCE
	pack.global_position = drop_pos
	print("Healing pack dropped at: ", drop_pos)

func zombie_killed():
	kill_count += 1
	kill_count_label.text = "Kills: " + str(kill_count)
	print("Zombies killed: ", kill_count)
	
	if kill_count % HEALING_DROP_INTERVAL == 0:
		print("5 zombies killed! Healing pack dropped!")
		spawn_healing_pack(player.global_position)

func healing_pack_picked_up():
	healing_packs_picked_up += 1
	healing_count_label.text = "Healed: " + str(healing_packs_picked_up)
	print("Healing packs picked up: ", healing_packs_picked_up)
