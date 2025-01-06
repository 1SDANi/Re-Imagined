class_name WeightMenu
extends ValueMenu

var prefix : String

func _init(_p : String, _w : float, _l : DetailMenu) -> void:
	main = _w
	prefix = _p
	category = _p + str(main)
	var _commands : Array[Command] = [ \
		WeightCommand.new(self, ValueMenu.OP.ADD, 0.1),
		WeightCommand.new(self, ValueMenu.OP.SUB, 0.1),
		WeightCommand.new(self, ValueMenu.OP.INC, 0.1),
		WeightCommand.new(self, ValueMenu.OP.DEC, 0.1),
		WeightCommand.new(self, ValueMenu.OP.SET, 0.0)
	]
	category = _commands[index].name
	super(_commands[index].name, _l, _commands)

func rename(_name : String) -> void:
	category = prefix + str(main)
	super(_name)
