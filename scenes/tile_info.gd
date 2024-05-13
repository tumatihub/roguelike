class_name TileInfo
extends Node2D

@export var terrain_label: Label
@export var grid: GridContainer
@export var border: Control
@export var arrows: Control

var coords: Vector2i
var tile_map: TileMap

func update(tile_data: TileData, tile_map: TileMap, coords: Vector2i) -> void:
	self.coords = coords
	self.tile_map = tile_map
	
	terrain_label.text = str(coords)
	_update_peering(tile_data, tile_map, grid.get_child(0), TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER)
	_update_peering(tile_data, tile_map, grid.get_child(1), TileSet.CELL_NEIGHBOR_TOP_SIDE)
	_update_peering(tile_data, tile_map, grid.get_child(2), TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER)
	_update_peering(tile_data, tile_map, grid.get_child(3), TileSet.CELL_NEIGHBOR_LEFT_SIDE)
	_update_peering(tile_data, tile_map, grid.get_child(5), TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
	_update_peering(tile_data, tile_map, grid.get_child(6), TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER)
	_update_peering(tile_data, tile_map, grid.get_child(7), TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
	_update_peering(tile_data, tile_map, grid.get_child(8), TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
	grid.get_child(4).color = tile_map.tile_set.get_terrain_color(1, tile_data.terrain)
	
	_update_arrow(tile_map, coords, arrows.get_child(0), TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER)
	_update_arrow(tile_map, coords, arrows.get_child(1), TileSet.CELL_NEIGHBOR_TOP_SIDE)
	_update_arrow(tile_map, coords, arrows.get_child(2), TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER)
	_update_arrow(tile_map, coords, arrows.get_child(3), TileSet.CELL_NEIGHBOR_LEFT_SIDE)
	_update_arrow(tile_map, coords, arrows.get_child(4), TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
	_update_arrow(tile_map, coords, arrows.get_child(5), TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER)
	_update_arrow(tile_map, coords, arrows.get_child(6), TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
	_update_arrow(tile_map, coords, arrows.get_child(7), TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
	
func _update_peering(tile_data: TileData, tile_map: TileMap, color_rect: ColorRect, peering_bit: TileSet.CellNeighbor) -> void:
	var bit: int = tile_data.get_terrain_peering_bit(peering_bit)
	if bit == -1:
		color_rect.color.a = 0
		return
	
	color_rect.color = tile_map.tile_set.get_terrain_color(1, bit)

func _update_arrow(tile_map: TileMap, coords: Vector2i, arrow: TextureRect, neighbor: TileSet.CellNeighbor) -> void:
	var neighbor_coords = tile_map.get_neighbor_cell(coords, neighbor)
	var tile_data = tile_map.get_cell_tile_data(0, neighbor_coords)
	if tile_data == null:
		arrow.visible = true

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		queue_free()

func _on_grid_container_mouse_entered() -> void:
	_show()
	
func _on_grid_container_mouse_exited() -> void:
	_hide()

func _hide() -> void:
	terrain_label.visible = false
	border.visible = false
	arrows.visible = false
		
func _show() -> void:
	terrain_label.visible = true
	border.visible = true
	arrows.visible = true

func _print_neighbors() -> void:
	print("Neighbors of " + str(coords) + ":")
	for c in tile_map.get_surrounding_cells(coords):
		print(str(c))
