class_name TexturesMenu
extends CommandMenu

var channels : Array[TextureMenu]

func _init(_last : EditorMenu, w : String, x : String, y : String, z : String) -> void:
	category = "Textures"

	channels = [
		TextureMenu.new(self, "Texture 1: ", w, 0),
		TextureMenu.new(self, "Texture 2: ", x, 1),
		TextureMenu.new(self, "Texture 3: ", y, 2),
		TextureMenu.new(self, "Texture 4: ", z, 3)
	]

	var _commands : Array[Command] = [
		channels[0],
		channels[1],
		channels[2],
		channels[3]
	]
	super(_commands[index].name, _last, _commands)

func texture_menu_select(_user : Actor, _texture : String, _old : String, channel : int) -> void:
	for i : int in range(4):
		if i == channel: continue
		if get_texture(i) == _texture: set_texture(i, _old)
	last.menu_select(_user)

func update_commands() -> void:
	super()
	rename(commands[index].name)

func get_texture(channel : int) -> String:
	return channels[channel].get_texture()

func set_texture(channel : int, texture : String) -> void:
	return channels[channel].set_texture(texture)
