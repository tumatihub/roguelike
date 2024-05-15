class_name Player
extends CharacterBody2D

@export var _speed: float = 100
@export var _body: AnimatedSprite2D

var _x: float
var _y: float

@onready var _camera_2d: Camera2D = $Camera2D

func _process(delta: float) -> void:
	if velocity.length() > 0:
		_body.play("run")
	else:
		_body.play("idle")

func _physics_process(_delta: float) -> void:
	velocity = Vector2(_x, _y).normalized() * _speed * 1/_camera_2d.zoom
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	_x = Input.get_axis("left", "right")
	_y = Input.get_axis("up", "down")
	
	if _x < 0:
		_body.flip_h = true
	elif _x > 0:
		_body.flip_h = false
