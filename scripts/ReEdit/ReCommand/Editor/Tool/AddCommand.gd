class_name AddCommand
extends ToolCommand

func _init(_last : ToolMenu, _tool : MapHandler.TOOL) -> void:
	super(_last, _tool)

func command_use(_user : Actor, _state : InputState) -> void:
	var editor : EditorMenu = last.last
	if editor.selection_size == Vector3i.ZERO:
		var mode : MapHandler.MODE = editor.get_mode()
		var mesh : VoxelMesh = game.get_mode_mesh(mode)
		var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
		if target.x < 0.0: target.x -= 1.0
		if target.y < 0.0: target.y -= 1.0
		if target.z < 0.0: target.z -= 1.0
		var targeti : Vector3i = target + Vector3.DOWN / 2
		add(_user, _state, targeti)
	else:
		for x : int in range(editor.selection_size.x):
			for y : int in range(editor.selection_size.y):
				for z : int in range(editor.selection_size.z):
					add(_user, _state, editor.start_pos + Vector3i(x, y, z))

func add(_user : Actor, _state : InputState, targeti : Vector3i) -> void:
	var editor : EditorMenu = last.last
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var model : String = editor.get_model()
	var rot : int = editor.get_rotation()
	var primary : String = editor.get_texture(0)

	game.move_edit_viewer(targeti as Vector3)

	match(mode):
		MapHandler.MODE.MODEL:
			var voxel : int = game.map.get_model(model, rot, primary)
			(mesh as ModelMesh).set_voxel(targeti, voxel)
		MapHandler.MODE.SMOOTH:
			(mesh as SoftMesh).add_geo(targeti, editor.get_shape() * -500)
		MapHandler.MODE.SLOPE:
			(mesh as SoftMesh).add_geo(targeti, editor.get_shape() * -500)

	game.changes_complete()
	game.command_update()
