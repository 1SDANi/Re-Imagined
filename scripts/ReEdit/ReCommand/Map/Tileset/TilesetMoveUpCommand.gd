class_name TilesetMoveUpCommand
extends Command

func _init(_last : TilesetMenu) -> void:
	category = "Move Tile Up"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last as TilesetMenu).move_tile(-1)
