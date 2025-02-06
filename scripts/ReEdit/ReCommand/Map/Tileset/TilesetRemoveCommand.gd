class_name TilesetRemoveCommand
extends Command

func _init(_last : TilesetMenu) -> void:
	category = "Remove Tile"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last as TilesetMenu).remove_tile(_user)
