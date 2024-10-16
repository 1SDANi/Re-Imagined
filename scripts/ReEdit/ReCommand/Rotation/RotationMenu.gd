class_name RotationMenu
extends CommandMenu

func _init(_last : EditorMenu) -> void:
	var _commands : Array[Command] = []
	category = "Shape"
	for _rot : int in range(16):
		_commands.append(RotationCommand.new(self, _rot))
	super(_commands[index].name, _last, _commands)

func update_commands() -> void:
	update_name()
	super()

func update_name() -> void:
	rename(commands[index].name)
