class_name TextureMenu
extends CommandMenu

var prefix : String
var channel : int
var old : String

func _init(_l : TexturesMenu, _p : String, _s : String, _c : int) -> void:
	prefix = _p
	channel = _c
	var _commands : Array[Command] = []
	for tex_name : String in game.map.get_texture_names():
		_commands.append(TextureCommand.new(self, tex_name))
	category = _commands[_c].name
	super(_p + _commands[_c].name, _l, _commands)
	index = game.map.map.get_texture_index(_s)
	old = _s

func command_open(_user : Actor) -> void:
	if commands[index] is CommandMenu:
		_user.set_command_menu(commands[index] as CommandMenu)
	else:
		(commands as Array[TextureCommand])[index].texture_menu_select(_user)

func texture_menu_select(_user : Actor, _texture : String) -> void:
	(last as TexturesMenu).texture_menu_select(_user, _texture, old, channel)
	old = _texture

func get_texture() -> String:
	return commands[index].name

func set_texture(texture : String) -> void:
	for i : int in range(commands.size()):
		if commands[i].name == texture:
			index = i
			return

func update_name() -> void:
	rename(prefix + commands[index].name)

func update_commands() -> void:
	super()
	update_name()

func rename(_name : String) -> void:
	category = _name
	super(_name)
