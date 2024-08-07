extends VoxelTerrain
class_name SlopeMeshOld

const NNN : int = 1 << 0
const ZNN : int = 1 << 1
const PNN : int = 1 << 2
const NZN : int = 1 << 3
const ZZN : int = 1 << 4
const PZN : int = 1 << 5
const NPN : int = 1 << 6
const ZPN : int = 1 << 7
const PPN : int = 1 << 8
const NNZ : int = 1 << 9
const ZNZ : int = 1 << 10
const PNZ : int = 1 << 11
const NZZ : int = 1 << 12
const ZZZ : int = 1 << 13
const PZZ : int = 1 << 14
const NPZ : int = 1 << 15
const ZPZ : int = 1 << 16
const PPZ : int = 1 << 17
const NNP : int = 1 << 18
const ZNP : int = 1 << 19
const PNP : int = 1 << 20
const NZP : int = 1 << 21
const ZZP : int = 1 << 22
const PZP : int = 1 << 23
const NPP : int = 1 << 24
const ZPP : int = 1 << 25
const PPP : int = 1 << 26

var tool : VoxelTool

@export var primaries : Array[String]
@export var secondaries : Array[String]

@export var textures : Array[Image]
@export var texture_names : Array[String]
@export var res : int

@export var models : Array[Mesh]
@export var model_names : Array[String]

var atlas : Image

var meshes : Array[VoxelBlockyModelMesh]

var library : VoxelBlockyLibrary

@export var generate_library : bool = false
@export var save_library : bool = false

func _ready() -> void:
	game.set_slope_mesh(get_path())
	game.map.primary = primaries[0]
	game.map.secondary = secondaries[secondaries.size() - 1]
	tool = get_voxel_tool()
	if generate_library:
		_new_atlas()
		_new_meshes()
		_new_library()
		_set_albedo(ImageTexture.create_from_image(atlas))
		library.bake()
	if save_library:
		ResourceSaver.save(library, "res://library.tres")
		ResourceSaver.save(ImageTexture.create_from_image(atlas), "res://atlas.tres")

func set_voxel(pos : Vector3i, texture : String, model : String, rot : int):
	tool.set_voxel(pos, _get_model(model, rot, texture))

func get_texture(voxel : int) -> String:
	if voxel == 0: return "air"
	return texture_names[floori((float(voxel - 1)) / float(model_names.size() * 24.0))]

func get_shape(voxel : int) -> String:
	if voxel == 0: return "air"
	return model_names[floori((voxel - 1) % model_names.size() / 24.0)]

func get_rot(voxel : int) -> int:
	if voxel == 0: return 0
	return (voxel - 1) % model_names.size() % 1

func _set_albedo(t : Texture2D):
	material_override.set_texture(BaseMaterial3D.TextureParam.TEXTURE_ALBEDO, t)

func _new_atlas() -> void:
	var size : Vector2i = Vector2i(textures.size(), 1) * res
	atlas = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)

	var pos : int = 0
	for tex in textures: pos = _add_tex(pos, tex)

func _add_tex(pos : int, tex : Image) -> int:
	var rect : Rect2i = Rect2i(0, 0, tex.get_width(), tex.get_height())
	atlas.blit_rect(tex, rect, Vector2i(pos, 0))
	return pos + res

func _new_meshes() -> void:
	meshes = []
	var size : int = floori(float(atlas.get_width() / float(res)))
	for pos in size: for model in models: _add_mesh(model, pos)

func _add_mesh(model : Mesh, pos : int) -> void:
	for i in range(24):
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
	var mesh = ArrayMesh.new()
	var i : int = model.get_surface_count() - 1
	while i > -1: _add_uvs(model.surface_get_arrays(i), pos, mesh); i -= 1
	return mesh

func _add_uvs(verts : Array, pos : Vector2, mesh : ArrayMesh):
	var uvs = verts[Mesh.ARRAY_TEX_UV]
	var pack = PackedVector2Array()
	for uv in uvs: pack.append((uv + pos) / Vector2(atlas.get_size() / res))
	verts[Mesh.ARRAY_TEX_UV] = pack
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, verts)

func _new_library():
	library = VoxelBlockyLibrary.new()
	var air : VoxelBlockyModelEmpty = VoxelBlockyModelEmpty.new()
	air.culls_neighbors = false
	library.add_model(air)
	for mesh in meshes: library.add_model(mesh)
	mesher = VoxelMesherBlocky.new()
	mesher.library = library

