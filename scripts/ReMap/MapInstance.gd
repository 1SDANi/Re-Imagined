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
				layers[x].rows[y].stacks.append(MapStack.new())
				layers[x].rows[y].stacks[0].tiles.append(MapTile.new())

func set_tile(name : String, pos : Vector3i, priority : int, rot : int) -> void:
	if pos.x < -map_size.x or pos.x > map_size.x: return
	if pos.y < -map_size.y or pos.y > map_size.y: return
	if pos.z < -map_size.z or pos.z > map_size.z: return
	var e : int = OK
	var tile : MapTile = MapTile.new()
	tile.palette_tile = name
	tile.rotation = rot
	if priority > layers[pos.x].rows[pos.y].stacks[pos.z].tiles.size():
		layers[pos.x].rows[pos.y].stacks[pos.z].tiles.append(tile)
	elif priority < 0:
		layers[pos.x].rows[pos.y].stacks[pos.z].tiles.push_front(tile)
	else:
		e = layers[pos.x].rows[pos.y].stacks[pos.z].tiles.insert(priority, tile)

	if e == OK:
		reload_at(pos)

func set_tile_rotation(pos : Vector3i, priority : int, rot : int) -> void:
	layers[pos.x].rows[pos.y].stacks[pos.z].tiles[priority].rotation = rot
	reload_at(pos)

func move_tile(pos : Vector3i, priority : int, amount : int) -> void:
	var target : int = priority + amount
	var size : int = layers[pos.x].rows[pos.y].stacks[pos.z].tiles.size() - 1
	if target < 0:
		target = size
	elif target > size:
		target = 0
	var temp1 : MapTile = layers[pos.x].rows[pos.y].stacks[pos.z].tiles[priority]
	var temp2 : MapTile = layers[pos.x].rows[pos.y].stacks[pos.z].tiles[target]
	layers[pos.x].rows[pos.y].stacks[pos.z].tiles[priority] = temp2
	layers[pos.x].rows[pos.y].stacks[pos.z].tiles[target] = temp1
	reload_at(pos)
	game.command_update()

func remove_tile(pos : Vector3i, priority : int) -> void:
	if pos.x < -map_size.x or pos.x > map_size.x: return
	if pos.y < -map_size.y or pos.y > map_size.y: return
	if pos.z < -map_size.z or pos.z > map_size.z: return
	layers[pos.x].rows[pos.y].stacks[pos.z].tiles.remove_at(priority)
	reload_at(pos)
	game.command_update()

func remove_tile_from_tileset(name : String) -> bool:
	return tile_palette.tiles.erase(name)

func get_tile(pos : Vector3i, priority : int) -> String:
	if pos.x < -map_size.x or pos.x >= map_size.x: return ""
	if pos.y < -map_size.y or pos.y >= map_size.y: return ""
	if pos.z < -map_size.z or pos.z >= map_size.z: return ""
	return layers[pos.x].rows[pos.y].stacks[pos.z].tiles[priority].palette_tile

func get_tile_rotation(pos : Vector3i, priority : int) -> int:
	if pos.x < -map_size.x or pos.x >= map_size.x: return -1
	if pos.y < -map_size.y or pos.y >= map_size.y: return -1
	if pos.z < -map_size.z or pos.z >= map_size.z: return -1
	return layers[pos.x].rows[pos.y].stacks[pos.z].tiles[priority].rotation

func get_tile_stack(pos : Vector3i) -> MapStack:
	if pos.x < -map_size.x or pos.x >= map_size.x: return MapStack.new()
	if pos.y < -map_size.y or pos.y >= map_size.y: return MapStack.new()
	if pos.z < -map_size.z or pos.z >= map_size.z: return MapStack.new()
	return layers[pos.x].rows[pos.y].stacks[pos.z]

func reload_map() -> void:
	for x : int in map_size.x:
		for y : int in map_size.y:
			for z : int in map_size.z:
				reload_at(Vector3i(x, y, z))

func reload_at(pos : Vector3i) -> void:
	for i : int in range(layers[pos.x].rows[pos.y].stacks[pos.z].tiles.size()):
		load_tile(get_tile(pos, i), pos, get_tile_rotation(pos, i))

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

func pack_tile(position : Vector3i, fill : bool, fill_palette : VoxelPalette) -> PaletteTile:
	return pack(position * tile_palette.tile_size, tile_palette.tile_size, fill, fill_palette)

