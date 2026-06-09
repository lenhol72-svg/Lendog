extends Area2D

const SPEED = 500.0
const DAMAGE = 25

var direction = Vector2.RIGHT

func _ready():
	add_to_group("bullets")
	area_entered.connect(_on_area_entered)
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _physics_process(delta):
	position += direction * SPEED * delta

func _on_area_entered(area):
	if area.is_in_group("zombies"):
		area.take_damage(DAMAGE)
		queue_free()
