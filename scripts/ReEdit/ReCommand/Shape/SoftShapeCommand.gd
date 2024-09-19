class_name SoftShapeCommand
extends Command

enum OP
{
	INC,
	DEC,
	SET
}

var last : ShapeMenu
var op : OP
var val : float

func _init(_last : ShapeMenu, _op : OP, _val : float, _name : String) -> void:
	last = _last
	op = _op
	val = _val
	super(_name)


