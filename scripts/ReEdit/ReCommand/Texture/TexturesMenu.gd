class_name TexturesMenu
extends CommandMenu

func _init(_last : EditorMenu, _palette : EditorPalette) -> void:
	var _commands : Array[Command] = [
		TextureMenu.new(self, "Texture 1: ", _palette.w, 0, _last),
		TextureMenu.new(self, "Texture 2: ", _palette.x, 1, _last),
		TextureMenu.new(self, "Texture 3: ", _palette.y, 2, _last),
		TextureMenu.new(self, "Texture 4: ", _palette.z, 3, _last)
	]
	super("Textures", _last, _commands)
