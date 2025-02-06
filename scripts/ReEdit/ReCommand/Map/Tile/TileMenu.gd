class_name TileMenu
extends CommandMenu

var layers : LayersMenu

func _init(_last : MapMenu) -> void:
	category = "Tile"

	layers = LayersMenu.new(self)

	var _commands : Array[Command] = \
	[
		layers,
		TileAddAboveCommand.new(self),
		TileAddBelowCommand.new(self),
		TileMoveUpCommand.new(self),
		TileMoveDownCommand.new(self),
		TileReloadCommand.new(self),
		TileRemoveCommand.new(self)
	]
	super(_commands[0].name, _last, _commands)

func update_commands() -> void:
	update_name()
	super()

func update_name() -> void:
	rename(commands[index].name)

func update_tiles(_user: Actor) -> void:
	layers.update_tiles(_user)

func add_tile(_user: Actor, above : bool) -> void:
	layers.add_tile(_user, above)

func move_tile(_user : Actor, amount : int) -> void:
	layers.move_tile(_user, amount)

func reload_tile(_user : Actor) -> void:
	layers.reload_tile(_user)

func remove_tile(_user : Actor) -> void:
	layers.remove_tile(_user)
