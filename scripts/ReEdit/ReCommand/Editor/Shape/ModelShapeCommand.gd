class_name ModelShapeCommand
extends Command

var model : String

func _init(_name : String, _last : ShapeMenu, _model : String) -> void:
	model = _model
	category = _name
	super(_name, _last)
