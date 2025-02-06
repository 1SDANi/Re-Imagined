class_name TilePalette
extends Resource

@export var resolution : int

@export var textures : Array[Image]
@export var texture_names : Array[String]

@export var models : Array[Mesh]
@export var model_names : Array[String]

@export var tiles : Dictionary[String,PaletteTile]
@export var tile_size : Vector3i

@export var meshes : Array[VoxelBlockyModelMesh]

@export var atlas : Image
@export var atlas_texture : ImageTexture
@export var mesher : VoxelMesherBlocky
@export var atlas_array : Texture2DArray

# Loading maps fails if the constructor has parameters
func _init() -> void:
	tiles = {}

func get_atlas_texture() -> ImageTexture:
	return atlas_texture

func get_atlas_array() -> Texture2DArray:
	return atlas_array

func get_mesher() -> VoxelMesherBlocky:
	return mesher

func get_resolution() -> int:
	return resolution

func get_num_textures() -> int:
	return textures.size()

func get_textures() -> Array[Image]:
	return textures

func get_texture_names() -> Array[String]:
	return texture_names

func get_texture_index(name : String) -> int:
	return texture_names.find(name)

func get_texture_from_name(name : String) -> Image:
	return textures[get_texture_index(name)]

func get_texture_at_index(index : int) -> Image:
	return textures[index]

func get_texture_name(index : int) -> String:
	return texture_names[index]

func get_texture(voxel : int) -> String:
	if voxel == 0: return "air"
	return game.map.get_texture_name(floori((float(voxel - 1)) / float(model_names.size() * 24.0)))

func get_shape(voxel : int) -> String:
	if voxel == 0: return "air"
	return model_names[floori((voxel - 1) % model_names.size() / 24.0)]

func get_rot(voxel : int) -> int:
	if voxel == 0: return 0
	return (voxel - 1) % model_names.size() % 1

func get_skin(vox : int, texture : String) -> int:
	return get_model(get_shape(vox), get_rot(vox), texture)

func get_model(model : String, r : int, terrain : String) -> int:
	if model == "air" or terrain == "air": return 0
	var m : int = model_names.find(model)
	var t : int = game.map.get_texture_index(terrain)
	return t * model_names.size() * 24 + m * 24 + r + 1

func setup(
		_textures : Array[Image],
		_texture_names : Array[String],
		_res : int,
		_models : Array[Mesh],
		_model_names : Array[String]) -> void:
	_new_atlas(_textures, _texture_names, _res)
	_new_meshes(_models, _model_names)
	_new_library()


func _new_atlas(t : Array[Image], n : Array[String], r : int) -> void:
	textures = t
	texture_names = n
	resolution = r

	var size : Vector2i = Vector2i(textures.size(), 1)
	size *= resolution
	atlas = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)

	var pos : int = 0
	for tex : Image in textures: pos = _add_tex(pos, tex)
	if not atlas.save_png("res://atlas.png") == OK:
		print("failed to save atlas")
	atlas_texture = ImageTexture.create_from_image(atlas)
	if not ResourceSaver.save(atlas_texture, "res://atlas_texture.tres") == OK:
		print("failed to save atlas texture")
	atlas_array = Texture2DArray.new()
	if atlas_array.create_from_images(textures):
		print("failed to create atlas array")
	if not ResourceSaver.save(atlas_array, "res://atlas_array.tres") == OK:
		print("failed to save atlas array")
	else:
		game.atlas_update()

func _add_tex(pos : int, tex : Image) -> int:
	var rect : Rect2i = Rect2i(0, 0, tex.get_width(), tex.get_height())
	atlas.blit_rect(tex, rect, Vector2i(pos, 0))
	return pos + resolution

func _new_meshes(m : Array[Mesh], n : Array[String]) -> void:
	models = m
	model_names = n
	meshes = []
	var size : int = floori(float(atlas.get_width() / float(resolution)))
	for pos : int in size: for model : Mesh in models: _add_mesh(model, pos)

func _add_mesh(model : Mesh, pos : int) -> void:
	for i : int in range(24):
		var mesh: VoxelBlockyModelMesh = VoxelBlockyModelMesh.new()
		mesh.mesh = _uv_setup(model, Vector2i(pos, 0))
		match (i):
			0:
				mesh.mesh_ortho_rotation_index = 0
			1:
				mesh.mesh_ortho_rotation_index = 16
			2:
				mesh.mesh_ortho_rotation_index = 10
			3:
				mesh.mesh_ortho_rotation_index = 22
			4:
				mesh.mesh_ortho_rotation_index = 4
			5:
				mesh.mesh_ortho_rotation_index = 5
			6:
				mesh.mesh_ortho_rotation_index = 6
			7:
				mesh.mesh_ortho_rotation_index = 7
			8:
				mesh.mesh_ortho_rotation_index = 8
			9:
				mesh.mesh_ortho_rotation_index = 20
			10:
				mesh.mesh_ortho_rotation_index = 2
			11:
				mesh.mesh_ortho_rotation_index = 18
			12:
				mesh.mesh_ortho_rotation_index = 12
			13:
				mesh.mesh_ortho_rotation_index = 15
			14:
				mesh.mesh_ortho_rotation_index = 14
			15:
				mesh.mesh_ortho_rotation_index = 13
			16:
				mesh.mesh_ortho_rotation_index = 1
			17:
				mesh.mesh_ortho_rotation_index = 17
			18:
				mesh.mesh_ortho_rotation_index = 11
			19:
				mesh.mesh_ortho_rotation_index = 23
			20:
				mesh.mesh_ortho_rotation_index = 3
			21:
				mesh.mesh_ortho_rotation_index = 19
			22:
				mesh.mesh_ortho_rotation_index = 9
			23:
				mesh.mesh_ortho_rotation_index = 21
		meshes.append(mesh)

func _uv_setup(model : Mesh, pos: Vector2) -> ArrayMesh:
	var mesh : ArrayMesh = ArrayMesh.new()
	var i : int = model.get_surface_count() - 1
	while i > -1: _add_uvs(model.surface_get_arrays(i), pos, mesh); i -= 1
	return mesh

func _add_uvs(verts : Array, pos : Vector2, mesh : ArrayMesh) -> void:
	var uvs : PackedVector2Array = verts[Mesh.ARRAY_TEX_UV]
	var pack : PackedVector2Array = PackedVector2Array()
	var p : Vector2
	for uv : Vector2 in uvs:
		p = (uv + pos) / Vector2(atlas.get_size() / float(resolution))
		if pack.append(p):
			print("failed to add uv")
	verts[Mesh.ARRAY_TEX_UV] = pack
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, verts)

func _new_library() -> void:
	mesher = VoxelMesherBlocky.new()
	mesher.library = VoxelBlockyLibrary.new()
	var air : VoxelBlockyModelEmpty = VoxelBlockyModelEmpty.new()
	air.culls_neighbors = false
	if (mesher.library as VoxelBlockyLibrary).add_model(air):
		print("failed to add model")
	var i : int = 0
	for mesh : VoxelBlockyModelMesh in meshes:
		if not (mesher.library as VoxelBlockyLibrary).add_model(mesh):
			print("failed to add model")
		i = i + 1
	mesher.library.bake()
	if not ResourceSaver.save(mesher.library, "res://ModelLibrary.tres") == OK:
		print("failed to save model library")
