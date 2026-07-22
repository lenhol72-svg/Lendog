extends Area2D

const HEAL_AMOUNT = 30

func _ready():
	add_to_group("healing_packs")
	area_entered.connect(_on_area_entered)
	print("Healing pack spawned at: ", global_position)

func _physics_process(delta):
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area.name == "CharacterBody2D" or area.is_in_group("player"):
			heal_player(area)

func _on_area_entered(area):
	if area.name == "CharacterBody2D" or area.is_in_group("player"):
		print("Player picked up healing pack!")
		heal_player(area)

func heal_player(player):
	player.health += HEAL_AMOUNT
	if player.health > player.MAX_HEALTH:
		player.health = player.MAX_HEALTH
	print("Player healed! Health now: ", player.health)
	queue_free()
