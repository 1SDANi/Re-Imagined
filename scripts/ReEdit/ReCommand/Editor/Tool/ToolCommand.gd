class_name ToolCommand
extends Command

var tool : MapHandler.TOOL

func _init(_last : ToolMenu, _tool : MapHandler.TOOL) -> void:
	tool = _tool
	category = MapHandler.TOOL_NAMES[_tool]
	super(MapHandler.TOOL_NAMES[_tool], _last)
