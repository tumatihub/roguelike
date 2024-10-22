class_name Hittable
extends Node

signal got_hit
signal lost_all_hit_points
signal healed

@export var _hit_points: int
@export var _weapon_type: Weapon.Type
@export var _damage_label_scene: PackedScene
@export var _label_position: Marker2D
@export var _can_lose_hit_points := true
@export var _fg: ColorRect
@export var _bg: ColorRect

var _current_hit_points: int
var _cooldown: float
var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	add_child(_timer)
	_timer.timeout.connect(_on_timeout)
	_current_hit_points = _hit_points
	if _label_position:
		_fg.global_position = _label_position.global_position
		_bg.global_position = _label_position.global_position

func _process(delta: float) -> void:
	if _cooldown > 0:
		_cooldown -= delta

func hit(damage: int, type: Weapon.Type) -> void:
	got_hit.emit()
	if not _can_lose_hit_points:
		return
	var real_damage := 1
	if type == _weapon_type:
		real_damage = damage
	_current_hit_points = max(0, _current_hit_points - real_damage)
	
	var damage_label := _damage_label_scene.instantiate() as Label
	if _label_position != null:
		_label_position.add_child(damage_label)
		damage_label.global_position = _label_position.global_position
		damage_label.text = "-"+str(real_damage)
	
	update_bar()
	if _current_hit_points == 0:
		lost_all_hit_points.emit()
	print("%s got hit with %d damage" % [owner.name, real_damage])

func heal(amount: int) -> void:
	_current_hit_points = min(_hit_points, _current_hit_points + amount)
	healed.emit()
	print("%s got healed with %d" % [owner.name, amount])

func update_bar() -> void:
	_fg.scale.x = float(_current_hit_points)/float(_hit_points)
	_fg.visible = true
	_bg.visible = true
	_timer.start(1)

func _on_timeout() -> void:
	_fg.visible = false
	_bg.visible = false
