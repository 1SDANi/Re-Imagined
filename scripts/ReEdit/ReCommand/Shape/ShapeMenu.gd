class_name ShapeMenu
extends ValueMenu

var soft_commands : Array[Command]
var hard_commands : Array[Command]

var model : int

func _init(_last : EditorMenu, _initial_model : String) -> void:
	category = "Shape"
	var _command : Command

	soft_commands = [
		SoftShapeCommand.new(self, OP.ADD, 0.10),
		SoftShapeCommand.new(self, OP.ADD, 0.01),
		SoftShapeCommand.new(self, OP.SUB, 0.10),
		SoftShapeCommand.new(self, OP.SUB, 0.01),
		SoftShapeCommand.new(self, OP.SET, 0.0)
	]

	hard_commands = []

	for _name : String in game.map.map.tile_palette.model_names:
		_command = ModelShapeCommand.new(_name, self, _name)
		hard_commands.append(_command)

	if (_last as EditorMenu).get_mode() in MapHandler.SOFT_MODES:
		commands = soft_commands
		super(soft_commands[index].name, _last, soft_commands)
	else:
		commands = hard_commands
		super(hard_commands[index].name, _last, hard_commands)
		index = game.map.map.tile_palette.get_texture_index(_initial_model)

func get_model() -> String:
	return game.map.map.tile_palette.model_names[model]

func menu_select(_user : Actor) -> void:
	model = index
	super(_user)

func update_commands() -> void:
	update_mode()
	update_name()
	super()

func update_mode() -> void:
	if (last as EditorMenu).get_mode() in MapHandler.SOFT_MODES:
		commands = soft_commands
	else:
		commands = hard_commands
		index = model

func update_name() -> void:
	rename(commands[index].name)

func calc_set(_adjust : float) -> void:
	if _adjust > 500:
		main = 500
	elif _adjust < -500:
		main = -500
	else:
		super(_adjust)

func calc_add(_adjust : float) -> void:
	calc_set(main + _adjust)

func calc_sub(_adjust : float) -> void:
	calc_set(main - _adjust)
