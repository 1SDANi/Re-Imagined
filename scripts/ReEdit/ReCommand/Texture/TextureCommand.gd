class_name TextureCommand
extends Command

var last : TextureMenu
var texture : String

func _init(_last : TextureMenu, _texture : String) -> void:
	last = _last
	texture = _texture
	super(_texture)

func command_use(_user : Actor) -> void:
	last.set_texture(texture)
