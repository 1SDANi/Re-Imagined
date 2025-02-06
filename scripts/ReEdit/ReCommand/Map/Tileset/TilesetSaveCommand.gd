class_name TilesetSaveCommand
extends Command

func _init(_last : TilesetMenu) -> void:
	category = "Save Tile"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	var mesh : VoxelMesh = game.get_mode_mesh(MapHandler.MODE.SMOOTH)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var n : String = (last as TilesetMenu).get_tile_name()

	game.input.set_action_mode(InputHandler.ACTION_MODE.POPUP)
	var ui : UIController = game.get_ui()
	var p : NotificationPopup = ui.add_temporary(ui.notification_popup)
	p.Notification.text = "Saved"
	if p.Dismiss.pressed.connect(end.bind(p)) != OK:
		print("failed to connect cancel add tile")

	game.map.save_tile(n, game.map.get_pos(targeti), false, VoxelPalette.new())

func end(p : NotificationPopup) -> void:
	p.queue_free()
	game.input.set_action_mode(InputHandler.ACTION_MODE.WORLD)
