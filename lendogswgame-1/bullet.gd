extends Area2D

const SPEED = 500.0

var direction = Vector2.RIGHT

func _ready():
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _physics_process(delta):
	position += direction * SPEED * delta
