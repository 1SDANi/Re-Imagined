class_name MapHandler

var map : MapInstance

var primaries : Array[String]
var secondaries : Array[String]

var primary : String
var secondary : String

var save_location : String

enum MODE
{
	SMOOTH,
	SLOPE,
	MODEL
}

enum TOOL
{
	PLACE,
	MAX,
	REMOVE,
	GROW,
	SHRINK
}

const SOFT_MODES : Array[MODE] = [MODE.SMOOTH, MODE.SLOPE]
const MODE_NAMES : Array[String] = [ "Smooth", "Slope", "Model"]
const TOOL_NAMES : Array[String] = [ "Place", "Max", "Remove", "Grow", "Shrink" ]

func _init() -> void:
	map = MapInstance.new()
	map.tile_size = Vector3i(5, 10, 5)
	map.map_size = Vector3i(200, 1, 200)
	for x : int in range(map.map_size.x):
		(map.tiles as Array[Array]).append([])
		for y : int in range(map.map_size.y):
			(map.tiles as Array[Array])[x].append([])
			for z : int in range(map.map_size.z):
				((map.tiles as Array[Array])[x] as Array[Array])[y].append("")

func reskin(mode : MapHandler.MODE, pos : Vector3i, tex : String) -> void:
	map.reskin(mode, pos, tex, primary + secondary)

func reload_map() -> void:
	map.reload_map()

func clear_map() -> void:
	map.clear_map()

func reset_tile() -> void:
	var x : int = floori(float(game.targeti.x) / float(map.tile_size.x))
	var y : int = floori(float(game.targeti.y) / float(map.tile_size.y))
	var z : int = floori(float(game.targeti.z) / float(map.tile_size.z))
	map.load_tile(get_tile(), Vector3i(x, y, z), map.tile_size)

func save_tile() -> void:
	var x : int = floori(float(game.targeti.x) / float(map.tile_size.x))
	var y : int = floori(float(game.targeti.y) / float(map.tile_size.y))
	var z : int = floori(float(game.targeti.z) / float(map.tile_size.z))
	var pos : Vector3i = Vector3i(
		x * map.tile_size.x,
		y * map.tile_size.y,
		z * map.tile_size.z)
	map.save_tile(primary + secondary, pos, map.tile_size)

func set_tile() -> void:
	var x : int = floori(float(game.targeti.x) / float(map.tile_size.x))
	var y : int = floori(float(game.targeti.y) / float(map.tile_size.y))
	var z : int = floori(float(game.targeti.z) / float(map.tile_size.z))
	map.set_tile(primary + secondary, Vector3i(x, y, z))
	save_map()

func get_tile() -> String:
	var x : int = floori(float(game.targeti.x) / float(map.tile_size.x))
	var y : int = floori(float(game.targeti.y) / float(map.tile_size.y))
	var z : int = floori(float(game.targeti.z) / float(map.tile_size.z))
	return map.get_tile(Vector3i(x, y, z))

func set_primary(name : String) -> void:
	primary = name

func get_primary() -> String:
	return primary

func set_secondary(name : String) -> void:
	secondary = name

func get_secondary() -> String:
	return secondary

func set_save_location(location : String) -> void:
	save_location = location

func get_save_location() -> String:
	return save_location

func save_map() -> void:
	if not ResourceSaver.save(map, "res://" + save_location + ".res") == OK:
		print("failed to save")

func load_map() -> void:
	map = (ResourceLoader.load("res://" + save_location + ".res") as MapInstance)
