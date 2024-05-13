class_name Biome
extends Resource

const MAX_RANGE = 100
@export var biome_name: String

@export_range(0, MAX_RANGE) var altitude_min: float
@export_range(0, MAX_RANGE) var altitude_max: float = MAX_RANGE
@export_range(0, MAX_RANGE) var moisture_min: float
@export_range(0, MAX_RANGE) var moisture_max: float = MAX_RANGE
@export_range(0, MAX_RANGE) var temperature_min: float
@export_range(0, MAX_RANGE) var temperature_max: float = MAX_RANGE

@export var terrain: int
@export var terrain_set: int
@export var layer: int
@export var exclude: bool = false

func is_this_biome(altitude_sample: float, altitude_range: Array[float], \
		moisture_sample: float, moisture_range: Array[float], \
		temperature_sample: float, temperature_range: Array[float]) -> bool:
	
	if exclude:
		return false
	var altitude := inverse_lerp(altitude_range[0], altitude_range[1], altitude_sample) * MAX_RANGE
	var moisture := inverse_lerp(moisture_range[0], moisture_range[1], moisture_sample) * MAX_RANGE
	var temperature := inverse_lerp(temperature_range[0], temperature_range[1], temperature_sample) * MAX_RANGE
	
	if altitude >= altitude_min and altitude <= altitude_max and \
		moisture >= moisture_min and moisture <= moisture_max and \
		temperature >= temperature_min and temperature <= temperature_max:
		#print("Biome: %s -> alt: %s, moist: %s, temp: %s" % [biome_name, altitude, moisture, temperature])
		return true
	else:
		#print("Not Biome: %s -> alt: %s, moist: %s, temp: %s" % [biome_name, altitude, moisture, temperature])
		return false

