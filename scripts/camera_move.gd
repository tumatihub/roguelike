extends Camera2D

@export var _speed: float = 10
@export var _zoom_steps := 0.05
@export var _target: Node2D

var _current_zoom: float

func _ready() -> void:
	_current_zoom = zoom.x
	var nodes := get_tree().get_nodes_in_group("world")
	if (nodes.size() == 0):
		return
	
func _process(delta: float) -> void:
	if _target == null:
		return
	var next_pos = lerp(global_position, _target.global_position, delta * _speed)
	global_position = next_pos

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("scroll up"):
		_current_zoom = min(1, zoom.x + _zoom_steps)
		zoom = Vector2(_current_zoom, _current_zoom)
	
	if Input.is_action_just_pressed("scroll down"):
		_current_zoom = max(0.1, zoom.x - _zoom_steps)
		zoom = Vector2(_current_zoom, _current_zoom)
