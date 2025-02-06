class_name CommandMenu
extends Command

var commands : Array[Command]
var index : int
var origin : int
var is_selecting : bool

func _init(_name : String, _last : CommandMenu, _com : Array[Command]) -> void:
	super(_name, _last)
	commands = _com
	index = 0
	origin = 0
	is_selecting = false

func command_open(_user : Actor) -> void:
	if commands.size() == 0: return
	if commands[index] is CommandMenu:
		_user.set_command_menu(commands[index] as CommandMenu)
	else:
		command_close(_user)

func command_close(_user : Actor) -> void:
	_user.set_command_menu(last)

func command_use(_user : Actor, _state : InputState) -> void:
	if commands[index] is CommandMenu:
		_user.set_command_menu(commands[index] as CommandMenu)
	else:
		commands[index].command_use(_user, _state)

func menu_select(_user : Actor) -> void:
	last.menu_select(_user)

func command_use_release(_user : Actor, _state : InputState) -> void:
	if not commands[index] is CommandMenu:
		commands[index].command_use_release(_user, _state)

func command_use_holding(_user : Actor, _state : InputState) -> void:
	if not commands[index] is CommandMenu:
		commands[index].command_use_holding(_user, _state)

func command_up() -> void:
	if index >= commands.size() - 1:
		index = 0
		origin = 0
	else:
		index += 1
		if index - mini(4, commands.size() - 1) > origin:
			origin = index - mini(4, commands.size() - 1)
	game.command_update()

func command_down() -> void:
	if index <= 0:
		index = commands.size() - 1
		origin = commands.size() - 1 - mini(4, commands.size() - 1)
	else:
		index -= 1
		if index < origin:
			origin = index
	game.command_update()

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
