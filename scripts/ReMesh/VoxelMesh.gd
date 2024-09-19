class_name VoxelMesh
extends VoxelTerrain

var tool : VoxelTool

func _ready() -> void:
	tool = get_voxel_tool()
