class_name TilesetAddAboveCommand
extends Command

func _init(_last : TilesetMenu) -> void:
	category = "Add Tile Above"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last as TilesetMenu).add_tile(true)
