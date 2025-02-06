class_name SaveMapCommand
extends Command

func _init(_last : MapManagerMenu) -> void:
	category = "Save Map"
	super("Save Map", _last)

func command_use(_user : Actor, _state : InputState) -> void:
	game.map.save_map()
