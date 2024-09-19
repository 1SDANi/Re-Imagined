class_name CommandMenu
extends Command

var commands : Array[Command]
var last : CommandMenu
var index : int
var origin : int

func _init(_name : String, _last : CommandMenu, _com : Array[Command]) -> void:
	super(_name)
	commands = _com
	last = _last
	index = 0
	origin = 0

func command_use(_user : Actor) -> void:
	command_open(_user)

func command_open(_user : Actor) -> void:
	if commands[index] is CommandMenu:
		_user.set_command_menu(commands[index] as CommandMenu)
	else:
		commands[index].command_use(_user)

func command_open_release_hold(_user : Actor) -> void:
	pass

func command_open_release_tap(_user : Actor) -> void:
	pass

func command_use_release_hold(_user : Actor) -> void:
	command_open_release_hold(_user)

func command_use_release_tap(_user : Actor) -> void:
	command_open_release_tap(_user)

func command_close(_user : Actor) -> void:
	_user.set_command_menu(last)

func command_up() -> void:
	if index >= commands.size() - 1:
		index = 0
		origin = 0
	else:
		index += 1
		if index - mini(4, commands.size() - 1) > origin:
			origin = index - mini(4, commands.size() - 1)

func command_down() -> void:
	if index <= 0:
		index = commands.size() - 1
		origin = commands.size() - 1 - mini(4, commands.size() - 1)
	else:
		index -= 1
		if index < origin:
			origin = index

func set_last(_last : CommandMenu) -> void:
	last = _last

func set_index(_index : int) -> void:
	index = _index

func set_commands(_commands : Array[Command]) -> void:
	commands = _commands

func update_commands() -> void:
	for command : Command in commands:
		command.update_commands()

func tick_commands(_delta : float) -> void:
	for command : Command in commands:
		command.tick(_delta)
