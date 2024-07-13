extends VoxelMesh
class_name SoftMesh

func set_tex(pos : Vector3i, texture : String) -> void:
	tool.channel = VoxelBuffer.CHANNEL_INDICES
	tool.set_voxel(pos, VoxelTool.vec4i_to_u16_indices(get_indices(texture)))

func set_blend(pos : Vector3i, blend : Color) -> void:
	tool.channel = VoxelBuffer.CHANNEL_WEIGHTS
	tool.set_voxel(pos, VoxelTool.color_to_u16_weights(blend))

func set_geo(pos : Vector3i, value : float) -> void:
	tool.channel = VoxelBuffer.CHANNEL_SDF
	tool.set_voxel_f(pos, value)

func place_geo(pos : Vector3i) -> void:
	set_geo(pos, 0.0)

func max_geo(pos : Vector3i) -> void:
	set_geo(pos, -1.0)

func remove_geo(pos : Vector3i) -> void:
	set_geo(pos, 1.0)

func change_geo(p : Vector3i, change : float) -> void:
	tool.channel = VoxelBuffer.CHANNEL_SDF
	var geo : float = tool.get_voxel_f(p)
	set_geo(p, geo + change)

func get_indices(texture : String) -> Vector4i:
	var i : int = texture_names.find(texture)
	return Vector4i(i, i+1, i+2, i+3)

func get_texture(indices : Vector4i) -> String:
	return texture_names[indices[0]]

func remove(p : Vector3i) -> void:
	var _voxel : int = tool.get_voxel(p)
	tool.channel = VoxelBuffer.CHANNEL_SDF
	tool.set_voxel_f(p, 1)
