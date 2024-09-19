class_name ModeMenu
extends CommandMenu

func _init(_last : EditorMenu) -> void:
	var _commands : Array[Command] = []
	for i : int in MapHandler.MODE.size():
		_commands.append(ModeCommand.new(MapHandler.MODE_NAMES[i], self, i))
	super("Mode", _last, _commands)
