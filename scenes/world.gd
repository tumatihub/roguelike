class_name World
extends Node2D

signal terrain_created

@export var noise_texture: NoiseTexture2D
@export var altitude_noise_texture: NoiseTexture2D
@export var moisture_noise_texture: NoiseTexture2D
@export var temperature_noise_texture: NoiseTexture2D

@export var width := 20
@export var height := 20
@export var tile_map: TileMap

@export var _desert: Biome
@export var _forest: Biome
@export var _taiga: Biome
@export var _swamp: Biome
@export var _tundra: Biome

enum WorldLayer {
	TERRAIN,
	ENV,
	WATER
}

enum Terrain {
	DESERT,
	FOREST,
	CLIFFS,
	TAIGA,
	SWAMP,
	TUNDRA,
	NONE
}

var _desert_cells: Array[Vector2i]
var _forest_cells: Array[Vector2i]
var _taiga_cells: Array[Vector2i]
var _swamp_cells: Array[Vector2i]
var _tundra_cells: Array[Vector2i]

var altitude_range: Array[float]
var moisture_range: Array[float]
var temperature_range: Array[float]

func _ready() -> void:
	pass
	#create_terrain()
	#_update_border()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		create_terrain()
		_update_border()
		_place_env_objects(_desert, _desert_cells)
		_place_env_objects(_forest, _forest_cells)
		_place_env_objects(_taiga, _taiga_cells)
		_place_env_objects(_swamp, _swamp_cells)
		_place_env_objects(_tundra, _tundra_cells)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var tile_pos := tile_map.local_to_map(get_global_mouse_position())
		var altitude := inverse_lerp(altitude_range[0], altitude_range[1], altitude_noise_texture.noise.get_noise_2d(tile_pos.x, tile_pos.y)) * 100
		var moisture := inverse_lerp(moisture_range[0], moisture_range[1], moisture_noise_texture.noise.get_noise_2d(tile_pos.x, tile_pos.y)) * 100
		var temperature := inverse_lerp(temperature_range[0], temperature_range[1], temperature_noise_texture.noise.get_noise_2d(tile_pos.x, tile_pos.y)) * 100
		print("alt: %s , moist: %s, temp: %s" % [altitude, moisture, temperature])
		
func create_terrain() -> void:
	_place_water_outside()
	seed(altitude_noise_texture.noise.get_seed())
	altitude_range = _get_noise_range(altitude_noise_texture)
	moisture_range = _get_noise_range(moisture_noise_texture)
	temperature_range = _get_noise_range(temperature_noise_texture)
	for x in range(width):
		for y in range(height):
			var coords := Vector2i(x, y)
			var altitude_sample := altitude_noise_texture.noise.get_noise_2d(x, y)
			var moisture_sample := moisture_noise_texture.noise.get_noise_2d(x, y)
			var temperature_sample := temperature_noise_texture.noise.get_noise_2d(x, y)
			if _forest.is_this_biome(altitude_sample, altitude_range, moisture_sample, moisture_range, temperature_sample, temperature_range):
				_forest_cells.append(coords)
				#tile_map.set_cells_terrain_connect(_forest.layer, [coords], _forest.terrain_set, _forest.terrain, false)
			elif _desert.is_this_biome(altitude_sample, altitude_range, moisture_sample, moisture_range, temperature_sample, temperature_range):
				_desert_cells.append(coords)
				#tile_map.set_cells_terrain_connect(_desert.layer, [coords], _desert.terrain_set, _desert.terrain, false)
			elif _taiga.is_this_biome(altitude_sample, altitude_range, moisture_sample, moisture_range, temperature_sample, temperature_range):
				_taiga_cells.append(coords)
				#tile_map.set_cells_terrain_connect(_taiga.layer, [coords], _taiga.terrain_set, _taiga.terrain, false)
			elif _swamp.is_this_biome(altitude_sample, altitude_range, moisture_sample, moisture_range, temperature_sample, temperature_range):
				_swamp_cells.append(coords)
				#tile_map.set_cells_terrain_connect(_swamp.layer, [coords], _swamp.terrain_set, _swamp.terrain, false)
			elif _tundra.is_this_biome(altitude_sample, altitude_range, moisture_sample, moisture_range, temperature_sample, temperature_range):
				_tundra_cells.append(coords)
				#tile_map.set_cells_terrain_connect(_tundra.layer, [coords], _tundra.terrain_set, _tundra.terrain, false)
			else:
				tile_map.set_cell(2, coords, 1, Vector2i(4, 7))
	
	var time := Time.get_ticks_msec()
	tile_map.set_cells_terrain_connect(_desert.layer, _desert_cells, _desert.terrain_set, _desert.terrain, false)
	tile_map.set_cells_terrain_connect(_forest.layer, _forest_cells, _forest.terrain_set, _forest.terrain, false)
	tile_map.set_cells_terrain_connect(_taiga.layer, _taiga_cells, _taiga.terrain_set, _taiga.terrain, false)
	tile_map.set_cells_terrain_connect(_swamp.layer, _swamp_cells, _swamp.terrain_set, _swamp.terrain, false)
	tile_map.set_cells_terrain_connect(_tundra.layer, _tundra_cells, _tundra.terrain_set, _tundra.terrain, false)
	print("Terrain created in %d seconds" % [(Time.get_ticks_msec() - time)/1000])
	terrain_created.emit()

