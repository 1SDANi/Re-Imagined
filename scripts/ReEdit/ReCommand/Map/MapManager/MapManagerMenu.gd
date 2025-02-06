class_name MapManagerMenu
extends CommandMenu

func _init(_last : MapMenu) -> void:
	category = "Manager"
	var _commands : Array[Command] = \
	[
		SaveLocationCommand.new(self),
		SaveMapCommand.new(self),
		LoadMapCommand.new(self)
	]
	super(_commands[0].name, _last, _commands)

func update_commands() -> void:
	update_name()
	super()

func update_name() -> void:
	rename(commands[index].name)
