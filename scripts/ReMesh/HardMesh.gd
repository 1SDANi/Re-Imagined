extends VoxelMesh
class_name HardMesh

func get_voxel(pos : Vector3i) -> int:
	tool.channel = VoxelBuffer.CHANNEL_TYPE
	return tool.get_voxel(pos)

func has_voxel(pos : Vector3i) -> bool:
	return get_voxel(pos) > 0

func is_voxel(pos : Vector3i, voxel : int) -> bool:
	return get_voxel(pos) == voxel

func set_voxel(pos : Vector3i, voxel : int) -> void:
	tool.channel = VoxelBuffer.CHANNEL_TYPE
	tool.set_voxel(pos, voxel)

func place_voxel(pos : Vector3i, voxel : int) -> void:
	if not has_voxel(pos): set_voxel(pos, voxel)

func remove_voxel(pos : Vector3i) -> void:
	if has_voxel(pos): set_voxel(pos, 0)
