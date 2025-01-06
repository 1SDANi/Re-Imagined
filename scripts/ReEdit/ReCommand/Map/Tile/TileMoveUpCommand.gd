class_name TileMoveUpCommand
extends Command

func _init(_last : TileMenu) -> void:
	category = "Move Tile Up"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last.last as MapMenu).move_tile(-1)
