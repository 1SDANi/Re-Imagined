class_name DetailMenu
extends CommandMenu

var weight_commands : Array[Command]

var rotation_commands : Array[Command]

var channels : Array[Command]

var rotation : int

func _init(_last : EditorMenu, i : int, r : float, g : float, b : float, a : float) -> void:
	category = "Detail"

	rotation_commands = []

	channels = []

	channels = [
		WeightMenu.new("Weight 1: ", r, self),
		WeightMenu.new("Weight 2: ", g, self),
		WeightMenu.new("Weight 3: ", b, self),
		WeightMenu.new("Weight 4: ", a, self)
	]

	weight_commands = [
		channels[0],
		channels[1],
		channels[2],
		channels[3],
	]

	for _rot : int in range(16):
		rotation_commands.append(RotationCommand.new(self, _rot))

	if (_last as EditorMenu).get_mode() in MapHandler.SOFT_MODES:
		commands = weight_commands
		super(weight_commands[index].name, _last, weight_commands)
	else:
		commands = rotation_commands
		super(rotation_commands[index].name, _last, rotation_commands)
		index = i

func get_weight(channel : int) -> float:
	return (channels as Array[WeightMenu])[channel].main

func menu_select(_user : Actor) -> void:
	rotation = index
	super(_user)

func update_commands() -> void:
	super()
	update_mode()
	update_name()

func update_name() -> void:
	rename(commands[index].name)

func update_mode() -> void:
	if (last as EditorMenu).get_mode() in MapHandler.SOFT_MODES:
		commands = weight_commands
	else:
		commands = rotation_commands
		index = rotation
