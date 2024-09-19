class_name AddCommand
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
	var model : String = editor.model_shape
	var rot : int = editor.model_rot
	var primary : String = editor.get_texture(0)

	match(editor.mode):
		MapHandler.MODE.MODEL:
			var voxel : int = game.map.get_model(model, rot, primary)
			(mesh as ModelMesh).set_voxel(targeti, voxel)
		MapHandler.MODE.SMOOTH:
			(mesh as SoftMesh).add_geo(targeti, game.palette.slope_value)
		MapHandler.MODE.SLOPE:
			(mesh as SoftMesh).add_geo(targeti, game.palette.smooth_value)
