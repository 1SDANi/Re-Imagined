class_name TileMenu
extends CommandMenu

var layers : LayersMenu
var rots : TileRotMenu

func _init(_last : MapMenu) -> void:
	category = "Tile"

	layers = LayersMenu.new(self)
	rots = TileRotMenu.new(self)

	var _commands : Array[Command] = \
	[
		layers,
		rots,
		TileAddAboveCommand.new(self),
		TileAddBelowCommand.new(self),
		TileMoveUpCommand.new(self),
		TileMoveDownCommand.new(self),
		TileClearCommand.new(self),
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
	var editor : EditorMenu = (last.last.last as EditorWheel).editor
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var pos : Vector3i = game.map.get_pos(targeti)

	layers.update_tiles(_user, pos)

func add_tile(_user: Actor, above : bool) -> void:
	if layers.add_tile(_user, above):
		var n : String = (last as MapMenu).tileset_menu.get_tile_name()

		var editor : EditorMenu = (last.last as EditorWheel).editor
		var mode : MapHandler.MODE = editor.get_mode()
		var mesh : VoxelMesh = game.get_mode_mesh(mode)
		var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
		if target.x < 0.0: target.x -= 1.0
		if target.y < 0.0: target.y -= 1.0
		if target.z < 0.0: target.z -= 1.0
		var targeti : Vector3i = target + Vector3.DOWN / 2
		var pos : Vector3i = game.map.get_pos(targeti)

		if layers.commands.size() > 0:
			if above:
				game.map.set_tile(n, pos, layers.index, 0)
			else:
				game.map.set_tile(n, pos, layers.index + 1, 0)
		else:
			game.map.set_tile(n, pos, 0, 0)

		game.command_update()

func move_tile(_user : Actor, amount : int) -> void:
	if layers.move_tile(_user, amount):
		var editor : EditorMenu = (last.last as EditorWheel).editor
		var mode : MapHandler.MODE = editor.get_mode()
		var mesh : VoxelMesh = game.get_mode_mesh(mode)
		var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
		if target.x < 0.0: target.x -= 1.0
		if target.y < 0.0: target.y -= 1.0
		if target.z < 0.0: target.z -= 1.0
		var targeti : Vector3i = target + Vector3.DOWN / 2
		var pos : Vector3i = game.map.get_pos(targeti)

		game.map.move_tile(pos, layers.index, amount)

		game.command_update()

func reload_tile(_user : Actor) -> void:
	var editor : EditorMenu = (last.last as EditorWheel).editor
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var pos : Vector3i = game.map.get_pos(targeti)

	game.map.reload_at(pos)

	game.command_update()

func remove_tile(_user : Actor) -> void:
	var editor : EditorMenu = (last.last as EditorWheel).editor
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var pos : Vector3i = game.map.get_pos(targeti)

	game.map.remove_tile(pos, layers.index)

	if layers.remove_tile(_user):
		game.command_update()

func clear_tile(_user : Actor) -> void:
	var editor : EditorMenu = (last.last as EditorWheel).editor
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var pos : Vector3i = game.map.get_pos(targeti)

	game.map.clear_tile(pos)

func set_tile_rotation(_user : Actor, rotation : int) -> void:
	var editor : EditorMenu = (last.last as EditorWheel).editor
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var pos : Vector3i = game.map.get_pos(targeti)

	game.map.set_tile_rotation(pos, layers.index, rotation)
