class_name EnvTree
extends Node

@export var _animation_player: AnimationPlayer
@export var _hittable: Hittable

func _ready() -> void:
	_hittable.got_hit.connect(_on_got_hit)
	_hittable.lost_all_hit_points.connect(_on_lost_all_hit_points)

func _on_got_hit() -> void:
	if not _animation_player.is_playing():
		_animation_player.play("shake")
	
func _on_lost_all_hit_points() -> void:
	queue_free()