func _get_model(model : String, r : int, terrain : String) -> int:
	if model == "air" or terrain == "air": return 0
	var m : int = model_names.find(model)
	var t : int = texture_names.find(terrain)
	return t * model_names.size() * 24 + m * 24 + r + 1

func _change_model(p : Vector3i, m : String, r : int):
	var i : int = tool.get_voxel(p)
	if i > 65000: i = 0
	tool.set_voxel(p, _get_model(m, r, get_texture(i)))

func place(pos : Vector3i, terrain : String, shapeable : bool) -> void:
	tool.channel = VoxelBuffer.CHANNEL_TYPE
	var voxel : int = tool.get_voxel(pos)

	if voxel <= 0:
		tool.set_voxel(pos, _get_model("hardblock", 0, terrain))
		tool.set_voxel_metadata(pos, Metadata.new(shapeable))
	else:
		tool.set_voxel(pos, _get_model("air", 0, terrain))

	shapes(pos)

func shapes(pos : Vector3i) -> void:
	for x in range(-1,2):
		for y in range(-1,2):
			for z in range(-1,2):
				shape(pos + Vector3i(x, y, z))

func shape(pos : Vector3i) -> void:
	tool.channel = VoxelBuffer.CHANNEL_TYPE
	var voxel : int = tool.get_voxel(pos)
	var data : Variant = tool.get_voxel_metadata(pos)
	if data and not data.shapeable: return
	var mask : int = 0
	for x in range(-1,2):
		for y in range(-1,2):
			for z in range(-1,2):
				var magic : int = (z + 2) + (y * 3 + 2) + (x * 9 + 2) + 7
				var check : Vector3i = pos + Vector3i(x, y, z)
				mask |= int(tool.get_voxel(check) > 0) << magic

	if voxel > 0:
		var zzp : bool = mask & ZZP > 0
		var pzz : bool = mask & PZZ > 0
		var zzn : bool = mask & ZZN > 0
		var nzz : bool = mask & NZZ > 0
		var znz : bool = mask & ZNZ > 0
		var zpz : bool = mask & ZPZ > 0
		var pzp : bool = mask & PZP > 0
		var pzn : bool = mask & PZN > 0
		var nzp : bool = mask & NZP > 0
		var nzn : bool = mask & NZN > 0

		if zzp and zzn and pzz and nzz and pzp and pzn and nzp and nzn:
			_change_model(pos, "hardblock", 0)
		elif znz and not zpz:
			top_shape(pos, mask)
		elif not znz and not zpz:
			side_shape(pos, mask)
		elif znz and zpz:
			middle_shape(pos, mask)
		elif not znz and zpz:
			bottom_shape(pos, mask)
		else:
			_change_model(pos, "hardblock", 0)

