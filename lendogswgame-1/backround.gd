extends Node2D

var tile_size = 192  # Changed from 64 to 192 (64 * 3)
var tiles = {}
var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	update_tiles()

func _process(delta):
	if player:
		update_tiles()

func update_tiles():
	if player == null:
		return
	
	var player_tile_x = int(player.global_position.x / tile_size)
	var player_tile_y = int(player.global_position.y / tile_size)
	
	# Create tiles around player (3x3 grid)
	for x in range(player_tile_x - 1, player_tile_x + 2):
		for y in range(player_tile_y - 1, player_tile_y + 2):
			var tile_key = Vector2i(x, y)
			
			if not tile_key in tiles:
				create_tile(x, y)

func create_tile(x: int, y: int):
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/64 by 64 art.png")
	sprite.scale = Vector2(3, 3)  # Scale up 3x
	sprite.z_index = -1
	add_child(sprite)
	
	sprite.position = Vector2(x * tile_size, y * tile_size)
	tiles[Vector2i(x, y)] = sprite
	
	print("Created tile at: ", x, ", ", y)
