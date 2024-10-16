class_name MapInstance
extends Resource

@export var tile_palette : TilePalette
@export var layers : Array[MapLayer]
@export var map_size : Vector3i

# Loading maps fails if the constructor has parameters
func _init() -> void:
	layers = []
	tile_palette = TilePalette.new()

func setup(
		_textures : Array[Image],
		_texture_names : Array[String],
		_res : int,
		_models : Array[Mesh],
		_model_names : Array[String]) -> void:
	tile_palette.setup(_textures, _texture_names, _res, _models, _model_names)
	clear_map()

func new_map() -> void:
	layers = []
	for x : int in range(map_size.x):
		layers.append(MapLayer.new())
		for y : int in range(map_size.y):
			layers[x].rows.append(MapRow.new())
			for z : int in range(map_size.z):
				layers[x].rows[y].tiles.append("")

func set_tile(name : String, pos : Vector3i) -> void:
	if pos.x < -map_size.x or pos.x > map_size.x: return
	if pos.y < -map_size.y or pos.y > map_size.y: return
	if pos.z < -map_size.z or pos.z > map_size.z: return
	layers[pos.x].rows[pos.y].tiles[pos.z] = name
	load_tile(name, pos)

func get_tile(pos : Vector3i) -> String:
	if pos.x < -map_size.x or pos.x >= map_size.x: return ""
	if pos.y < -map_size.y or pos.y >= map_size.y: return ""
	if pos.z < -map_size.z or pos.z >= map_size.z: return ""
	return layers[pos.x].rows[pos.y].tiles[pos.z]

func reload_map() -> void:
	var pos : Vector3i
	var tile : String
	for x : int in map_size.x:
		for y : int in map_size.y:
			for z : int in map_size.z:
				pos = Vector3i(x, y, z)
				tile = get_tile(pos)
				load_tile(tile, pos)

func get_atlas_texture() -> ImageTexture:
	return tile_palette.get_atlas_texture()

func get_mesher() -> VoxelMesherBlocky:
	return tile_palette.get_mesher()

func get_atlas_array() -> Texture2DArray:
	return tile_palette.get_atlas_array()

func get_resolution() -> int:
	return tile_palette.get_resolution()

func get_num_textures() -> int:
	return tile_palette.get_num_textures()

func get_textures() -> Array[Image]:
	return tile_palette.get_textures()

func get_texture_names() -> Array[String]:
	return tile_palette.get_texture_names()

func get_texture_index(name : String) -> int:
	return tile_palette.get_texture_index(name)

func get_texture_from_name(name : String) -> Image:
	return tile_palette.get_texture_from_name(name)

func get_texture_at_index(index : int) -> Image:
	return tile_palette.get_texture_at_index(index)

func get_texture_name(index : int) -> String:
	return tile_palette.get_texture_name(index)

func get_texture(voxel : int) -> String:
	return tile_palette.get_texture(voxel)

func get_shape(voxel : int) -> String:
	return tile_palette.get_shape(voxel)

func get_rot(voxel : int) -> int:
	return tile_palette.get_rot(voxel)

func get_skin(vox : int, texture : String) -> int:
	return tile_palette.get_skin(vox, texture)

func get_model(model : String, r : int, terrain : String) -> int:
	return tile_palette.get_model(model, r, terrain)

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

