class_name MapMenu
extends CommandMenu

var tileset_menu : TilesetMenu
var tile_menu : TileMenu
var manager_menu : MapManagerMenu

func _init(_last : EditorWheel) -> void:
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