func _update_tiles(cells: Array[Vector2i], biome: Biome) -> void:
	var begin := 1
	var end := 100
	var slice := cells.slice(begin, end)
	while slice.size() > 0:
		begin = end
		end += 100
		tile_map.set_cells_terrain_connect(biome.layer, slice, biome.terrain_set, biome.terrain, false)
		slice = cells.slice(begin, end)
		await get_tree().process_frame
	print(biome.biome_name + " " + str(Time.get_ticks_msec()/1000))

func _place_water_outside() -> void:
	var margin := 50
	for x in range(-margin, width + margin):
		for y in range(-margin, height + margin):
			if x >= 0 and x < width and y >= 0 and y < height:
				continue
			tile_map.set_cell(WorldLayer.WATER, Vector2i(x, y), 1, Vector2i(4, 7))

func _update_border() -> void:
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
				
	for c in border_cells_coords:
		tile_map.set_cells_terrain_connect(0, [c], 1, 2, false)
	for c in border_cells_coords:
		tile_map.set_cells_terrain_connect(0, [c], 1, 2, false)

func _place_env_objects(biome: Biome, biome_cells: Array[Vector2i]) -> void:
	var place_stats: Array[Dictionary]
	for cell in biome_cells:
		var surrounding_cells := _get_all_surrounding_cells(cell)
		var is_border := false
		for c in surrounding_cells:
			var tile_data = tile_map.get_cell_tile_data(WorldLayer.TERRAIN, c)
			if tile_data != null:
				if tile_data.terrain != biome.terrain:
					is_border = true
					break
		if is_border:
			continue
		for obj in biome.env_objects:
			if randf() * 100 < obj.probability:
				tile_map.set_cell(WorldLayer.ENV, cell, obj.tile_source, obj.atlas_coords, obj.alternative_tile)
				var found := false
				for i in place_stats:
					if i.get("name") == obj.object_name:
						i["qty"] += 1
						found = true
						break
				if not found:
					place_stats.append({"name": obj.object_name, "qty": 1})
				break
	_print_biome_stats(place_stats, biome)

func _print_biome_stats(place_stats: Array[Dictionary], biome: Biome) -> void:
	print("Stats for: %s" % [biome.biome_name])
	for i in place_stats:
		print("%s -> %d" % [i.get("name"), i.get("qty")])

func _get_noise_range(noise_texture: NoiseTexture2D) -> Array[float]:
	var max_noise := -INF
	var min_noise := INF
	for x in range(width):
		for y in range(height):
			var noise: float = noise_texture.noise.get_noise_2d(x, y)
			if noise > max_noise:
				max_noise = noise
			elif noise < min_noise:
				min_noise = noise
	return [min_noise, max_noise]

func _get_all_surrounding_cells(coords_cell: Vector2i) -> Array[Vector2i]:
	var cells_coords: Array[Vector2i]
	for x in range(coords_cell.x-1, coords_cell.x+2):
		for y in range(coords_cell.y-1, coords_cell.y+2):
			cells_coords.append(Vector2i(x, y))
	return cells_coords

