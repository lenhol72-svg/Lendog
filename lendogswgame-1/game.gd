extends Node2D

const SPAWN_INTERVAL = 3.0
const SPAWN_DISTANCE = 400.0

var spawn_timer = 0.0
var zombie_scene = preload("res://zombie.tscn")
var player = null
var player_health_bar = null
var camera = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player:
		camera = player.get_node("Camera2D")
	create_ui_health_bar()

func create_ui_health_bar():
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)
	
	player_health_bar = ProgressBar.new()
	player_health_bar.max_value = 100
	player_health_bar.value = 100
	player_health_bar.custom_minimum_size = Vector2(300, 30)
	canvas_layer.add_child(player_health_bar)
	
	# Fix position in screen space
	player_health_bar.anchor_left = 0.0
	player_health_bar.anchor_top = 0.0
	player_health_bar.anchor_right = 0.3
	player_health_bar.anchor_bottom = 0.05
	player_health_bar.offset_left = 10
	player_health_bar.offset_top = 10
	player_health_bar.offset_right = 10
	player_health_bar.offset_bottom = 10

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_zombie()
		spawn_timer = SPAWN_INTERVAL
	
	# Update player health bar
	if player and player_health_bar:
		player_health_bar.value = player.health

func spawn_zombie():
	if zombie_scene == null:
		return
	
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	
	var zombie = zombie_scene.instantiate()
	add_child(zombie)
	
	var angle = randf() * TAU
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * SPAWN_DISTANCE
	zombie.global_position = spawn_pos