func pack(position : Vector3i, size : Vector3i, fill : bool, fill_palette : VoxelPalette) -> PaletteTile:
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

	for x : int in range(size.x):
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
		for y : int in range(size.y):
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
			for z : int in range(size.z):
				pos = Vector3i(x, y, z) + position

				slope_mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
				geo = slope_mesh.tool.get_voxel_f(pos)
				slope_geo.layers[x].rows[y].geo.append(geo)

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
				smooth_geo.layers[x].rows[y].geo.append(geo)

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

				smooth_mesh.tool.channel = VoxelBuffer.CHANNEL_WEIGHTS
				index = smooth_mesh.tool.get_voxel(pos)
				col = VoxelTool.u16_weights_to_color(index)
				smooth_tex.col[x].rows[y].col.append(col)

				model_mesh.tool.channel = VoxelBuffer.CHANNEL_TYPE
				vox = model_mesh.tool.get_voxel(pos)
				model_vox.layers[x].rows[y].vox.append(vox)

	var tile : PaletteTile = PaletteTile.new()
	tile.slope_geo = slope_geo
	tile.slope_tex = slope_tex
	tile.smooth_geo = smooth_geo
	tile.smooth_tex = smooth_tex
	tile.model_vox = model_vox
	tile.size = size
	tile.fill = fill
	tile.fill_palette = fill_palette
	return tile

func save_tile(name : String, position : Vector3i, fill : bool, fill_palette : VoxelPalette) -> void:
	tile_palette.tiles[name] = pack_tile(position, fill, fill_palette)

func unpack_tile(position : Vector3i, tile : PaletteTile, rotation : int) -> void:
	unpack(position * tile_palette.tile_size, tile, rotation)

func unpack(position : Vector3i, tile : PaletteTile, rotation : int) -> void:
	var slope_mesh : SlopeMesh = game.get_slope_mesh()
	var smooth_mesh : SmoothMesh = game.get_smooth_mesh()
	var model_mesh : ModelMesh = game.get_model_mesh()

	var geo : float
	var tex_w : String
	var tex_x : String
	var tex_y : String
	var tex_z : String
	var col : Color
	var vox : int
	var pos : Vector3i

	var _x : int
	var _y : int
	var _z : int

	var aabb : AABB = AABB(position, tile.size)

	game.move_edit_viewer(position as Vector3)

	while not slope_mesh.tool.is_area_editable(aabb):
		await game.get_tree().process_frame

	print("slope editable")

	while not smooth_mesh.tool.is_area_editable(aabb):
		await game.get_tree().process_frame

	print("smooth editable")

	while not model_mesh.tool.is_area_editable(aabb):
		await game.get_tree().process_frame

	print("model editable")

	for x : int in range(tile.size.x):
		for y : int in range(tile.size.y):
			for z : int in range(tile.size.z):
				match rotation:
					0:
						_x = x
						_y = y
						_z = z
					1:
						_x = tile.size.x-1-x
						_y = y
						_z = tile.size.z-1-z
					2:
						_x = tile.size.x-1-x
						_y = y
						_z = z
					3:
						_x = x
						_y = y
						_z = tile.size.z-1-z

				pos = position + Vector3i(_x, _y, _z)
				geo = tile.slope_geo.layers[x].rows[y].geo[z]

				col = tile.slope_tex.col[x].rows[y].col[z]
				if not (is_equal_approx(col.r, 0.0) and \
						is_equal_approx(col.g, 0.0) and \
						is_equal_approx(col.b, 0.0) and \
						is_equal_approx(col.a, 0.0)):
					tex_w = tile.slope_tex.w[x].rows[y].tex[z]
					tex_x = tile.slope_tex.x[x].rows[y].tex[z]
					tex_y = tile.slope_tex.y[x].rows[y].tex[z]
					tex_z = tile.slope_tex.z[x].rows[y].tex[z]

					slope_mesh.set_blend(pos, col)
					slope_mesh.set_tex(pos, tex_w, tex_x, tex_y, tex_z)
				elif tile.fill:
					tex_w = tile.fill_palette.slope_w
					tex_x = tile.fill_palette.slope_x
					tex_y = tile.fill_palette.slope_y
					tex_z = tile.fill_palette.slope_z

					slope_mesh.set_blend(pos, tile.fill_palette.slope_col)
					slope_mesh.set_tex(pos, tex_x, tex_y, tex_z, tex_w)

				if not is_equal_approx(geo, 500.0):
					slope_mesh.set_geo(pos, geo)
				elif tile.fill:
					slope_mesh.set_geo(pos, tile.fill_palette.slope_geo)

				geo = tile.smooth_geo.layers[x].rows[y].geo[z]

				col = tile.smooth_tex.col[x].rows[y].col[z]
				if not (is_equal_approx(col.r, 0.0) and \
						is_equal_approx(col.g, 0.0) and \
						is_equal_approx(col.b, 0.0) and \
						is_equal_approx(col.a, 0.0)):
					tex_w = tile.smooth_tex.w[x].rows[y].tex[z]
					tex_x = tile.smooth_tex.x[x].rows[y].tex[z]
					tex_y = tile.smooth_tex.y[x].rows[y].tex[z]
					tex_z = tile.smooth_tex.z[x].rows[y].tex[z]

					smooth_mesh.set_blend(pos, col)
					smooth_mesh.set_tex(pos, tex_x, tex_y, tex_z, tex_w)
				elif tile.fill:
					tex_w = tile.fill_palette.smooth_w
					tex_x = tile.fill_palette.smooth_x
					tex_y = tile.fill_palette.smooth_y
					tex_z = tile.fill_palette.smooth_z

					smooth_mesh.set_blend(pos, tile.fill_palette.smooth_col)
					smooth_mesh.set_tex(pos, tex_w, tex_x, tex_y, tex_z)

				if not is_equal_approx(geo, 500.0):
					smooth_mesh.set_geo(pos, geo)
				elif tile.fill:
					smooth_mesh.set_geo(pos, tile.fill_palette.smooth_geo)

				vox = tile.model_vox.layers[x].rows[y].vox[z]
				if vox != 0:
					model_mesh.set_voxel(pos, vox)
				elif tile.fill:
					model_mesh.set_voxel(pos, tile.fill_palette.model)

