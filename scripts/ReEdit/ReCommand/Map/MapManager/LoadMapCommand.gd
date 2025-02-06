class_name LoadMapCommand
extends Command

func _init(_last : MapManagerMenu) -> void:
	category = "Load Map"
	super("Load Map", _last)

func command_use(_user : Actor, _state : InputState) -> void:
	var load_dialog : FileDialog = game.get_load_dialog()
	if load_dialog.file_selected.connect(set_save_location) == OK:
		if load_dialog.canceled.connect(end) == OK:
			game.input.set_action_mode(InputHandler.ACTION_MODE.POPUP)
			load_dialog.show()

func set_save_location(location : String) -> void:
	game.map.set_save_location(location)
	game.map.load_map()
	var tiles : TilePalette = game.map.map.tile_palette
	((last as MapManagerMenu).last as MapMenu).tileset_menu.load_tileset(tiles)
	end()

func end() -> void:
	var load_dialog : FileDialog = game.get_load_dialog()
	game.input.set_action_mode(InputHandler.ACTION_MODE.WORLD)
	load_dialog.file_selected.disconnect(set_save_location)
	load_dialog.canceled.disconnect(end)
