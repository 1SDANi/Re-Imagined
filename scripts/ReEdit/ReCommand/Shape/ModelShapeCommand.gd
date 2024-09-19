class_name ModelShapeCommand
extends Command

var last : ShapeMenu
var model : String

func _init(_name : String, _last : ShapeMenu, _model : String) -> void:
	last = _last
	model = _model
	super(_name)

func command_use(_user : Actor) -> void:
	last.set_model_shape(model)
