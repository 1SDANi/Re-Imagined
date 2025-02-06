class_name LayersSetCommand
extends Command

func _init(_name : String, _last : LayersMenu) -> void:
	category = _name
	super(_name, _last)

func rename(_name : String) -> void:
	category = _name
	name = _name