func side_shape(pos : Vector3i, mask : int):
	var zzp : bool = mask & ZZP > 0
	var pzz : bool = mask & PZZ > 0
	var zzn : bool = mask & ZZN > 0
	var nzz : bool = mask & NZZ > 0
	var pzp : bool = mask & PZP > 0
	var pzn : bool = mask & PZN > 0
	var nzp : bool = mask & NZP > 0
	var nzn : bool = mask & NZN > 0

	if zzp and pzz and zzn and nzz and pzn and pzp and nzp:
		_change_model(pos, "hardheartforkhang", 0)
	elif zzp and pzz and zzn and nzz and nzn and pzn and pzp:
		_change_model(pos, "hardheartforkhang", 1)
	elif zzp and pzz and zzn and nzz and nzp and nzn and pzn:
		_change_model(pos, "hardheartforkhang", 2)
	elif zzp and pzz and zzn and nzz and pzp and nzp and nzn:
		_change_model(pos, "hardheartforkhang", 3)
	elif zzp and pzz and zzn and nzz and pzn and pzp:
		_change_model(pos, "hardmaceforkhang", 0)
	elif zzp and pzz and zzn and nzz and nzn and pzn:
		_change_model(pos, "hardmaceforkhang", 1)
	elif zzp and pzz and zzn and nzz and nzp and nzn:
		_change_model(pos, "hardmaceforkhang", 2)
	elif zzp and pzz and zzn and nzz and pzp and nzp:
		_change_model(pos, "hardmaceforkhang", 3)
	elif zzp and pzz and zzn and nzz and pzn and nzp:
		_change_model(pos, "hardbowforkhang", 0)
	elif zzp and pzz and zzn and nzz and nzn and pzp:
		_change_model(pos, "hardbowforkhang", 1)
	elif zzp and pzz and zzn and nzz and pzn:
		_change_model(pos, "hardfishforkhang", 0)
	elif zzp and pzz and zzn and nzz and nzn:
		_change_model(pos, "hardfishforkhang", 1)
	elif zzp and pzz and zzn and nzz and nzp:
		_change_model(pos, "hardfishforkhang", 2)
	elif zzp and pzz and zzn and nzz and pzp:
		_change_model(pos, "hardfishforkhang", 3)
	elif zzp and pzz and zzn and nzz:
		_change_model(pos, "hardxforkhang", 0)
	elif zzp and pzz and zzn and pzp and pzn:
		_change_model(pos, "hardslopehang", 0)
	elif pzz and zzn and nzz and pzn and nzn:
		_change_model(pos, "hardslopehang", 1)
	elif zzp and zzn and nzz and nzp and nzn:
		_change_model(pos, "hardslopehang", 2)
	elif zzp and pzz and nzz and pzp and nzp:
		_change_model(pos, "hardslopehang", 3)
	elif zzp and pzz and zzn and pzp:
		_change_model(pos, "hardpforkhang", 0)
	elif pzz and zzn and nzz and pzn:
		_change_model(pos, "hardpforkhang", 1)
	elif zzp and zzn and nzz and nzn:
		_change_model(pos, "hardpforkhang", 2)
	elif zzp and pzz and nzz and nzp:
		_change_model(pos, "hardpforkhang", 3)
	elif zzp and pzz and zzn and pzn:
		_change_model(pos, "hardqforkhang", 0)
	elif pzz and zzn and nzz and nzn:
		_change_model(pos, "hardqforkhang", 1)
	elif zzp and zzn and nzz and nzp:
		_change_model(pos, "hardqforkhang", 2)
	elif zzp and pzz and nzz and pzp:
		_change_model(pos, "hardqforkhang", 3)
	elif zzp and pzz and zzn:
		_change_model(pos, "hardtforkhang", 0)
	elif pzz and zzn and nzz:
		_change_model(pos, "hardtforkhang", 1)
	elif zzp and zzn and nzz:
		_change_model(pos, "hardtforkhang", 2)
	elif zzp and pzz and nzz:
		_change_model(pos, "hardtforkhang", 3)
	elif zzp and nzz and nzp:
		_change_model(pos, "hardcornerhang", 1)
	elif zzp and pzz and pzp:
		_change_model(pos, "hardcornerhang", 2)
	elif zzn and pzz and pzn:
		_change_model(pos, "hardcornerhang", 3)
	elif zzn and nzz and nzn:
		_change_model(pos, "hardcornerhang", 0)
	elif zzp and nzz:
		_change_model(pos, "hardlforkhang", 3)
	elif zzp and pzz:
		_change_model(pos, "hardlforkhang", 0)
	elif pzz and zzn:
		_change_model(pos, "hardlforkhang", 1)
	elif zzn and nzz:
		_change_model(pos, "hardlforkhang", 2)
	elif zzp and zzn:
		_change_model(pos, "hardnarrowhang", 0)
	elif pzz and nzz:
		_change_model(pos, "hardnarrowhang", 1)
	elif zzn:
		_change_model(pos, "hardendhang", 0)
	elif nzz:
		_change_model(pos, "hardendhang", 1)
	elif zzp:
		_change_model(pos, "hardendhang", 2)
	elif pzz:
		_change_model(pos, "hardendhang", 3)
	else:
		_change_model(pos, "hardspirehang", 0)

