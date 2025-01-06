class_name MapMenu
extends CommandMenu

var tileset_menu : TilesetMenu
var tile_menu : TileMenu
var manager_menu : MapManagerMenu

func _init(_last : CommandMenu) -> void:
	category = "Map"

	tileset_menu = TilesetMenu.new(self)
	tile_menu = TileMenu.new(self)
	manager_menu = MapManagerMenu.new(self)

	var _commands : Array[Command] = \
	[
		tileset_menu,
		tile_menu,
		manager_menu
	]

	super("Map", _last, _commands)

func get_tile_name() -> String:
	return tileset_menu.get_tile_name()

func add_tile(above : bool) -> void:
	return tileset_menu.add_tile(above)

func remove_tile(_user : Actor) -> void:
	return tileset_menu.remove_tile(_user)

func rename_tile() -> void:
	return tileset_menu.rename_tile()

func move_tile(amount : int) -> void:
	return tileset_menu.move_tile(amount)