func save_tile(name : String, position : Vector3i) -> void:
	var slope_mesh : SlopeMesh = game.get_slope_mesh()
	var smooth_mesh : SmoothMesh = game.get_smooth_mesh()
	var model_mesh : ModelMesh = game.get_model_mesh()

	var slope_geo : TileGeo = TileGeo.new()
	var slope_tex : TileTex = TileTex.new()
	var smooth_geo : TileGeo = TileGeo.new()
	var smooth_tex : TileTex = TileTex.new()
	var model_vox : TileVox = TileVox.new()
	var pos : Vector3i
	var indices : Vector4i
	var col : Color
	var vox : int
	var geo : float
	var index : int
	var tex : String

	var p : Vector3i = position * tile_palette.tile_size

	for x : int in range(tile_palette.tile_size.x):
		slope_geo.layers.append(GeoLayer.new())
		slope_tex.w.append(TexLayer.new())
		slope_tex.x.append(TexLayer.new())
		slope_tex.y.append(TexLayer.new())
		slope_tex.z.append(TexLayer.new())
		slope_tex.col.append(ColLayer.new())
		smooth_geo.layers.append(GeoLayer.new())
		smooth_tex.w.append(TexLayer.new())
		smooth_tex.x.append(TexLayer.new())
		smooth_tex.y.append(TexLayer.new())
		smooth_tex.z.append(TexLayer.new())
		smooth_tex.col.append(ColLayer.new())
		model_vox.layers.append(VoxLayer.new())
		for y : int in range(tile_palette.tile_size.y):
			slope_geo.layers[x].rows.append(GeoRow.new())
			slope_tex.w[x].rows.append(TexRow.new())
			slope_tex.x[x].rows.append(TexRow.new())
			slope_tex.y[x].rows.append(TexRow.new())
			slope_tex.z[x].rows.append(TexRow.new())
			slope_tex.col[x].rows.append(ColRow.new())
			smooth_geo.layers[x].rows.append(GeoRow.new())
			smooth_tex.w[x].rows.append(TexRow.new())
			smooth_tex.x[x].rows.append(TexRow.new())
			smooth_tex.y[x].rows.append(TexRow.new())
			smooth_tex.z[x].rows.append(TexRow.new())
			smooth_tex.col[x].rows.append(ColRow.new())
			model_vox.layers[x].rows.append(VoxRow.new())
			for z : int in range(tile_palette.tile_size.z):
				pos = Vector3i(x, y, z) + p

				slope_mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
				geo = slope_mesh.tool.get_voxel_f(pos)
				slope_geo.layers[x].rows[y].geo.append(geo / 500.0)

				slope_mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
				index = slope_mesh.tool.get_voxel(pos)

				indices = VoxelTool.u16_indices_to_vec4i(index)
				tex = game.map.get_texture_name(indices.w)
				slope_tex.w[x].rows[y].tex.append(tex)
				tex = game.map.get_texture_name(indices.x)
				slope_tex.x[x].rows[y].tex.append(tex)
				tex = game.map.get_texture_name(indices.y)
				slope_tex.y[x].rows[y].tex.append(tex)
				tex = game.map.get_texture_name(indices.z)
				slope_tex.z[x].rows[y].tex.append(tex)

				slope_mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
				index = slope_mesh.tool.get_voxel(pos)
				col = VoxelTool.u16_weights_to_color(index)
				slope_tex.col[x].rows[y].col.append(col)

				smooth_mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
				geo = smooth_mesh.tool.get_voxel_f(pos)
				smooth_geo.layers[x].rows[y].geo.append(geo / 500.0)

				smooth_mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
				index = smooth_mesh.tool.get_voxel(pos)

				indices = VoxelTool.u16_indices_to_vec4i(index)
				tex = game.map.get_texture_name(indices.w)
				smooth_tex.w[x].rows[y].tex.append(tex)
				tex = game.map.get_texture_name(indices.x)
				smooth_tex.x[x].rows[y].tex.append(tex)
				tex = game.map.get_texture_name(indices.y)
				smooth_tex.y[x].rows[y].tex.append(tex)
				tex = game.map.get_texture_name(indices.z)
				smooth_tex.z[x].rows[y].tex.append(tex)

				smooth_mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
				index = smooth_mesh.tool.get_voxel(pos)
				col = VoxelTool.u16_weights_to_color(index)
				smooth_tex.col[x].rows[y].col.append(col)

				model_mesh.tool.channel = VoxelBuffer.CHANNEL_TYPE
				vox = model_mesh.tool.get_voxel(pos)
				model_vox.layers[x].rows[y].vox.append(vox)

	var tile : MapTile = MapTile.new()
	tile.slope_geo = slope_geo
	tile.slope_tex = slope_tex
	tile.smooth_geo = smooth_geo
	tile.smooth_tex = smooth_tex
	tile.model_vox = model_vox
	tile_palette.tiles[name] = tile

