class_name SubCommand
extends ToolCommand

func _init(_last : ToolMenu, _tool : MapHandler.TOOL) -> void:
	super(_last, _tool)

func command_use(_user : Actor) -> void:
	var editor : EditorMenu = last.last
	var mesh : VoxelMesh = game.get_mode_mesh()
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2

	match(editor.mode):
		MapHandler.MODE.MODEL:
			(mesh as ModelMesh).remove_voxel(targeti)
		MapHandler.MODE.SMOOTH:
			(mesh as SoftMesh).sub_geo(targeti, game.palette.slope_value)
		MapHandler.MODE.SLOPE:
			(mesh as SoftMesh).sub_geo(targeti, game.palette.smooth_value)
