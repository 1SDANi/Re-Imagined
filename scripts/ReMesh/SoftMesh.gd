class_name SoftMesh
extends VoxelMesh

func _ready() -> void:
	super()
	if not game.AtlasUpdate.connect(atlas_update) == OK:
		pass

func atlas_update() -> void:
	var _atlas : Texture2DArray = game.map.get_atlas_array()
	# not working for some reason
	(material_override as ShaderMaterial).set_shader_parameter("u_texture_array", _atlas)

func set_tex(pos : Vector3i, w : String, x : String, y : String, z : String) -> void:
	tool.channel = VoxelBuffer.CHANNEL_INDICES
	tool.set_voxel(pos, VoxelTool.vec4i_to_u16_indices(get_indices(w, x, y, z)))

func set_blend(pos : Vector3i, blend : Color) -> void:
	tool.channel = VoxelBuffer.CHANNEL_WEIGHTS
	tool.set_voxel(pos, VoxelTool.color_to_u16_weights(blend))

func get_geo(pos : Vector3i) -> float:
	tool.channel = VoxelBuffer.CHANNEL_SDF
	return tool.get_voxel_f(pos)

func has_geo(pos : Vector3i) -> bool:
	return not is_equal_approx(get_geo(pos), 500.0)

func set_geo(pos : Vector3i, value : float) -> void:
	tool.channel = VoxelBuffer.CHANNEL_SDF
	tool.set_voxel_f(pos, snappedf(value / 500,  0.1))

func place_geo(pos : Vector3i, value : float) -> void:
	if not has_geo(pos): set_geo(pos, value)

func max_geo(pos : Vector3i) -> void:
	set_geo(pos, -1.0)

func remove_geo(pos : Vector3i) -> void:
	if has_geo(pos): set_geo(pos, 500.0)

func change_geo(p : Vector3i, change : float) -> void:
	tool.channel = VoxelBuffer.CHANNEL_SDF
	var geo : float = tool.get_voxel_f(p)
	set_geo(p, geo + change)

func add_geo(p : Vector3i, change : float) -> void:
	change_geo(p, change)

func sub_geo(p : Vector3i, change : float) -> void:
	change_geo(p, -change)

func get_indices(w : String, x : String, y : String, z : String) -> Vector4i:
	var a : int = game.map.get_texture_index(w)
	var b : int = game.map.get_texture_index(x)
	var c : int = game.map.get_texture_index(y)
	var d : int = game.map.get_texture_index(z)
	return Vector4i(a, b, c, d)

func get_texture(indices : Vector4i) -> String:
	return game.map.get_texture_name(indices[0])
