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

func update_tiles(_user: Actor) -> void:
	commands = []

	var editor : EditorMenu = (last.last.last as EditorWheel).editor
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var pos : Vector3i = game.map.get_pos(targeti)

	var tiles : MapStack = game.map.get_tile_stack(pos)
	for n : String in tiles.tiles:
		if n == "": continue
		commands.append(LayersSetCommand.new(n, self))

	if index >= commands.size():
		if commands.size() > 0:
			index = commands.size() - 1
		else:
			index = 0

	game.command_update()

func add_tile(_user: Actor, above : bool) -> void:
	if not (last.last as MapMenu).tileset_menu.tiles.commands.size() > 0: return
	var n : String = (last.last as MapMenu).tileset_menu.get_tile_name()
	var err : int = OK

	var editor : EditorMenu = (last.last.last as EditorWheel).editor
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var pos : Vector3i = game.map.get_pos(targeti)

	if commands.size() > 0:
		if above:
			err = commands.insert(index, LayersSetCommand.new(n, self))
			game.map.set_tile(n, pos, index)
		else:
			err = commands.insert(index + 1, LayersSetCommand.new(n, self))
			game.map.set_tile(n, pos, index + 1)
	else:
		commands.append(LayersSetCommand.new(n, self))
		game.map.set_tile(n, pos, 0)

	if err == OK:
		game.command_update()

func move_tile(_user : Actor, amount : int) -> void:
	if not (last.last as MapMenu).tileset_menu.tiles.commands.size() > 1: return
	var editor : EditorMenu = (last.last.last as EditorWheel).editor
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var pos : Vector3i = game.map.get_pos(targeti)

	var tar : int = index + amount
	if tar < 0:
		tar = commands.size() - 1
	elif tar >= commands.size():
		tar = 0
	var temp : Command = commands[index]
	commands[index] = commands[tar]
	commands[tar] = temp
	index = tar
	game.map.move_tile(pos, index, amount)
	game.command_update()

func reload_tile(_user : Actor) -> void:
	var editor : EditorMenu = (last.last.last as EditorWheel).editor
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var pos : Vector3i = game.map.get_pos(targeti)

	game.map.reload_at(pos)

func remove_tile(_user : Actor) -> void:
	if not (last.last as MapMenu).tileset_menu.tiles.commands.size() > 0: return
	if commands.size() == 0: return

	var editor : EditorMenu = (last.last.last as EditorWheel).editor
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var pos : Vector3i = game.map.get_pos(targeti)

	commands.remove_at(index)
	game.map.remove_tile(pos, index)
	if commands.size() == 0:
		index = 0
		command_close(_user)
	if index >= commands.size():
		index = commands.size() - 1
	game.command_update()
