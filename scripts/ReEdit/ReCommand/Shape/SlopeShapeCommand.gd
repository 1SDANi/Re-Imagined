class_name SlopeShapeCommand
extends SoftShapeCommand

func _init(_last : ShapeMenu, _op : OP, _val : float, _e : EditorMenu) -> void:
	super(_last, _op, _val, get_init_name(_e, _val, _op))

func command_use(_user : Actor) -> void:
	last.calc_slope(op, val)

func update_commands() -> void:
	rename(get_name())

func get_init_name(_e : EditorMenu, _val : float, _op : OP) -> String:
	match(_op):
		OP.INC:
			return "Add " + str(_val) + " to " + str(_e.palette.slope_value)
		OP.DEC:
			return "Subtract " + str(_val) + " to " + str(_e.palette.slope_value)
		OP.SET:
			return "Set " + str(_e.palette.slope_value) + " to " + str(_val)
		_:
			return "ERROR"

func get_name() -> String:
	var editor : EditorMenu = last.last
	match(op):
		OP.INC:
			return "Add " + str(val) + " to " + str(editor.palette.slope_value)
		OP.DEC:
			return "Subtract " + str(val) + " to " + str(editor.palette.slope_value)
		OP.SET:
			return "Set " + str(editor.palette.slope_value) + " to " + str(val)
		_:
			return "ERROR"
