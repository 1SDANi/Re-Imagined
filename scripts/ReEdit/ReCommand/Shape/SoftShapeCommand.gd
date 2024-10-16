class_name SoftShapeCommand
extends Command

var op : ValueMenu.OP
var adjust : float

func _init(_last : ShapeMenu, _op : ValueMenu.OP, _adjust : float) -> void:
	op = _op
	adjust = _adjust
	category = get_init_name(_last, _adjust, _op)
	super(get_init_name(_last, _adjust, _op), _last)

func command_select(_user : Actor, _state : InputState) -> void:
	command_use(_user, _state)

func command_use(_user : Actor, _state : InputState) -> void:
	(last as ValueMenu).calc(op, adjust)
	_user.set_command_menu((last as ShapeMenu))

func update_commands() -> void:
	rename(get_name())

func rename(_name : String) -> void:
	category = _name
	super(_name)

func get_name() -> String:
	return get_init_name((last as ShapeMenu), adjust, op)

func get_init_name(_last : ValueMenu, _adjust : float, _op : ValueMenu.OP) -> String:
	match(_op):
		ValueMenu.OP.ADD:
			return "Add " + str(_adjust) + " to " + str(_last.main)
		ValueMenu.OP.SUB:
			return "Subtract " + str(_adjust) + " from " + str(_last.main)
		ValueMenu.OP.SET:
			return "Set " + str(_last.main) + " to " + str(_adjust)
		_:
			return "ERROR"
