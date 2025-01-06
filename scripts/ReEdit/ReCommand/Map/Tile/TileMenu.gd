class_name TileMenu
extends CommandMenu

func _init(_last : MapMenu) -> void:
	category = "Tile"
	var _commands : Array[Command] = \
	[
		TileAddAboveCommand.new(self),
		TileAddBelowCommand.new(self),
		TileMoveUpCommand.new(self),
		TileMoveDownCommand.new(self),
		TileRenameCommand.new(self),
		TileRemoveCommand.new(self),
		TileSaveCommand.new(self)
	]
	super(_commands[0].name, _last, _commands)

func update_commands() -> void:
	update_name()
	super()

func update_name() -> void:
	rename(commands[index].name)
