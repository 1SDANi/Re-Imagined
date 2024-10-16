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

func reset_tile() -> void:
	var x : int = floori(float(game.targeti.x) / float(map.tile_palette.tile_size.x))
	var y : int = floori(float(game.targeti.y) / float(map.tile_palette.tile_size.y))
	var z : int = floori(float(game.targeti.z) / float(map.tile_palette.tile_size.z))
	map.load_tile(get_tile(), Vector3i(x, y, z))

func save_tile() -> void:
	var x : int = floori(float(game.targeti.x) / float(map.tile_palette.tile_size.x))
	var y : int = floori(float(game.targeti.y) / float(map.tile_palette.tile_size.y))
	var z : int = floori(float(game.targeti.z) / float(map.tile_palette.tile_size.z))
	var pos : Vector3i = Vector3i(x,y,z)
	map.save_tile(primary + secondary, pos)

func set_tile() -> void:
	var x : int = floori(float(game.targeti.x) / float(map.tile_palette.tile_size.x))
	var y : int = floori(float(game.targeti.y) / float(map.tile_palette.tile_size.y))
	var z : int = floori(float(game.targeti.z) / float(map.tile_palette.tile_size.z))
	map.set_tile(primary + secondary, Vector3i(x, y, z))
	save_map()

func get_tile() -> String:
	var x : int = floori(float(game.targeti.x) / float(map.tile_palette.tile_size.x))
	var y : int = floori(float(game.targeti.y) / float(map.tile_palette.tile_size.y))
	var z : int = floori(float(game.targeti.z) / float(map.tile_palette.tile_size.z))
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
		print("failed to save to " + save_location + ".res")
	else:
		print("saved to " + save_location + ".res")

func load_map() -> void:
	map = (ResourceLoader.load("res://" + save_location + ".res") as MapInstance)
	if not map:
		print("failed to load from " + save_location + ".res")
	else:
		print("loaded from " + save_location + ".res")

func mass_reskin() -> void:
	for i : int in range(primaries.size() - 1):
		for j : int in range(secondaries.size()):
			var base_name : String = primaries[0] + secondaries[j]
			var new_name : String = primaries[i + 1] + secondaries[j]
			#map.reskin(base_name, primaries[0], reskin_tex[i + 1], new_name)
	reload_map()

func reskin_at(mode : MODE, pos : Vector3i, brush : Array[String], weights : Array[float], name : String) -> void:
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var pos_x : int = floori(float(pos.x) / float(map.tile_palette.tile_size.x))
	var pos_y : int = floori(float(pos.y) / float(map.tile_palette.tile_size.y))
	var pos_z : int = floori(float(pos.z) / float(map.tile_palette.tile_size.z))
	var vox : int = mesh.tool.get_voxel(pos)
	var base : String = map.get_tile(Vector3i(pos_x, pos_y, pos_z))
	var target : String = ""
	if mode in MapHandler.SOFT_MODES:
		mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
		var indices : Vector4i = VoxelTool.u16_indices_to_vec4i(vox)
		target = map.get_texture(indices.x)
	elif mode == MapHandler.MODE.MODEL:
		target = map.get_texture(vox)
	#map.reskin(base, target, brush, weights, name)
	reload_map()
