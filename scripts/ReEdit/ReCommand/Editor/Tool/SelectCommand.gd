class_name SelectCommand
extends ToolCommand

func _init(_last : ToolMenu, _tool : MapHandler.TOOL) -> void:
	super(_last, _tool)

func command_use(_user : Actor, _state : InputState) -> void:
	var mesh : VoxelMesh = game.get_mode_mesh((last.last as EditorMenu).get_mode())
	(last.last as EditorMenu).select_start(mesh.to_local_i(_user.position))

func command_use_release(_user : Actor, _state : InputState) -> void:
	var mesh : VoxelMesh = game.get_mode_mesh((last.last as EditorMenu).get_mode())
	if _state.is_tapped:
		(last.last as EditorMenu).deselect()
	else:
		(last.last as EditorMenu).select_end(mesh.to_local_i(_user.position))
