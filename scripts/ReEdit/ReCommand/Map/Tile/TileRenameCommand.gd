class_name TileRenameCommand
extends Command

func _init(_last : TileMenu) -> void:
	category = "Rename Tile"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last.last as MapMenu).rename_tile()
