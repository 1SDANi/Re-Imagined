class_name TileAddBelowCommand
extends Command

func _init(_last : TileMenu) -> void:
	category = "Add Tile Below"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last.last as MapMenu).add_tile(false)
