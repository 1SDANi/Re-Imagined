class_name WeightCommand
extends Command

enum OP
{
	ADD,
	SUB,
	INC,
	DEC,
	SET
}

var last : WeightMenu
var op : OP
var val : float

func _init(_last : WeightMenu, _op : OP, _val : float) -> void:
	last = _last
	op = _op
	val = _val
	super(get_name())

func command_use(_user : Actor) -> void:
	last.calc(op, val)

func update_commands() -> void:
	rename(get_name())

func get_name() -> String:
	match(op):
		OP.ADD:
			return "Add " + str(last.val)
		OP.SUB:
			return "Subtract " + str(last.val)
		OP.INC:
			return "Increase " + str(last.val) + " by " + str(val)
		OP.DEC:
			return "Decrease " + str(last.val) + " by " + str(val)
		OP.SET:
			return "Set " + str(last.val) + " to " + str(val)
		_:
			return "ERROR"