func bottom_shape(pos : Vector3i, mask : int):
	var zzp : bool = mask & ZZP > 0
	var pzz : bool = mask & PZZ > 0
	var zzn : bool = mask & ZZN > 0
	var nzz : bool = mask & NZZ > 0
	var pzp : bool = mask & PZP > 0
	var pzn : bool = mask & PZN > 0
	var nzp : bool = mask & NZP > 0
	var nzn : bool = mask & NZN > 0
	var zpp : bool = mask & ZPP > 0
	var ppz : bool = mask & PPZ > 0
	var zpn : bool = mask & ZPN > 0
	var npz : bool = mask & NPZ > 0
	var ppp : bool = mask & PPP > 0
	var ppn : bool = mask & PPN > 0
	var npp : bool = mask & NPP > 0
	var npn : bool = mask & NPN > 0

	if false:
		pass
	elif zzp and pzz and not zpp and not ppz:
		_change_model(pos, "hardlforkcliff", 0)
	elif pzz and zzn and not ppz and not zpn:
		_change_model(pos, "hardlforkcliff", 1)
	elif zzn and nzz and not zpn and not npz:
		_change_model(pos, "hardlforkcliff", 2)
	elif zzp and nzz and not zpp and not npz:
		_change_model(pos, "hardlforkcliff", 3)
	elif zzp:
		_change_model(pos, "hardendcliff", 20)
	elif pzz:
		_change_model(pos, "hardendcliff", 21)
	elif zzn:
		_change_model(pos, "hardendcliff", 22)
	elif nzz:
		_change_model(pos, "hardendcliff", 23)
	else:
		_change_model(pos, "hardendhang", 16)

func middle_shape(pos : Vector3i, mask : int):
	var zzp : bool = mask & ZZP > 0
	var pzz : bool = mask & PZZ > 0
	var zzn : bool = mask & ZZN > 0
	var nzz : bool = mask & NZZ > 0
	var pzp : bool = mask & PZP > 0
	var pzn : bool = mask & PZN > 0
	var nzp : bool = mask & NZP > 0
	var nzn : bool = mask & NZN > 0

	_change_model(pos, "hardnarrowhang", 20)

