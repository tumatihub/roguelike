class_name TileDebug
extends Node2D

@export var tile_info_scene: PackedScene
@export var debug := false
@export var layer_to_show: int = 0

var tile_map: TileMap
var tiles_with_label: Array[Vector2i]
var current_tile_pos: Vector2i
var pressing_mouse := false

func _ready() -> void:
	if not debug:
		print("Debug deativated")
		return
	tile_map = get_parent() as TileMap
	if tile_map == null:
		printerr("Missing parent Node of type TileMap")
		return
	print("Debugging for TileMap: " + tile_map.name)

func _input(event: InputEvent) -> void:
	if not debug:
		return
	if not pressing_mouse and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pressing_mouse = true
		var new_tile_pos = tile_map.local_to_map(get_global_mouse_position())
		if new_tile_pos != current_tile_pos:
			current_tile_pos = new_tile_pos
			var tile_data := tile_map.get_cell_tile_data(layer_to_show, current_tile_pos)
			if tile_data == null:
				print("Null tile_data at: " + str(current_tile_pos))
			else:
				_insert_label(tile_data, current_tile_pos)
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pressing_mouse = false

func _insert_all_labels(layer: int) -> void:
	for cell_coords in tile_map.get_used_cells(layer):
		var tile_data := tile_map.get_cell_tile_data(layer_to_show, cell_coords)
		if tile_data == null:
			print("Null tile_data at: " + str(cell_coords))
			continue
		_insert_label(tile_data, cell_coords)

func _insert_label(tile_data: TileData, tile_pos: Vector2i) -> void:
	var instance = tile_info_scene.instantiate() as TileInfo
	add_child(instance)
	instance.global_position = tile_map.map_to_local(tile_pos)
	instance.update(tile_data, tile_map, tile_pos)
