class_name ShapeMenu
extends CommandMenu

var smooth_shape : float
var slope_shape : float

var mode_commands : Array[Array]

func _init(_last : EditorMenu) -> void:
	mode_commands = [[],[],[]]
	var _command : Command

	var slope_commands : Array[Command] = [
		SlopeShapeCommand.new(self, SoftShapeCommand.OP.INC, 0.1, _last),
		SlopeShapeCommand.new(self, SoftShapeCommand.OP.DEC, 0.1, _last),
		SlopeShapeCommand.new(self, SoftShapeCommand.OP.SET, 1.0, _last),
		SlopeShapeCommand.new(self, SoftShapeCommand.OP.SET, 0.0, _last),
		SlopeShapeCommand.new(self, SoftShapeCommand.OP.SET, -1.0, _last)
	]

	mode_commands[MapHandler.MODE.SLOPE] = slope_commands

	var smooth_commands : Array[Command] = [
		SmoothShapeCommand.new(self, SoftShapeCommand.OP.INC, 0.1, _last),
		SmoothShapeCommand.new(self, SoftShapeCommand.OP.DEC, 0.1, _last),
		SmoothShapeCommand.new(self, SoftShapeCommand.OP.SET, 1.0, _last),
		SmoothShapeCommand.new(self, SoftShapeCommand.OP.SET, 0.0, _last),
		SmoothShapeCommand.new(self, SoftShapeCommand.OP.SET, -1.0, _last)
	]

	mode_commands[MapHandler.MODE.SMOOTH] = smooth_commands

	var model_commands : Array[Command] = []

	for _name : String in game.map.map.tile_palette.model_names:
		_command = ModelShapeCommand.new(_name, self, _name)
		model_commands.append(_command)

	mode_commands[MapHandler.MODE.MODEL] = model_commands

	super("Shape", _last, mode_commands[_last.mode])

func update_commands() -> void:
	commands = (mode_commands[(last as EditorMenu).mode] as Array[Command])
	super()

func set_model_shape(_model : String) -> void:
	(last as EditorMenu).set_model_shape(_model)

func calc_slope(op : SoftShapeCommand.OP, _val : float) -> void:
	match(op):
		SoftShapeCommand.OP.INC:
			(last as EditorMenu).add_slope_value(_val)
		SoftShapeCommand.OP.DEC:
			(last as EditorMenu).sub_slope_value(_val)
		SoftShapeCommand.OP.SET:
			(last as EditorMenu).set_slope_value(_val)

func calc_smooth(op : SoftShapeCommand.OP, _val : float) -> void:
	match(op):
		SoftShapeCommand.OP.INC:
			(last as EditorMenu).add_smooth_value(_val)
		SoftShapeCommand.OP.DEC:
			(last as EditorMenu).sub_smooth_value(_val)
		SoftShapeCommand.OP.SET:
			(last as EditorMenu).set_smooth_value(_val)