func clear_tile(position : Vector3i) -> void:
	clear(position * tile_palette.tile_size, tile_palette.tile_size)

func clear(position : Vector3i, size : Vector3i) -> void:
	var slope_mesh : SlopeMesh = game.get_slope_mesh()
	var smooth_mesh : SmoothMesh = game.get_smooth_mesh()
	var model_mesh : ModelMesh = game.get_model_mesh()
	var pos : Vector3i
	for x : int in range(size.x):
		for y : int in range(size.y):
			for z : int in range(size.z):
				pos = position + Vector3i(x, y, z)
				slope_mesh.remove_geo(pos)
				smooth_mesh.remove_geo(pos)
				model_mesh.remove_voxel(pos)

func load_tile(name : String, position : Vector3i, rotation : int) -> void:
	if not tile_palette.tiles.has(name): return
	unpack_tile(position, tile_palette.tiles[name] as PaletteTile, rotation)

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
				col = tile_palette.tiles[from].smooth_tex.col[x].rows[y].col[z]
				smooth_tex.col[x].rows[y].col.append(tex)

				vox = tile_palette.tiles[from].model_vox.layers[x].rows[y].vox[z]
				model_vox.layers[x].rows[y].vox.append(vox)
	var tile : PaletteTile = PaletteTile.new()
	tile.slope_geo = slope_geo
	tile.slope_tex = slope_tex
	tile.smooth_geo = smooth_geo
	tile.smooth_tex = smooth_tex
	tile.model_vox = model_vox
	tile.model_vox = model_vox

	tile.fill_palette = VoxelPalette.new()
	tile.fill_palette.slope_w = tile_palette.tiles[from].fill_palette.slope_w
	tile.fill_palette.slope_x = tile_palette.tiles[from].fill_palette.slope_x
	tile.fill_palette.slope_y = tile_palette.tiles[from].fill_palette.slope_y
	tile.fill_palette.slope_z = tile_palette.tiles[from].fill_palette.slope_z
	tile.fill_palette.slope_col= tile_palette.tiles[from].fill_palette.slope_col
	tile.fill_palette.slope_geo= tile_palette.tiles[from].fill_palette.slope_geo
	tile.fill_palette.smooth_w = tile_palette.tiles[from].fill_palette.smooth_w
	tile.fill_palette.smooth_x = tile_palette.tiles[from].fill_palette.smooth_x
	tile.fill_palette.smooth_y = tile_palette.tiles[from].fill_palette.smooth_y
	tile.fill_palette.smooth_z = tile_palette.tiles[from].fill_palette.smooth_z
	tile.fill_palette.smooth_col= tile_palette.tiles[from].fill_palette.smooth_col
	tile.fill_palette.smooth_geo= tile_palette.tiles[from].fill_palette.smooth_geo
	tile.fill_palette.model = tile_palette.tiles[from].fill_palette.model

	tile_palette.tiles[to] = tile
