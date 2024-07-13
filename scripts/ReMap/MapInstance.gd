class_name MapInstance
extends Resource

@export var tile_palette : Dictionary
@export var tiles : Array
@export var tile_size : Vector3i
@export var map_size : Vector3i

func _init() -> void:
	tile_palette = {}
	tiles = []

func set_tile(name : String, pos : Vector3i) -> void:
	if pos.x < 0 or pos.x > map_size.x: return
	if pos.y < 0 or pos.y > map_size.y: return
	if pos.z < 0 or pos.z > map_size.z: return
	tiles[pos.x][pos.y][pos.z] = name
	load_tile(name, pos * tile_size, tile_size)

func get_tile(pos : Vector3i) -> String:
	if pos.x < 0 or pos.x >= map_size.x: return ""
	if pos.y < 0 or pos.y >= map_size.y: return ""
	if pos.z < 0 or pos.z >= map_size.z: return ""
	return tiles[pos.x][pos.y][pos.z]

func reload_map() -> void:
	var pos : Vector3i
	var tile : String
	for x : int in map_size.x:
		for y : int in map_size.y:
			for z : int in map_size.z:
				pos = Vector3i(x, y, z)
				tile = get_tile(pos)
				load_tile(tile, pos * tile_size, tile_size)

func clear_map() -> void:
	var slope_mesh : SlopeMesh = game.get_slope_mesh()
	var generator : VoxelGeneratorFlat = VoxelGeneratorFlat.new()
	generator.channel = VoxelBuffer.CHANNEL_TYPE
	generator.height = 1.0
	generator.voxel_type = 0
	slope_mesh.generator = generator
	var smooth_mesh : SmoothMesh = game.get_smooth_mesh()
	smooth_mesh.generator = generator
	var model_mesh : ModelMesh = game.get_model_mesh()
	model_mesh.generator = generator

func save_tile(name : String, position : Vector3i, size : Vector3i) -> void:
	var slope_mesh : SlopeMesh = game.get_slope_mesh()
	var smooth_mesh : SmoothMesh = game.get_smooth_mesh()
	var model_mesh : ModelMesh = game.get_model_mesh()

	var slope_geo : Array[Array] = []
	var slope_tex : Array[Array] = []
	var smooth_geo : Array[Array] = []
	var smooth_tex : Array[Array] = []
	var model_vox : Array[Array] = []
	var pos : Vector3i
	var geo : float
	var indices : int
	var index : int
	var tex : String

	for x : int in range(size.x):
		slope_geo.append([])
		slope_tex.append([])
		smooth_geo.append([])
		smooth_tex.append([])
		model_vox.append([])
		for y : int in range(size.y):
			((slope_geo[x]) as Array[float]).append([])
			((slope_tex[x]) as Array[float]).append([])
			((smooth_geo[x]) as Array[float]).append([])
			((smooth_tex[x]) as Array[float]).append([])
			((model_vox[x]) as Array[int]).append([])
			for z : int in range(size.z):
				pos = Vector3i(x + position.x, y + position.y, z + position.z)

				slope_mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
				geo = slope_mesh.tool.get_voxel_f(pos)
				slope_mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
				indices = slope_mesh.tool.get_voxel(pos)
				index = VoxelTool.u16_indices_to_vec4i(indices).x
				tex = slope_mesh.texture_names[index]
				((slope_geo[x] as Array[Array])[y] as Array[float]).append(geo)
				((slope_tex[x] as Array[Array])[y] as Array[float]).append(tex)

				smooth_mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
				geo = smooth_mesh.tool.get_voxel_f(pos)
				smooth_mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
				indices = smooth_mesh.tool.get_voxel(pos)
				index = VoxelTool.u16_indices_to_vec4i(indices).x
				tex = smooth_mesh.texture_names[index]
				((smooth_tex[x] as Array[Array])[y] as Array[float]).append(tex)
				((smooth_geo[x] as Array[Array])[y] as Array[float]).append(geo)

				smooth_mesh.tool.channel = VoxelBuffer.CHANNEL_TYPE
				geo = model_mesh.tool.get_voxel(pos)
				((model_vox[x] as Array[Array])[y] as Array[int]).append(geo)

	var tile : MapTile = MapTile.new()
	tile.slope_geo = slope_geo
	tile.slope_tex = slope_tex
	tile.smooth_geo = smooth_geo
	tile.smooth_tex = smooth_tex
	tile.model_vox = model_vox
	tile_palette[name] = tile

