class_name WeightMenu
extends CommandMenu

var channel : int
var val : float

var prefix : String

func _init(_p : String, _w : float, _l : WeightsMenu, _c : int) -> void:
	channel = _c
	val = 0.0
	var _commands : Array[Command] = [ \
		WeightCommand.new(self, WeightCommand.OP.ADD, 0.1),
		WeightCommand.new(self, WeightCommand.OP.SUB, 0.1),
		WeightCommand.new(self, WeightCommand.OP.INC, 0.1),
		WeightCommand.new(self, WeightCommand.OP.DEC, 0.1),
		WeightCommand.new(self, WeightCommand.OP.SET, 0.0)
	]
	prefix = _p
	super(_p + str(_w), _l, _commands)

func calc(op : WeightCommand.OP, _val : float) -> void:
	match(op):
		WeightCommand.OP.ADD:
			(last.last as EditorMenu).add_weight(channel, val)
		WeightCommand.OP.SUB:
			(last.last as EditorMenu).sub_weight(channel, val)
		WeightCommand.OP.INC:
			val += _val
		WeightCommand.OP.DEC:
			val -= _val
		WeightCommand.OP.SET:
			(last.last as EditorMenu).set_weight(channel, val)
	(last.last as EditorMenu).update_commands()

func update_commands() -> void:
	rename(get_name())
	super()

func get_name() -> String:
	return prefix + str((last.last as EditorMenu).get_weight(channel))
