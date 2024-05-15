extends Camera2D

@export var _speed: float = 10
@export var _zoom_steps := 0.05

var _world: World
var _x: float
var _y: float
var _current_zoom: float

func _ready() -> void:
	_current_zoom = zoom.x
	var nodes := get_tree().get_nodes_in_group("world")
	if (nodes.size() == 0):
		return
	_world = nodes[0]
	#limit_left = 0
	#limit_top = 0
	#limit_right = _world.width * 16
	#limit_bottom = _world.height * 16
	
func _input(event: InputEvent) -> void:
	_x = Input.get_axis("left", "right")
	_y = Input.get_axis("up", "down")
	
	if Input.is_action_just_pressed("scroll up"):
		_current_zoom = min(1, zoom.x + _zoom_steps)
		zoom = Vector2(_current_zoom, _current_zoom)
	
	if Input.is_action_just_pressed("scroll down"):
		_current_zoom = max(0.1, zoom.x - _zoom_steps)
		zoom = Vector2(_current_zoom, _current_zoom)
