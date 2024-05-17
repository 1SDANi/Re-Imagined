extends VoxelTerrain
class_name SlopeMesh

var tool : VoxelTool

func _ready() -> void:
	game.set_slope_mesh(get_path())
	tool = get_voxel_tool()


func place(pos : Vector3i) -> void:
	tool.channel = VoxelBuffer.CHANNEL_TYPE
	var voxel : int = tool.get_voxel(pos)
	var data : Variant = tool.get_voxel_metadata(pos)

	if voxel <= 0:
		tool.set_voxel(pos, 1)
	else:
		tool.set_voxel(pos, 0)
