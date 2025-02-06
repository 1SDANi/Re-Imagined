class_name TileReloadCommand
extends Command

func _init(_last : TileMenu) -> void:
	category = "Reload Tile"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last as TileMenu).reload_tile(_user)
