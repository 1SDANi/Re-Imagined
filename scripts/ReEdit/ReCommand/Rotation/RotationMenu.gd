class_name RotationMenu
extends CommandMenu

func _init(_last : EditorMenu) -> void:
	var _commands : Array[Command] = []
	for _rot : int in range(16):
		_commands.append(RotationCommand.new(self, _rot))
	super("Rotation", _last, _commands)
