class_name ToolMenu
extends CommandMenu

var mode_commands : Array[Array]

func _init(_last : EditorMenu, _mode : MapHandler.MODE) -> void:
	mode_commands = [[],[],[]]
	category = "Tools"

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
	var default_command : Command = mode_commands[_mode][0]

	super(default_command.name, _last, mode_commands[_mode])

func update_commands() -> void:
	set_commands(mode_commands[(last as EditorMenu).get_mode()])
	update_name()
	super()

func update_name() -> void:
	rename(commands[index].name)
