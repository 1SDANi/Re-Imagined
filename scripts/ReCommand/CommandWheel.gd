class_name CommandWheel
extends CommandMenu

func _init(_user : Actor, _commands : Array[Command]) -> void:
	super("ERROR", self, _commands)
	_user.command_menu = commands[0]

func command_close(_user : Actor) -> void:
	index = index + 1
	_user.set_command_menu(commands[index] as CommandMenu)

func command_use(_user : Actor) -> void:
	command_close(_user)
