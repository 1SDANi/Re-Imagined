class_name TilesetSetCommand
extends Command

func _init(_name : String, _last : TilesetMenu) -> void:
	category = _name
	super(_name, _last)

func rename(_name : String) -> void:
	category = _name
	name = _name