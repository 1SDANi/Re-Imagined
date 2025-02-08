class_name RecolorCommand
extends ToolCommand

func _init(_last : ToolMenu, _tool : MapHandler.TOOL) -> void:
	super(_last, _tool)

func command_use_holding(_user : Actor, _state : InputState) -> void:
	command_use(_user, _state)

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
		recolor(_user, _state, targeti)
	else:
		for x : int in range(editor.selection_size.x):
			for y : int in range(editor.selection_size.y):
				for z : int in range(editor.selection_size.z):
					recolor(_user, _state, editor.start_pos + Vector3i(x, y, z))

func recolor(_user : Actor, _state : InputState, targeti : Vector3i) -> void:
	var editor : EditorMenu = last.last
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var primary : String = editor.get_texture(0)

	game.move_edit_viewer(targeti as Vector3)

	match(mode):
		MapHandler.MODE.MODEL:
			var voxel : int = (mesh as ModelMesh).get_voxel(targeti)
			voxel = game.map.get_skin(voxel, primary)
			(mesh as ModelMesh).set_voxel(targeti, voxel)
		MapHandler.MODE.SMOOTH:
			(mesh as SoftMesh).set_blend(targeti, editor.get_blend())
			(mesh as SoftMesh).set_tex(targeti, editor.get_texture(0), \
				editor.get_texture(1), editor.get_texture(2), editor.get_texture(3))
		MapHandler.MODE.SLOPE:
			(mesh as SoftMesh).set_blend(targeti, editor.get_blend())
			(mesh as SoftMesh).set_tex(targeti, editor.get_texture(0), \
				editor.get_texture(1), editor.get_texture(2), editor.get_texture(3))

	game.changes_complete()
	game.command_update()
