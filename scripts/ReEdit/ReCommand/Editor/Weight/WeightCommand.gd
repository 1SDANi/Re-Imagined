class_name WeightCommand
extends Command

var op : ValueMenu.OP
var val : float

func _init(_last : WeightMenu, _op : ValueMenu.OP, _val : float) -> void:
	category = get_init_name(_last, _val)
	op = _op
	val = _val
	super(get_init_name(_last, _val), _last)

func command_use(_user : Actor, _state : InputState) -> void:
	(last as WeightMenu).calc(op, val)

func command_select(_user : Actor, _state : InputState) -> void:
	command_use(_user, _state)

func update_commands() -> void:
	rename(get_name())

func rename(_name : String) -> void:
	category = _name
	super(_name)

func get_name() -> String:
	var _last : DetailMenu = (last as WeightMenu).last
	return get_init_name(last as WeightMenu, val)

func get_init_name(_last : WeightMenu, _val : float) -> String:
	match(op):
		ValueMenu.OP.ADD:
			return "Add " + str(_last.minor) + " to " + str(_last.main)
		ValueMenu.OP.SUB:
			return "Subtract " + str(_last.minor) + " from " + str(_last.main)
		ValueMenu.OP.INC:
			return "Increase " + str(_last.minor) + " by " + str(_val)
		ValueMenu.OP.DEC:
			return "Decrease " + str(_last.minor) + " by " + str(_val)
		ValueMenu.OP.SET:
			return "Set " + str(_last.minor) + " to " + str(_val)
		_:
			return "ERROR"
