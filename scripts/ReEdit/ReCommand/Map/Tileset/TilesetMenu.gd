class_name TilesetMenu
extends CommandMenu

var tiles : TilesMenu

func _init(_last : MapMenu) -> void:
	category = "Tileset"

	tiles = TilesMenu.new(self)

	var _commands : Array[Command] = \
	[
		tiles,
		TilesetAddAboveCommand.new(self),
		TilesetAddBelowCommand.new(self),
		TilesetMoveUpCommand.new(self),
		TilesetMoveDownCommand.new(self),
		TilesetRemoveCommand.new(self),
		TilesetSaveCommand.new(self)
	]
	super(_commands[0].name, _last, _commands)

func update_commands() -> void:
	update_name()
	super()

func load_tileset(tileset : TilePalette) -> void:
	tiles.commands = []
	for tile : String in tileset.tiles:
		tiles.commands.append(TilesetSetCommand.new(tile, tiles))
		game.command_update()

func update_name() -> void:
	rename(commands[index].name)

func get_tile_name() -> String:
	return tiles.get_tile_name()

func add_tile(above : bool) -> void:
	tiles.add_tile(above)

func remove_tile(_user : Actor) -> void:
	if game.map.remove_tile_from_tileset(tiles.commands[tiles.index].name):
		tiles.remove_tile(_user)

func rename_tile() -> void:
	tiles.rename_tile()

func move_tile(amount : int) -> void:
	tiles.move_tile(amount)
