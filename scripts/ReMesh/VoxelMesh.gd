extends VoxelTerrain
class_name VoxelMesh

var tool : VoxelTool
var atlas : Image

@export var textures : Array[Image]
@export var texture_names : Array[String]
@export var res : int

@export var generate_library : bool = false

func _ready() -> void:
	tool = get_voxel_tool()
	if generate_library:
		_new_atlas()

func _new_atlas() -> void:
	var size : Vector2i = Vector2i(textures.size(), 1) * res
	atlas = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)

	var pos : int = 0
	for tex : Image in textures: pos = _add_tex(pos, tex)
	if not atlas.save_png("res://VoxelAtlas.png") == OK:
		print("couldn't save")

func _add_tex(pos : int, tex : Image) -> int:
	var rect : Rect2i = Rect2i(0, 0, tex.get_width(), tex.get_height())
	atlas.blit_rect(tex, rect, Vector2i(pos, 0))
	return pos + res
