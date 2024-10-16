class_name ModeMenu
extends CommandMenu

func _init(_last : EditorMenu, _initial_mode : MapHandler.MODE) -> void:
	category = "Modes"
	var _commands : Array[Command] = []
	for i : int in MapHandler.MODE.size():
		_commands.append(ModeCommand.new(MapHandler.MODE_NAMES[i], self, i))
	var default_command : Command = _commands[_initial_mode]
	super(default_command.name, _last, _commands)
	index = _initial_mode

func get_mode() -> MapHandler.MODE:
	return (commands[index] as ModeCommand).mode

func update_commands() -> void:
	rename(commands[index].name)
	super()
