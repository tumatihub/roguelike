class_name World
extends Node2D

@export var noise_texture: NoiseTexture2D

@export var forest_min := -0.01
@export var forest_max := 0.01
@export var desert_min := 0.01
@export var desert_max := 0.9
@export var width := 20
@export var height := 20
@export var tile_map: TileMap

func _ready() -> void:
	create_terrain()
	update_border()

#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
		#update_border()

func create_terrain() -> void:
	var forest: Array[Vector2i]
	var desert: Array[Vector2i]
	var noise := noise_texture.noise
	var max_noise := -INF
	var min_noise := INF
	for x in range(width):
		for y in range(height):
			var noise_sample := noise.get_noise_2d(x, y)
			if noise_sample > max_noise:
				max_noise = noise_sample
			else:
				if noise_sample < min_noise:
					min_noise = noise_sample
			if noise_sample >= forest_min and noise_sample < forest_max:
				forest.append(Vector2i(x, y))
				#tile_map.set_cells_terrain_connect(0, [Vector2i(x, y)], 1, 0, false)
				#await get_tree().process_frame
			elif noise_sample >= desert_min and noise_sample < desert_max:
				desert.append(Vector2i(x, y))
				#tile_map.set_cells_terrain_connect(0, [Vector2i(x, y)], 1, 1, false)
				#await get_tree().process_frame
			else:
				tile_map.set_cell(2, Vector2i(x, y), 1, Vector2i(4, 7))
	tile_map.set_cells_terrain_connect(0, forest, 1, 4, false)
	tile_map.set_cells_terrain_connect(0, desert, 1, 5, false)
	print(str(min_noise) + " | " + str(max_noise))

func update_border() -> void:
	var border_cells: Array[Dictionary]
	var border_cells_coords: Array[Vector2i]
	for x in range(width):
		for y in range(height):
			var tile_data := tile_map.get_cell_tile_data(0, Vector2i(x, y))
			if tile_data == null:
				continue
			
			var cells := _get_all_surrounding_cells(Vector2i(x, y))
			var surrounding_nulls := 0
			for c in cells:
				if tile_map.get_cell_tile_data(0, c) == null:
					surrounding_nulls += 1
			if surrounding_nulls >= 5:
				tile_map.erase_cell(0, Vector2i(x, y))
				tile_map.set_cell(2, Vector2i(x, y), 1, Vector2i(4, 7))
				surrounding_nulls = 0
			elif surrounding_nulls > 0:
				border_cells.append({ "coords": Vector2i(x, y), "terrain": tile_data.terrain })
				border_cells_coords.append(Vector2i(x, y))
				#tile_map.set_cells_terrain_connect(0, [Vector2i(x, y)], 1, 2, false)
				#tile_map.set_cell(1, Vector2i(x, y), 1, Vector2i(4, 7))
				var source := 7
				match tile_data.terrain:
					0: source = 7
					1: source = 8
				#tile_map.set_cell(1, Vector2i(x, y), source, Vector2i(2, 3))
				
	for c in border_cells_coords:
		tile_map.set_cells_terrain_connect(0, [c], 1, 2, false)
	for c in border_cells_coords:
		tile_map.set_cells_terrain_connect(0, [c], 1, 2, false)
	#var forest: Array[Vector2i]
	#var desert: Array[Vector2i]
	#for c in border_cells:
		#match c["terrain"]:
			#0: forest.append(c["coords"])
			#1: desert.append(c["coords"])
	#tile_map.set_cells_terrain_connect(0, forest, 0, 2, false)
	#tile_map.set_cells_terrain_connect(0, desert, 0, 3, false)

func _get_all_surrounding_cells(coords_cell: Vector2i) -> Array[Vector2i]:
	var cells_coords: Array[Vector2i]
	for x in range(coords_cell.x-1, coords_cell.x+2):
		for y in range(coords_cell.y-1, coords_cell.y+2):
			cells_coords.append(Vector2i(x, y))
	return cells_coords
