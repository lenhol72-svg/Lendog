extends CharacterBody2D

const SPEED = 500.0
const DAMAGE = 25

var direction = Vector2.RIGHT

func _ready():
	area_entered.connect(_on_area_entered)
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta):
	position += direction * SPEED * delta

func _on_area_entered(area):
	if area.is_in_group("zombies"):
		if area.has_method("take_damage"):
			area.take_damage(DAMAGE)
	queue_free()
