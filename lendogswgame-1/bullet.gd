extends Area2D

# === SETTINGS ===
const SPEED = 500.0
const DAMAGE = 25

var direction = Vector2.RIGHT  # set by player when spawned

func _physics_process(delta):
	# Move in the direction it was fired
	position += direction * SPEED * delta

func _on_body_entered(body):
	# If we hit a zombie, damage it
	if body.is_in_group("zombies"):
		body.take_damage(DAMAGE)
	# Destroy bullet on any collision
	queue_free()

func _ready():
	# Auto-destroy after 3 seconds so bullets don't pile up forever
	await get_tree().create_timer(3.0).timeout
	queue_free()
