class_name TileRotMenu
extends CommandMenu

func _init(_last : TileMenu) -> void:
	category = "Rotation"
	var _commands : Array[Command] = \
	[
		TileRotCommand.new("North", self, 0),
		TileRotCommand.new("South", self, 1),
		TileRotCommand.new("East", self, 2),
		TileRotCommand.new("West", self, 3)
	]
	super("Rotation", _last, _commands)

func update_commands() -> void:
	update_name()
	super()

func update_name() -> void:
	rename(commands[index].name)
