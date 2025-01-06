class_name TileAddAboveCommand
extends Command

func _init(_last : TileMenu) -> void:
	category = "Add Tile Above"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last.last as MapMenu).add_tile(true)
