class_name TilesetRenameCommand
extends Command

func _init(_last : TilesetMenu) -> void:
	category = "Rename Tile"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last as TilesetMenu).rename_tile()
