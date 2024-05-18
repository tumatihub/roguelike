class_name Weapon
extends Node2D

signal updated_durability(percentage: float)
signal weapon_broke(slot_data: SlotData)

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
@export var _max_durability: int = 1000
@export var _durability_lost_per_hit: int = 10

var _cooldown: float
var _current_durability: int

var slot_data: SlotData
var durability_percentage: float:
	get:
		return float(_current_durability)/float(_max_durability)

func _ready() -> void:
	_current_durability = _max_durability

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
	_current_durability = max(0, _current_durability - _durability_lost_per_hit)
	if _current_durability > 0:
		updated_durability.emit(durability_percentage)
	else:
		weapon_broke.emit(slot_data)
