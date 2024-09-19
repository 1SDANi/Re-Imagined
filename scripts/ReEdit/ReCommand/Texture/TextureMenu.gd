class_name TextureMenu
extends CommandMenu

var prefix : String
var channel : int

func _init(_l : TexturesMenu, _p : String, _s : String, _c : int, _e : EditorMenu) -> void:
	channel = _c
	prefix = _p
	var _commands : Array[Command] = []
	for tex_name : String in game.map.get_texture_names():
		_commands.append(TextureCommand.new(self, tex_name))
	super(_p + _s, _l, _commands)

func update_commands() -> void:
	rename(get_name())
	super()

func set_texture(texture : String) -> void:
	(last.last as EditorMenu).set_texture(channel, texture)

func get_name() -> String:
	return prefix + (last.last as EditorMenu).get_texture(channel)
