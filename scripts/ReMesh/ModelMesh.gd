extends HardMesh
class_name ModelMesh

@export var models : Array[Mesh]
@export var model_names : Array[String]

var meshes : Array[VoxelBlockyModelMesh]

var library : VoxelBlockyLibrary

func _ready() -> void:
	super()
	game.set_model_mesh(get_path())
	if generate_library:
		_new_meshes()
		_new_library()
		library.bake()
		if not ResourceSaver.save(library, "res://ModelLibrary.tres") == OK:
			print("failed to save model library")
		if not ResourceSaver.save(ImageTexture.create_from_image(atlas), "res://ModelAtlas.tres") == OK:
			print("failed to save model atlas")

func _new_meshes() -> void:
	meshes = []
	var size : int = floori(float(atlas.get_width() / float(res)))
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
	for uv : Vector2 in uvs:
		if not pack.append((uv + pos) / Vector2(atlas.get_size() / res)):
			pass
	verts[Mesh.ARRAY_TEX_UV] = pack
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, verts)

func _new_library() -> void:
	library = VoxelBlockyLibrary.new()
	var air : VoxelBlockyModelEmpty = VoxelBlockyModelEmpty.new()
	air.culls_neighbors = false
	if not library.add_model(air):
		pass
	var i : int = 0
	for mesh : VoxelBlockyModelMesh in meshes:
		if not library.add_model(mesh):
			pass
		i = i + 1
	mesher = VoxelMesherBlocky.new()
	(mesher as VoxelMesherBlocky).library = library

func get_model(model : String, r : int, terrain : String) -> int:
	if model == "air" or terrain == "air": return 0
	var m : int = model_names.find(model)
	var t : int = texture_names.find(terrain)
	return t * model_names.size() * 24 + m * 24 + r + 1

func change_texture(vox : int, texture : String) -> int:
	return get_model(get_shape(vox), get_rot(vox), texture)

func get_texture(voxel : int) -> String:
	if voxel == 0: return "air"
	return texture_names[floori((float(voxel - 1)) / float(model_names.size() * 24.0))]

func get_shape(voxel : int) -> String:
	if voxel == 0: return "air"
	return model_names[floori((voxel - 1) % model_names.size() / 24.0)]

func get_rot(voxel : int) -> int:
	if voxel == 0: return 0
	return (voxel - 1) % model_names.size() % 1
