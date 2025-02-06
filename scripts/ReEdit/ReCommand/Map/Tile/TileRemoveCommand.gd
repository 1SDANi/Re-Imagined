class_name TileRemoveCommand
extends Command

func _init(_last : TileMenu) -> void:
	category = "Remove Tile"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last as TileMenu).remove_tile(_user)