func load_tile(name : String, position : Vector3i, size : Vector3i) -> void:
	if not tile_palette.has(name): return
	var slope_mesh : SlopeMesh = game.get_slope_mesh()
	var smooth_mesh : SmoothMesh = game.get_smooth_mesh()
	var model_mesh : ModelMesh = game.get_model_mesh()

	var tile : MapTile
	var slope_geo : float
	var slope_tex : String
	var smooth_geo : float
	var smooth_tex : String
	var model_vox : int
	var pos : Vector3i

	for x : int in range(size.x):
		for y : int in range(size.y):
			for z : int in range(size.z):
				tile = tile_palette[name]
				pos = position + Vector3i(x, y, z)
				slope_geo = tile.slope_geo[x][y][z]
				slope_tex = tile.slope_tex[x][y][z]
				smooth_geo = tile.smooth_geo[x][y][z]
				smooth_tex = tile.smooth_tex[x][y][z]
				model_vox = tile.model_vox[x][y][z]

				slope_mesh.set_blend(pos, Color(1.0, 0.0, 0.0, 0.0))
				slope_mesh.set_tex(pos, slope_tex)
				slope_mesh.set_geo(pos, slope_geo)
				smooth_mesh.set_tex(pos, smooth_tex)
				smooth_mesh.set_geo(pos, smooth_geo)
				model_mesh.set_voxel(pos, model_vox)

func duplicate_tile(from : String, to : String) -> void:
	var slope_geo : Array[Array] = []
	var slope_tex : Array[Array] = []
	var smooth_geo : Array[Array] = []
	var smooth_tex : Array[Array] = []
	var model_vox : Array[Array] = []


	for x : int in range(tile_size.x):
		slope_geo.append([])
		slope_tex.append([])
		smooth_geo.append([])
		smooth_tex.append([])
		model_vox.append([])
		for y : int in range(tile_size.y):
			((slope_geo[x]) as Array[float]).append([])
			((slope_tex[x]) as Array[float]).append([])
			((smooth_geo[x]) as Array[float]).append([])
			((smooth_tex[x]) as Array[float]).append([])
			((model_vox[x]) as Array[int]).append([])
			for z : int in range(tile_size.z):
				var geo : float = tile_palette[from].smooth_geo[x][y][z]
				var tex : String = tile_palette[from].smooth_tex[x][y][z]
				((smooth_geo[x] as Array[Array])[y] as Array[float]).append(geo)
				((smooth_tex[x] as Array[Array])[y] as Array[float]).append(tex)
				geo = tile_palette[from].slope_geo[x][y][z]
				tex = tile_palette[from].slope_tex[x][y][z]
				((slope_geo[x] as Array[Array])[y] as Array[float]).append(geo)
				((slope_tex[x] as Array[Array])[y] as Array[float]).append(tex)
				var vox : int = tile_palette[from].model_vox[x][y][z]
				((model_vox[x] as Array[Array])[y] as Array[int]).append(vox)
	var tile : MapTile = MapTile.new()
	tile.slope_geo = slope_geo
	tile.slope_tex = slope_tex
	tile.smooth_geo = smooth_geo
	tile.smooth_tex = smooth_tex
	tile.model_vox = model_vox
	tile_palette[to] = tile

func reskin(mode : MapHandler.MODE, pos : Vector3i, tex : String, name : String) -> void:
	var mesh : VoxelMesh = game.get_mode_mesh()
	var pos_x : int = floori(float(pos.x) / float(tile_size.x))
	var pos_y : int = floori(float(pos.y) / float(tile_size.y))
	var pos_z : int = floori(float(pos.z) / float(tile_size.z))
	var vox : int = mesh.tool.get_voxel(pos)
	var tile : String = get_tile(Vector3i(pos_x, pos_y, pos_z))
	duplicate_tile(tile, name)
	if mode in MapHandler.SOFT_MODES:
		mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
		var indices : Vector4i = VoxelTool.u16_indices_to_vec4i(vox)
		var target : String = (mesh as SoftMesh).get_texture(indices)
		for x : int in range(tile_size.x):
			for y : int in range(tile_size.y):
				for z : int in range(tile_size.z):
					if mode == MapHandler.MODE.SMOOTH:
						if tile_palette[name].smooth_tex[x][y][z] == target:
							tile_palette[name].smooth_tex[x][y][z] = tex
					elif mode == MapHandler.MODE.SLOPE:
						if tile_palette[name].slope_tex[x][y][z] == target:
							tile_palette[name].slope_tex[x][y][z] = tex
	if mode == MapHandler.MODE.MODEL:
		mesh.tool.channel = VoxelBuffer.CHANNEL_TYPE
		var target : String = (mesh as ModelMesh).get_texture(vox)
		for x : int in range(tile_size.x):
			for y : int in range(tile_size.y):
				for z : int in range(tile_size.z):
					vox = tile_palette[name].model_vox[x][y][z]
					if  (mesh as ModelMesh).get_texture(vox) == target:
							vox = (mesh as ModelMesh).change_texture(vox, tex)
							tile_palette[name].model_vox[x][y][z] = vox
	reload_map()
