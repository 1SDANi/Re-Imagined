class_name TileSaveCommand
extends Command

func _init(_last : TileMenu) -> void:
	category = "Save Tile"
	super(category, _last)

func command_use(_user : Actor, _state : InputState) -> void:
	var mesh : VoxelMesh = game.get_mode_mesh(MapHandler.MODE.SMOOTH)
	var target : Vector3 = mesh.to_local(_user.position) + Vector3.DOWN / 2
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var n : String = (last.last as MapMenu).get_tile_name()
	game.map.save_tile(n, game.map.get_pos(targeti), false, VoxelPalette.new())
