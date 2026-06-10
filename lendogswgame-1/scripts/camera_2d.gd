extends Camera2D

const ZOOM_SPEED = 0.1
const MIN_ZOOM = 0.5
const MAX_ZOOM = 3.0
const BASE_ZOOM = 1.0

func _ready():
	zoom = Vector2(BASE_ZOOM, BASE_ZOOM)

func _process(delta):
	if Input.is_action_just_pressed("Camera_Zoom_In"):
		zoom += Vector2(ZOOM_SPEED, ZOOM_SPEED)
		zoom = zoom.clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
	
	if Input.is_action_just_pressed("Camera_Zoom_Out"):
		zoom -= Vector2(ZOOM_SPEED, ZOOM_SPEED)
		zoom = zoom.clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
