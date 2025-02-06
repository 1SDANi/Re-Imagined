class_name CommandWheel
extends CommandMenu

func _init(_user : Actor, _commands : Array[Command]) -> void:
	super("ERROR", self, _commands)
	_user.command_menu = commands[0]

func menu_select(_user : Actor) -> void:
	_user.set_command_menu(commands[index] as CommandMenu)