func load_tile(name : String, position : Vector3i) -> void:
	if not tile_palette.tiles.has(name): return
	var slope_mesh : SlopeMesh = game.get_slope_mesh()
	var smooth_mesh : SmoothMesh = game.get_smooth_mesh()
	var model_mesh : ModelMesh = game.get_model_mesh()

	var tile : MapTile = tile_palette.tiles[name]
	var geo : float
	var tex_w : String
	var tex_x : String
	var tex_y : String
	var tex_z : String
	var col : Color
	var vox : int
	var pos : Vector3i

	var p : Vector3i = position * tile_palette.tile_size

	for x : int in range(tile_palette.tile_size.x):
		for y : int in range(tile_palette.tile_size.y):
			for z : int in range(tile_palette.tile_size.z):
				pos = p + Vector3i(x, y, z)
				geo = tile.slope_geo.layers[x].rows[y].geo[z]
				tex_w = tile.slope_tex.w[x].rows[y].tex[z]
				tex_x = tile.slope_tex.x[x].rows[y].tex[z]
				tex_y = tile.slope_tex.y[x].rows[y].tex[z]
				tex_z = tile.slope_tex.z[x].rows[y].tex[z]
				col = tile.slope_tex.col[x].rows[y].col[z]

				slope_mesh.set_blend(pos, col)
				slope_mesh.set_tex(pos, tex_w, tex_x, tex_y, tex_z)
				slope_mesh.set_geo(pos, geo)

				geo = tile.smooth_geo.layers[x].rows[y].geo[z]
				tex_w = tile.smooth_tex.w[x].rows[y].tex[z]
				tex_x = tile.smooth_tex.x[x].rows[y].tex[z]
				tex_y = tile.smooth_tex.y[x].rows[y].tex[z]
				tex_z = tile.smooth_tex.z[x].rows[y].tex[z]
				col = tile.smooth_tex.col[x].rows[y].col[z]

				smooth_mesh.set_blend(pos, col)
				smooth_mesh.set_tex(pos, tex_w, tex_x, tex_y, tex_z)
				smooth_mesh.set_geo(pos, geo)

				vox = tile.model_vox.layers[x].rows[y].vox[z]
				model_mesh.set_voxel(pos, vox)

func duplicate_tile(from : String, to : String) -> void:
	var slope_geo : TileGeo = TileGeo.new()
	var slope_tex : TileTex = TileTex.new()
	var smooth_geo : TileGeo = TileGeo.new()
	var smooth_tex : TileTex = TileTex.new()
	var model_vox : TileVox = TileVox.new()
	var geo : float
	var tex : String
	var col : Color
	var vox : int

	for x : int in range(tile_palette.tile_size.x):
		slope_geo.layers.append(GeoLayer.new())
		slope_tex.w.append(TexLayer.new())
		slope_tex.x.append(TexLayer.new())
		slope_tex.y.append(TexLayer.new())
		slope_tex.z.append(TexLayer.new())
		slope_tex.col.append(ColLayer.new())
		smooth_geo.layers.append(GeoLayer.new())
		smooth_tex.w.append(TexLayer.new())
		smooth_tex.x.append(TexLayer.new())
		smooth_tex.y.append(TexLayer.new())
		smooth_tex.z.append(TexLayer.new())
		smooth_tex.col.append(ColLayer.new())
		model_vox.layers.append(VoxLayer.new())
		for y : int in range(tile_palette.tile_size.y):
			slope_geo.layers[x].rows.append(GeoRow.new())
			slope_tex.w[x].rows.append(TexRow.new())
			slope_tex.x[x].rows.append(TexRow.new())
			slope_tex.y[x].rows.append(TexRow.new())
			slope_tex.z[x].rows.append(TexRow.new())
			slope_tex.col[x].rows.append(ColRow.new())
			smooth_geo.layers[x].rows.append(GeoRow.new())
			smooth_tex.w[x].rows.append(TexRow.new())
			smooth_tex.x[x].rows.append(TexRow.new())
			smooth_tex.y[x].rows.append(TexRow.new())
			smooth_tex.z[x].rows.append(TexRow.new())
			smooth_tex.col[x].rows.append(ColRow.new())
			model_vox.layers[x].rows.append(VoxRow.new())
			for z : int in range(tile_palette.tile_size.z):
				geo = tile_palette.tiles[from].slope_geo.layers[x].rows[y].geo[z]
				slope_geo.layers[x].rows[y].geo.append(geo)
				tex = tile_palette.tiles[from].slope_tex.w[x].rows[y].tex[z]
				slope_tex.w[x].rows[y].tex.append(tex)
				tex = tile_palette.tiles[from].slope_tex.x[x].rows[y].tex[z]
				slope_tex.x[x].rows[y].tex.append(tex)
				tex = tile_palette.tiles[from].slope_tex.y[x].rows[y].tex[z]
				slope_tex.y[x].rows[y].tex.append(tex)
				tex = tile_palette.tiles[from].slope_tex.z[x].rows[y].tex[z]
				slope_tex.z[x].rows[y].tex.append(tex)
				col = tile_palette.tiles[from].slope_tex.col[x].rows[y].col[z]

				geo = tile_palette.tiles[from].smooth_geo.layers[x].rows[y].geo[z]
				smooth_geo.layers[x].rows[y].geo.append(geo)
				tex = tile_palette.tiles[from].smooth_tex.w[x].rows[y].tex[z]
				smooth_tex.w[x].rows[y].tex.append(tex)
				tex = tile_palette.tiles[from].smooth_tex.x[x].rows[y].tex[z]
				smooth_tex.x[x].rows[y].tex.append(tex)
				tex = tile_palette.tiles[from].smooth_tex.y[x].rows[y].tex[z]
				smooth_tex.y[x].rows[y].tex.append(tex)
				tex = tile_palette.tiles[from].smooth_tex.z[x].rows[y].tex[z]
				smooth_tex.z[x].rows[y].tex.append(tex)
				col = tile_palette.tiles[from].smooth_tex.col[x].rows[y].geo[z]
				smooth_tex.col[x].rows[y].col.append(tex)

				vox = tile_palette.tiles[from].model_vox[x][y][z]
				model_vox.layers[x].rows[y].vox.append(vox)
	var tile : MapTile = MapTile.new()
	tile.slope_geo = slope_geo
	tile.slope_tex = slope_tex
	tile.smooth_geo = smooth_geo
	tile.smooth_tex = smooth_tex
	tile.model_vox = model_vox
	tile_palette.tiles[to] = tile

