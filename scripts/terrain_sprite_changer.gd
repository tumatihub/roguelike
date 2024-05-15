class_name TerrainSpriteChanger
extends Node

@export var _sprite: Sprite2D
@export var _forest_texture: Texture2D
@export var _desert_texture: Texture2D
@export var _taiga_texture: Texture2D
@export var _swamp_texture: Texture2D
@export var _tundra_texture: Texture2D

var _world: World

func _ready() -> void:
	_world = get_tree().get_first_node_in_group("world") as World
	if _world == null:
		printerr("Can't find the World")
		return
	change_texture()

func change_texture() -> void:
	var terrain := _world.get_biome_with_position(_sprite.global_position)
	var texture: Texture2D
	match terrain:
		World.Terrain.DESERT: texture = _desert_texture
		World.Terrain.FOREST: texture = _forest_texture
		World.Terrain.TAIGA: texture = _taiga_texture
		World.Terrain.SWAMP: texture = _swamp_texture
		World.Terrain.TUNDRA: texture = _tundra_texture
	if texture != null:
		_sprite.texture = texture
	
	
