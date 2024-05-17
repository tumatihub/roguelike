class_name Hittable
extends Node

signal got_hit
signal lost_all_hit_points

@export var _hit_points: int
@export var _weapon_type: Weapon.Type
@export var _damage_label_scene: PackedScene
@export var _label_position: Marker2D
@export var _can_lose_hit_points := true

var _current_hit_points: int

func _ready() -> void:
	_current_hit_points = _hit_points

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
	
	if _current_hit_points == 0:
		lost_all_hit_points.emit()
	print("%s got hit with %d damage" % [owner.name, real_damage])
