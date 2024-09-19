class_name RotateCommand
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
	var rot : int = editor.model_rot

	if editor.mode == MapHandler.MODE.MODEL:
		var voxel : int = (mesh as ModelMesh).get_voxel(targeti)
		var primary : String =  game.map.get_texture(voxel)
		var shape : String = game.map.get_shape(voxel)
		voxel = game.map.get_model(shape, rot, primary)
		(mesh as ModelMesh).set_voxel(targeti, voxel)
