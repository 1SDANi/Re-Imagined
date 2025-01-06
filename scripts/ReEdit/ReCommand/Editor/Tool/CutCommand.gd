class_name CutCommand
extends ToolCommand

func _init(_last : ToolMenu, _tool : MapHandler.TOOL) -> void:
	super(_last, _tool)

func command_use(_user : Actor, _state : InputState) -> void:
	(last.last as EditorMenu).copy()
	(last.last as EditorMenu).clear()