func reskin(base : String, target : Array[String], brush : Array[String], weights : Array[float], name : String) -> void:
	duplicate_tile(base, name)
	var vox : int
	for x : int in range(tile_palette.tile_size.x):
		for y : int in range(tile_palette.tile_size.y):
			for z : int in range(tile_palette.tile_size.z):
				if tile_palette.tiles[name].smooth_tex[x][y][z].w == target[0]:
					tile_palette.tiles[name].smooth_tex[x][y][z].w = brush[0]
					tile_palette.tiles[name].smooth_tex[x][y][z].col.r = weights[0]
				if tile_palette.tiles[name].smooth_tex[x][y][z].x == target[1]:
					tile_palette.tiles[name].smooth_tex[x][y][z].x = brush[1]
					tile_palette.tiles[name].smooth_tex[x][y][z].col.g = weights[1]
				if tile_palette.tiles[name].smooth_tex[x][y][z].y == target[2]:
					tile_palette.tiles[name].smooth_tex[x][y][z].y = brush[2]
					tile_palette.tiles[name].smooth_tex[x][y][z].col.b = weights[2]
				if tile_palette.tiles[name].smooth_tex[x][y][z].z == target[3]:
					tile_palette.tiles[name].smooth_tex[x][y][z].z = brush[3]
					tile_palette.tiles[name].smooth_tex[x][y][z].col.a = weights[3]
				if tile_palette.tiles[name].slope_tex[x][y][z].w == target[0]:
					tile_palette.tiles[name].slope_tex[x][y][z].w = brush[0]
					tile_palette.tiles[name].slope_tex[x][y][z].col.r = weights[0]
				if tile_palette.tiles[name].slope_tex[x][y][z].x == target[1]:
					tile_palette.tiles[name].slope_tex[x][y][z].x = brush[1]
					tile_palette.tiles[name].slope_tex[x][y][z].col.g = weights[1]
				if tile_palette.tiles[name].slope_tex[x][y][z].y == target[2]:
					tile_palette.tiles[name].slope_tex[x][y][z].y = brush[2]
					tile_palette.tiles[name].slope_tex[x][y][z].col.b = weights[2]
				if tile_palette.tiles[name].slope_tex[x][y][z].z == target[3]:
					tile_palette.tiles[name].slope_tex[x][y][z].z = brush[3]
					tile_palette.tiles[name].slope_tex[x][y][z].col.a = weights[3]
				vox = tile_palette.tiles[name].model_vox[x][y][z]
				if vox <= 0: continue
				if get_texture(vox) == target[0]:
					vox = get_skin(vox, brush[0])
					tile_palette.tiles[name].model_vox[x][y][z] = vox
