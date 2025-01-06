class_name MapHandler

var map : MapInstance

var primaries : Array[String]
var secondaries : Array[String]

var primary : String
var secondary : String

var reskin_tex : Array[String]

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
	SET,
	REMOVE,
	ADD,
	SUB,
	RECOLOR,
	ROTATE,
	SELECT,
	COPY,
	CUT,
	PASTE,
	CLEAR
}

const SOFT_MODES : Array[MODE] = [MODE.SMOOTH, MODE.SLOPE]
const MODE_NAMES : Array[String] = [ "Smooth", "Slope", "Model"]
const TOOL_NAMES : Array[String] = \
[
	"Place",
	"Set",
	"Remove",
	"Add",
	"Sub",
	"Recolor",
	"Rotate",
	"Select",
	"Copy",
	"Cut",
	"Paste",
	"Clear",]

func _init() -> void:
	map = MapInstance.new()
	map.map_size = Vector3i(150, 1, 150)
	map.tile_palette.tile_size = Vector3i(10, 20, 10)
	map.new_map()

func setup(
		_textures : Array[Image],
		_texture_names : Array[String],
		_res : int,
		_models : Array[Mesh],
		_model_names : Array[String]) -> void:
	map.setup(_textures, _texture_names, _res, _models, _model_names)

func reload_map() -> void:
	map.reload_map()

func clear_map() -> void:
	map.clear_map()

func new_map() -> void:
	map.new_map()

func get_mesher() -> VoxelMesherBlocky:
	return map.get_mesher()

func get_atlas_texture() -> ImageTexture:
	return map.get_atlas_texture()

func get_atlas_array() -> Texture2DArray:
	return map.get_atlas_array()

func get_resolution() -> int:
	return map.get_resolution()

func get_num_textures() -> int:
	return map.get_num_textures()

func get_textures() -> Array[Image]:
	return map.get_textures()

func get_texture_names() -> Array[String]:
	return map.get_texture_names()

func get_texture_index(name : String) -> int:
	return map.get_texture_index(name)

func get_texture_from_name(name : String) -> Image:
	return map.get_texture_from_name(name)

func get_texture_at_index(index : int) -> Image:
	return map.get_texture_at_index(index)

func get_texture_name(index : int) -> String:
	return map.get_texture_name(index)

func get_texture(voxel : int) -> String:
	return map.get_texture(voxel)

func get_shape(voxel : int) -> String:
	return map.get_shape(voxel)

func get_rot(voxel : int) -> int:
	return map.get_rot(voxel)

func get_skin(vox : int, texture : String) -> int:
	return map.get_skin(vox, texture)

func get_model(model : String, rot : int, terrain : String) -> int:
	return map.get_model(model, rot, terrain)

func reset_tile(position : Vector3i, priority : int) -> void:
	map.load_tile(get_tile(position, priority), position)

func pack_tile(position : Vector3i, fill : bool, fill_palette : VoxelPalette) -> MapTile:
	return map.pack_tile(position, fill, fill_palette)

func pack(position : Vector3i, size : Vector3i, fill : bool, fill_palette : VoxelPalette) -> MapTile:
	return map.pack(position, size, fill, fill_palette)

func unpack_tile(position : Vector3i, tile : MapTile) -> void:
	map.unpack_tile(position, tile)

func unpack(position : Vector3i, tile : MapTile) -> void:
	map.unpack(position, tile)

func clear_tile(position : Vector3i) -> void:
	map.clear_tile(position)

func clear(position : Vector3i, size : Vector3i) -> void:
	map.clear(position, size)

func save_tile(name : String, position : Vector3i, fill : bool, fill_palette : VoxelPalette) -> void:
	map.save_tile(name, position, fill, fill_palette)

func set_tile(name : String, position : Vector3i, priority : int) -> void:
	map.set_tile(name, position, priority)
	save_map()

func get_tile(position : Vector3i, priority : int) -> String:
	return map.get_tile(position, priority)

func get_pos(position : Vector3i) -> Vector3i:
	var x : int = floori(float(position.x) / float(map.tile_palette.tile_size.x))
	var y : int = floori(float(position.y) / float(map.tile_palette.tile_size.y))
	var z : int = floori(float(position.z) / float(map.tile_palette.tile_size.z))
	return Vector3i(x, y, z)

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
		print("failed to save to " + save_location + ".res")
	else:
		print("saved to " + save_location + ".res")

func load_map() -> void:
	map = (ResourceLoader.load("res://" + save_location + ".res") as MapInstance)
	if not map:
		print("failed to load from " + save_location + ".res")
	else:
		print("loaded from " + save_location + ".res")
