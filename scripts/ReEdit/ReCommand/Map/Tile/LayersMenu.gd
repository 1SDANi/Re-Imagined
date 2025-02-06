class_name LayersMenu
extends CommandMenu

func _init(_last : TileMenu) -> void:
	category = "Layers"
	var _commands : Array[Command]
	super("Layers", _last, _commands)

func update_commands() -> void:
	update_name()
	super()

func update_name() -> void:
	if commands.size() > 0:
		rename(commands[index].name)
	else:
		rename(category)

func get_layer_name() -> String:
	return commands[index].name

func update_tiles(_user: Actor, pos : Vector3i) -> void:
	commands = []

	var tiles : MapStack = game.map.get_tile_stack(pos)
	for n : MapTile in tiles.tiles:
		if n.palette_tile == "": continue
		commands.append(LayersSetCommand.new(n.palette_tile, self))

	if index >= commands.size():
		if commands.size() > 0:
			index = commands.size() - 1
		else:
			index = 0

	game.command_update()

func add_tile(_user: Actor, above : bool) -> bool:
	if not (last.last as MapMenu).tileset_menu.tiles.commands.size() > 0: return false
	var n : String = (last.last as MapMenu).tileset_menu.get_tile_name()
	var err : int = OK

	if commands.size() > 0:
		if above:
			err = commands.insert(index, LayersSetCommand.new(n, self))
		else:
			err = commands.insert(index + 1, LayersSetCommand.new(n, self))
	else:
		commands.append(LayersSetCommand.new(n, self))

	return err == OK

func move_tile(_user : Actor, amount : int) -> bool:
	if not (last.last as MapMenu).tileset_menu.tiles.commands.size() > 1: return false

	var tar : int = index + amount
	if tar < 0:
		tar = commands.size() - 1
	elif tar >= commands.size():
		tar = 0
	var temp : Command = commands[index]
	commands[index] = commands[tar]
	commands[tar] = temp
	index = tar

	return true

func remove_tile(_user : Actor) -> bool:
	if not (last.last as MapMenu).tileset_menu.tiles.commands.size() > 0: return false
	if commands.size() == 0: return false

	commands.remove_at(index)
	if commands.size() == 0:
		index = 0
		command_close(_user)
	if index >= commands.size():
		index = commands.size() - 1

	return true
