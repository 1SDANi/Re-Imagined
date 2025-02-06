class_name TileClearCommand
extends Command

func _init(_last : TileMenu) -> void:
	category = "Clear Tile"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last as TileMenu).clear_tile(_user)
