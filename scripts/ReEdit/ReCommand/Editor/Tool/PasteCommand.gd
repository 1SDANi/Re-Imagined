class_name PasteCommand
extends ToolCommand

func _init(_last : ToolMenu, _tool : MapHandler.TOOL) -> void:
	super(_last, _tool)

func command_use(_user : Actor, _state : InputState) -> void:
	var mesh : VoxelMesh = game.get_mode_mesh((last.last as EditorMenu).get_mode())
	(last.last as EditorMenu).paste(mesh.to_local_i(_user.position))
