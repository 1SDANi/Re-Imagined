class_name SaveLocationCommand
extends Command

func _init(_last : MapManagerMenu) -> void:
	category = "Save As"
	super("Save As", _last)

func rename(_name : String) -> void:
	name = _name

func command_use(_user : Actor, _state : InputState) -> void:
	var save_dialog : FileDialog = game.get_save_dialog()
	if save_dialog.file_selected.connect(set_save_location) == OK:
		if save_dialog.canceled.connect(end) == OK:
			game.input.set_action_mode(InputHandler.ACTION_MODE.POPUP)
			save_dialog.show()

func set_save_location(location : String) -> void:
	game.map.set_save_location(location)
	game.map.save_map()
	end()

func end() -> void:
	var save_dialog : FileDialog = game.get_save_dialog()
	game.input.set_action_mode(InputHandler.ACTION_MODE.WORLD)
	save_dialog.file_selected.disconnect(set_save_location)
	save_dialog.canceled.disconnect(end)
