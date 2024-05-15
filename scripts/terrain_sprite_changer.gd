class_name TerrainSpriteChanger
extends Node

@export var _sprite: Sprite2D
@export var _forest_texture: Texture2D
@export var _desert_texture: Texture2D
@export var _taiga_texture: Texture2D
@export var _swamp_texture: Texture2D
@export var _tundra_texture: Texture2D

var _tile_map: TileMap

func _ready() -> void:
	_tile_map = get_tree().get_first_node_in_group("tile_map") as TileMap
	if _tile_map == null:
		printerr("Can't find the TileMap")
		return
	change_texture()

func change_texture() -> void:
	var tile_data := _tile_map.get_cell_tile_data(World.WorldLayer.TERRAIN, _tile_map.local_to_map(_sprite.global_position))
	if tile_data == null:
		return
	var terrain_id := tile_data.terrain
	var texture: Texture2D
	match terrain_id:
		0: texture = _desert_texture
		1: texture = _forest_texture
		3: texture = _taiga_texture
		4: texture = _swamp_texture
		5: texture = _tundra_texture
	
	if texture != null:
		_sprite.texture = texture
	
	
