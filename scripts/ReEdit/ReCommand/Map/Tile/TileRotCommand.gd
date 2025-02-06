class_name TileRotCommand
extends Command

var rot : int

func _init(_name : String, _last : TileRotMenu, rotation : int) -> void:
	category = _name
	rot = rotation
	super(_name, _last)

func rename(_name : String) -> void:
	category = _name
	name = _name

func command_use(_user : Actor, _state : InputState) -> void:
	(last.last as TileMenu).set_tile_rotation(_user, rot)
