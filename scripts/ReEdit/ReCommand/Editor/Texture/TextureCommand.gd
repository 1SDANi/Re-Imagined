class_name TextureCommand
extends Command

var texture : String

func _init(_last : TextureMenu, _texture : String) -> void:
	texture = _texture
	category = _texture
	super(_texture, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	command_select(_user, _state)

func texture_menu_select(_user : Actor) -> void:
	(last as TextureMenu).texture_menu_select(_user, texture)
