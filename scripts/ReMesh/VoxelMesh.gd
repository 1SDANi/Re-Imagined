class_name VoxelMesh
extends VoxelTerrain

var tool : VoxelTool

func _ready() -> void:
	tool = get_voxel_tool()

func to_local_i(pos : Vector3) -> Vector3i:
	var target : Vector3 = to_local(pos) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	return target + Vector3.DOWN / 2
