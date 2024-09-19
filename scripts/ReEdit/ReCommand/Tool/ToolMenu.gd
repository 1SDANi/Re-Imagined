class_name ToolMenu
extends CommandMenu

var mode_commands : Array[Array]

func _init(_last : EditorMenu) -> void:
	mode_commands = [[],[],[]]

	var slope_commands : Array[Command] = [
		PlaceCommand.new(self, MapHandler.TOOL.PLACE),
		RemoveCommand.new(self, MapHandler.TOOL.REMOVE),
		SetCommand.new(self, MapHandler.TOOL.SET),
		AddCommand.new(self, MapHandler.TOOL.ADD),
		SubCommand.new(self, MapHandler.TOOL.SUB),
		RecolorCommand.new(self, MapHandler.TOOL.RECOLOR),
		SelectCommand.new(self, MapHandler.TOOL.SELECT),
		ToolCommand.new(self, MapHandler.TOOL.COPY),
		ToolCommand.new(self, MapHandler.TOOL.CUT),
		ToolCommand.new(self, MapHandler.TOOL.PASTE),
		ToolCommand.new(self, MapHandler.TOOL.CLEAR)
	]

	mode_commands[MapHandler.MODE.SLOPE] = slope_commands

	var smooth_commands : Array[Command] = [
		PlaceCommand.new(self, MapHandler.TOOL.PLACE),
		RemoveCommand.new(self, MapHandler.TOOL.REMOVE),
		SetCommand.new(self, MapHandler.TOOL.SET),
		AddCommand.new(self, MapHandler.TOOL.ADD),
		SubCommand.new(self, MapHandler.TOOL.SUB),
		RecolorCommand.new(self, MapHandler.TOOL.RECOLOR),
		SelectCommand.new(self, MapHandler.TOOL.SELECT),
		ToolCommand.new(self, MapHandler.TOOL.COPY),
		ToolCommand.new(self, MapHandler.TOOL.CUT),
		ToolCommand.new(self, MapHandler.TOOL.PASTE),
		ToolCommand.new(self, MapHandler.TOOL.CLEAR)
	]

	mode_commands[MapHandler.MODE.SMOOTH] = smooth_commands

	var model_commands : Array[Command] = [
		PlaceCommand.new(self, MapHandler.TOOL.PLACE),
		RemoveCommand.new(self, MapHandler.TOOL.REMOVE),
		SetCommand.new(self, MapHandler.TOOL.SET),
		RecolorCommand.new(self, MapHandler.TOOL.RECOLOR),
		RotateCommand.new(self, MapHandler.TOOL.ROTATE),
		SelectCommand.new(self, MapHandler.TOOL.SELECT),
		ToolCommand.new(self, MapHandler.TOOL.COPY),
		ToolCommand.new(self, MapHandler.TOOL.CUT),
		ToolCommand.new(self, MapHandler.TOOL.PASTE),
		ToolCommand.new(self, MapHandler.TOOL.CLEAR)
	]

	mode_commands[MapHandler.MODE.MODEL] = model_commands

	super("Tool", _last, mode_commands[_last.mode])

func update_commands() -> void:
	set_commands(mode_commands[(last as EditorMenu).mode])
	super()
