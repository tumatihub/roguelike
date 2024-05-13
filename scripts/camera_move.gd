extends Camera2D

@export var speed: float = 10
@export var zoom_steps := 0.05
@export var world: World

var x: float
var y: float
var current_zoom: float

func _ready() -> void:
	current_zoom = zoom.x
	limit_left = 0
	limit_top = 0
	limit_right = world.width * 16
	limit_bottom = world.height * 16

func _process(delta: float) -> void:
	global_position += Vector2(x, y) * delta * speed * (1/current_zoom)
	
func _input(event: InputEvent) -> void:
	x = Input.get_axis("left", "right")
	y = Input.get_axis("up", "down")
	
	if Input.is_action_just_pressed("scroll up"):
		current_zoom = min(1, zoom.x + zoom_steps)
		zoom = Vector2(current_zoom, current_zoom)
	
	if Input.is_action_just_pressed("scroll down"):
		current_zoom = max(0.1, zoom.x - zoom_steps)
		zoom = Vector2(current_zoom, current_zoom)