func top_shape(pos : Vector3i, mask : int):
	var zzp : bool = mask & ZZP > 0
	var pzz : bool = mask & PZZ > 0
	var zzn : bool = mask & ZZN > 0
	var nzz : bool = mask & NZZ > 0
	var pzp : bool = mask & PZP > 0
	var pzn : bool = mask & PZN > 0
	var nzp : bool = mask & NZP > 0
	var nzn : bool = mask & NZN > 0
	var znp : bool = mask & ZNP > 0
	var znn : bool = mask & ZNN > 0
	var pnz : bool = mask & PNZ > 0
	var nnz : bool = mask & NNZ > 0
	var zpp : bool = mask & ZPP > 0
	var zpn : bool = mask & ZPN > 0
	var ppz : bool = mask & PPZ > 0
	var npz : bool = mask & NPZ > 0
	var npp : bool = mask & NPP > 0
	var ppp : bool = mask & PPP > 0
	var ppn : bool = mask & PPN > 0
	var npn : bool = mask & NPN > 0
	var nnp : bool = mask & NNP > 0
	var pnp : bool = mask & PNP > 0
	var pnn : bool = mask & PNN > 0
	var nnn : bool = mask & NNN > 0

	if zzp and pzz and zzn and nzz and nzp and nzn and pzn:
		_change_model(pos, "hardheartfork", 0)
	elif zzp and pzz and zzn and nzz and pzp and nzp and nzn:
		_change_model(pos, "hardheartfork", 1)
	elif zzp and pzz and zzn and nzz and pzn and pzp and nzp:
		_change_model(pos, "hardheartfork", 2)
	elif zzp and pzz and zzn and nzz and nzn and pzn and pzp:
		_change_model(pos, "hardheartfork", 3)
	elif zzp and pzz and zzn and nzz and pzn and pzp:
		_change_model(pos, "hardmacefork", 0)
	elif zzp and pzz and zzn and nzz and nzn and pzn:
		_change_model(pos, "hardmacefork", 1)
	elif zzp and pzz and zzn and nzz and nzp and nzn:
		_change_model(pos, "hardmacefork", 2)
	elif zzp and pzz and zzn and nzz and pzp and nzp:
		_change_model(pos, "hardmacefork", 3)
	elif zzp and pzz and zzn and nzz and pzn and nzp:
		_change_model(pos, "hardbowfork", 0)
	elif zzp and pzz and zzn and nzz and nzn and pzp:
		_change_model(pos, "hardbowfork", 1)
	elif zzp and pzz and zzn and nzz and pzn:
		_change_model(pos, "hardfishfork", 0)
	elif zzp and pzz and zzn and nzz and nzn:
		_change_model(pos, "hardfishfork", 1)
	elif zzp and pzz and zzn and nzz and nzp:
		_change_model(pos, "hardfishfork", 2)
	elif zzp and pzz and zzn and nzz and pzp:
		_change_model(pos, "hardfishfork", 3)
	elif zzp and pzz and zzn and nzz:
		_change_model(pos, "hardxfork", 0)
	elif zzp and pzz and zzn and pzp and pzn:
		_change_model(pos, "hardslope", 0)
	elif pzz and zzn and nzz and pzn and nzn:
		_change_model(pos, "hardslope", 1)
	elif zzp and zzn and nzz and nzp and nzn:
		_change_model(pos, "hardslope", 2)
	elif zzp and pzz and nzz and pzp and nzp:
		_change_model(pos, "hardslope", 3)
	elif zzp and pzz and zzn and pzp:
		_change_model(pos, "hardpfork", 0)
	elif pzz and zzn and nzz and pzn:
		_change_model(pos, "hardpfork", 1)
	elif zzp and zzn and nzz and nzn:
		_change_model(pos, "hardpfork", 2)
	elif zzp and pzz and nzz and nzp:
		_change_model(pos, "hardpfork", 3)
	elif zzp and pzz and zzn and pzn:
		_change_model(pos, "hardqfork", 0)
	elif pzz and zzn and nzz and nzn:
		_change_model(pos, "hardqfork", 1)
	elif zzp and zzn and nzz and nzp:
		_change_model(pos, "hardqfork", 2)
	elif zzp and pzz and nzz and pzp:
		_change_model(pos, "hardqfork", 3)
	elif zzp and pzz and zzn:
		_change_model(pos, "hardtfork", 0)
	elif pzz and zzn and nzz:
		_change_model(pos, "hardtfork", 1)
	elif zzp and zzn and nzz:
		_change_model(pos, "hardtfork", 2)
	elif zzp and pzz and nzz:
		_change_model(pos, "hardtfork", 3)
	elif zzp and nzz and nzp and znp and nnz and nnp:
		_change_model(pos, "hardcornercliff", 0)
	elif zzp and pzz and pzp and znp and pnz and pnp:
		_change_model(pos, "hardcornercliff", 0)
	elif pzz and zzn and pzn and pnz and znn and pnn:
		_change_model(pos, "hardcornercliff", 0)
	elif zzn and nzz and nzn and znn and nnz and nnn:
		_change_model(pos, "hardcornercliff", 0)
	elif zzp and nzz and nzp:
		_change_model(pos, "hardcorner", 0)
	elif zzp and pzz and pzp:
		_change_model(pos, "hardcorner", 1)
	elif zzn and pzz and pzn:
		_change_model(pos, "hardcorner", 2)
	elif zzn and nzz and nzn:
		_change_model(pos, "hardcorner", 3)
	elif zzp and nzz and not znp and not nnz:
		_change_model(pos, "hardlforkcliff", 19)
	elif zzp and pzz and not znp and not pnz:
		_change_model(pos, "hardlforkcliff", 16)
	elif pzz and zzn and not pnz and not znn:
		_change_model(pos, "hardlforkcliff", 17)
	elif zzn and nzz and not znn and not nnz:
		_change_model(pos, "hardlforkcliff", 18)
	elif zzp and nzz:
		_change_model(pos, "hardlfork", 0)
	elif zzp and pzz:
		_change_model(pos, "hardlfork", 1)
	elif pzz and zzn:
		_change_model(pos, "hardlfork", 2)
	elif zzn and nzz:
		_change_model(pos, "hardlfork", 3)
	elif zzp and zzn:
		_change_model(pos, "hardnarrow", 0)
	elif pzz and nzz:
		_change_model(pos, "hardnarrow", 1)
	elif zzp and not znp:
		_change_model(pos, "hardendcliff", 0)
	elif pzz and not pnz:
		_change_model(pos, "hardendcliff", 1)
	elif zzn and not znn:
		_change_model(pos, "hardendcliff", 2)
	elif nzz and not nnz:
		_change_model(pos, "hardendcliff", 3)
	elif zzp:
		_change_model(pos, "hardend", 0)
	elif pzz:
		_change_model(pos, "hardend", 1)
	elif zzn:
		_change_model(pos, "hardend", 2)
	elif nzz:
		_change_model(pos, "hardend", 3)
	else:
		_change_model(pos, "hardendhang", 20)
