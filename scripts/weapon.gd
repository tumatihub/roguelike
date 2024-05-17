class_name Weapon
extends Node2D

enum Type {
	HAND,
	AXE,
	PICKAXE,
	SWORD
}

@export var _animation_player: AnimationPlayer
@export var _damage: int
@export var _type: Type
@export var _delay: float

var _cooldown: float

func attack() -> void:
	if _cooldown > 0:
		return
	if _animation_player.is_playing():
		return
		
	_animation_player.play("attack")
	_cooldown = _delay

func _process(delta: float) -> void:
	if _cooldown > 0:
		_cooldown -= delta
	
func _on_area_2d_entered(area: Area2D) -> void:
	var hittable = area.get_parent() as Hittable
	if hittable == null:
		return
	hittable.hit(_damage, _type)
