class_name TilesMenu
extends CommandMenu

func _init(_last : TilesetMenu) -> void:
	category = "Tiles"
	var _commands : Array[Command]
	super("Tiles", _last, _commands)

func update_commands() -> void:
	update_name()
	super()

func update_name() -> void:
	if commands.size() > 0:
		rename(commands[index].name)
	else:
		rename(category)

func get_tile_name() -> String:
	return commands[index].name

func add_tile(above : bool) -> void:
	game.input.set_action_mode(InputHandler.ACTION_MODE.POPUP)
	var ui : UIController = game.get_ui()
	var p : NamePopup = ui.add_temporary(ui.name_popup)
	if p.Cancel.pressed.connect(end.bind(p)) != OK:
		print("failed to connect cancel add tile")
	if p.Confirm.pressed.connect(confirm_add.bind(p, above)) != OK:
		print("failed to connect confirm add tile")

func remove_tile(_user : Actor) -> void:
	if commands.size() == 0: return
	commands.remove_at(index)
	if commands.size() == 0:
		index = 0
		command_close(_user)
	if index >= commands.size():
		index = commands.size() - 1
	game.command_update()

func move_tile(amount : int) -> void:
	var target : int = index + amount
	if target < 0:
		target = commands.size() - 1
	elif target >= commands.size():
		target = 0
	var temp : Command = commands[index]
	commands[index] = commands[target]
	commands[target] = temp
	index = target
	game.command_update()

func rename_tile() -> void:
	game.input.set_action_mode(InputHandler.ACTION_MODE.POPUP)
	var ui : UIController = game.get_ui()
	var p : NamePopup = ui.add_temporary(ui.name_popup)
	if p.Cancel.pressed.connect(self.end.bind(p)) != OK:
		print("failed to connect cancel rename tile")
	if p.Confirm.pressed.connect(self.confirm_rename.bind(p)) != OK:
		print("failed to connect confirm rename tile")

func end(p : NamePopup) -> void:
	p.queue_free()
	game.input.set_action_mode(InputHandler.ACTION_MODE.WORLD)

func confirm_add(p : NamePopup, above : bool) -> void:
	var err : int = OK
	if commands.size() > 0:
		if above:
			err = commands.insert(index, TilesetSetCommand.new(p.Name.text, self))
		else:
			err = commands.insert(index + 1, TilesetSetCommand.new(p.Name.text, self))
	else:
		commands.append(TilesetSetCommand.new(p.Name.text, self))

	if err == OK:
		game.command_update()

	end(p)

func confirm_rename(p : NamePopup) -> void:
	commands[index].rename(p.Name.text)
	game.command_update()
	end(p)
