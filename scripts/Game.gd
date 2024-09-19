extends Node

var slope_mesh : NodePath
var smooth_mesh : NodePath
var model_mesh : NodePath
var block_mesh : NodePath

var input : InputHandler
var map : MapHandler
var targeti : Vector3i
var mode : MapHandler.MODE
var actor : Actor
var controller : Controller
var palette : EditorPalette

var WHEELS : Array[int] = \
[
	MouseButton.MOUSE_BUTTON_WHEEL_UP,
	MouseButton.MOUSE_BUTTON_WHEEL_DOWN
]

func _ready() -> void:
	input =  InputHandler.new()
	map =  MapHandler.new()
	map.save_location = "map"

	input.set_default_deadzone(0.25)
	input.set_default_tap_threshold(0.125)
	input.set_default_doubletap_threshold(0.25)
	input.set_default_high_threshold(0.5)
	input.set_default_hold_threshold(0.25)
	input.set_default_buffer_length(5)

func set_palette(_palette : EditorPalette) -> void:
	palette = _palette

func get_palette() -> EditorPalette:
	return palette

func get_palette_w() -> String:
	return palette.w

func get_palette_x() -> String:
	return palette.x

func get_palette_y() -> String:
	return palette.y

func get_palette_z() -> String:
	return palette.z

func get_palette_g() -> String:
	return str(palette.g)

func get_palette_b() -> String:
	return str(palette.b)

func get_palette_r() -> String:
	return str(palette.r)

func get_palette_a() -> String:
	return str(palette.a)

func get_palette_smooth_value() -> String:
	return str(palette.smooth_value)

func get_palette_slope_value() -> String:
	return str(palette.slope_value)

func get_target_pos() -> String:
	return get_target_x() +"X, " +get_target_y() +"Y, " +get_target_z() +"Z"

func get_target_x() -> String:
	return str(targeti.x)

func get_target_y() -> String:
	return str(targeti.y)

func get_target_z() -> String:
	return str(targeti.z)

func get_target_geo() -> String:
	match(mode):
		MapHandler.MODE.SMOOTH:
			return get_smooth_target_geo()
		MapHandler.MODE.SLOPE:
			return get_slope_target_geo()
		MapHandler.MODE.MODEL:
			return get_slope_target_geo()
		_:
			return get_slope_target_geo()

func get_target_terrain_w() -> String:
	match(mode):
		MapHandler.MODE.SMOOTH:
			return get_smooth_target_terrain_w()
		MapHandler.MODE.SLOPE:
			return get_slope_target_terrain_w()
		MapHandler.MODE.MODEL:
			return get_slope_target_terrain_w()
		_:
			return get_slope_target_terrain_w()

func get_target_terrain_x() -> String:
	match(mode):
		MapHandler.MODE.SMOOTH:
			return get_smooth_target_terrain_x()
		MapHandler.MODE.SLOPE:
			return get_slope_target_terrain_x()
		MapHandler.MODE.MODEL:
			return get_slope_target_terrain_x()
		_:
			return get_slope_target_terrain_x()

func get_target_terrain_y() -> String:
	match(mode):
		MapHandler.MODE.SMOOTH:
			return get_smooth_target_terrain_y()
		MapHandler.MODE.SLOPE:
			return get_slope_target_terrain_y()
		MapHandler.MODE.MODEL:
			return get_slope_target_terrain_y()
		_:
			return get_slope_target_terrain_y()

func get_target_terrain_z() -> String:
	match(mode):
		MapHandler.MODE.SMOOTH:
			return get_smooth_target_terrain_z()
		MapHandler.MODE.SLOPE:
			return get_slope_target_terrain_z()
		MapHandler.MODE.MODEL:
			return get_slope_target_terrain_z()
		_:
			return get_slope_target_terrain_z()

func get_target_blend_r() -> String:
	match(mode):
		MapHandler.MODE.SMOOTH:
			return get_smooth_target_blend_r()
		MapHandler.MODE.SLOPE:
			return get_slope_target_blend_r()
		MapHandler.MODE.MODEL:
			return get_slope_target_blend_r()
		_:
			return get_slope_target_blend_r()

func get_target_blend_g() -> String:
	match(mode):
		MapHandler.MODE.SMOOTH:
			return get_smooth_target_blend_g()
		MapHandler.MODE.SLOPE:
			return get_slope_target_blend_g()
		MapHandler.MODE.MODEL:
			return get_slope_target_blend_g()
		_:
			return get_slope_target_blend_g()

func get_target_blend_b() -> String:
	match(mode):
		MapHandler.MODE.SMOOTH:
			return get_smooth_target_blend_b()
		MapHandler.MODE.SLOPE:
			return get_slope_target_blend_b()
		MapHandler.MODE.MODEL:
			return get_slope_target_blend_b()
		_:
			return get_slope_target_blend_b()

func get_target_blend_a() -> String:
	match(mode):
		MapHandler.MODE.SMOOTH:
			return get_smooth_target_blend_a()
		MapHandler.MODE.SLOPE:
			return get_slope_target_blend_a()
		MapHandler.MODE.MODEL:
			return get_slope_target_blend_a()
		_:
			return get_slope_target_blend_a()

func get_slope_target_geo() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
	return str(roundf(mesh.tool.get_voxel_f(targeti)))

func get_slope_target_terrain_w() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : int = VoxelTool.u16_indices_to_vec4i(indices).w
	if i == 15: return str(map.get_texture_name(0))
	return str(map.get_texture_name(i))

func get_slope_target_terrain_x() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : int = VoxelTool.u16_indices_to_vec4i(indices).x
	if i == 15: return str(map.get_texture_name(0))
	return str(map.get_texture_name(i))

func get_slope_target_terrain_y() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : int = VoxelTool.u16_indices_to_vec4i(indices).y
	if i == 15: return str(map.get_texture_name(0))
	return str(map.get_texture_name(i))

func get_slope_target_terrain_z() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : int = VoxelTool.u16_indices_to_vec4i(indices).z
	if i == 15: return str(map.get_texture_name(0))
	return str(map.get_texture_name(i))

func get_slope_target_blend_r() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : float = VoxelTool.u16_weights_to_color(indices).r
	return str(i)

func get_slope_target_blend_g() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : float = VoxelTool.u16_weights_to_color(indices).g
	return str(i)

func get_slope_target_blend_b() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : float = VoxelTool.u16_weights_to_color(indices).b
	return str(i)

func get_slope_target_blend_a() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : float = VoxelTool.u16_weights_to_color(indices).a
	return str(i)

func get_smooth_target_geo() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
	return str(roundf(mesh.tool.get_voxel_f(targeti)))

func get_smooth_target_terrain_w() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : int = VoxelTool.u16_indices_to_vec4i(indices).w
	return str(map.get_texture_name(i))

func get_smooth_target_terrain_x() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : int = VoxelTool.u16_indices_to_vec4i(indices).x
	return str(map.get_texture_name(i))

func get_smooth_target_terrain_y() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : int = VoxelTool.u16_indices_to_vec4i(indices).y
	return str(map.get_texture_name(i))

func get_smooth_target_terrain_z() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : int = VoxelTool.u16_indices_to_vec4i(indices).z
	return str(map.get_texture_name(i))

func get_smooth_target_blend_r() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : float = VoxelTool.u16_weights_to_color(indices).r
	return str(i)

func get_smooth_target_blend_g() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : float = VoxelTool.u16_weights_to_color(indices).g
	return str(i)

func get_smooth_target_blend_b() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : float = VoxelTool.u16_weights_to_color(indices).b
	return str(i)

func get_smooth_target_blend_a() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : float = VoxelTool.u16_weights_to_color(indices).a
	return str(i)

func get_tile_pos() -> String:
	return get_tile_x() + "X, " + get_tile_y() + "Y, " + get_tile_z() + "Z"

func get_tile_x() -> String:
	return str(floori(float(targeti.x) / float(map.map.tile_palette.tile_size.x)))

func get_tile_y() -> String:
	return str(floori(float(targeti.y) / float(map.map.tile_palette.tile_size.y)))

func get_tile_z() -> String:
	return str(floori(float(targeti.z) / float(map.map.tile_palette.tile_size.z)))

func get_mode() -> String:
	return MapHandler.MODE_NAMES[mode]

func get_mode_mesh() -> VoxelMesh:
	return get_mesh_of_mode(mode)

func get_mesh_of_mode(m : MapHandler.MODE) -> VoxelMesh:
	match(m):
		MapHandler.MODE.SMOOTH:
			return get_smooth_mesh()
		MapHandler.MODE.SLOPE:
			return get_slope_mesh()
		MapHandler.MODE.MODEL:
			return get_model_mesh()
		_:
			return get_block_mesh()

func set_slope_mesh(path : NodePath) -> void:
	slope_mesh = path

func get_slope_mesh() -> SlopeMesh:
	return get_node(slope_mesh)

func set_smooth_mesh(path : NodePath) -> void:
	smooth_mesh = path

func get_smooth_mesh() -> SmoothMesh:
	return get_node(smooth_mesh)

func set_model_mesh(path : NodePath) -> void:
	model_mesh = path

func get_model_mesh() -> ModelMesh:
	return get_node(model_mesh)

func set_block_mesh(path : NodePath) -> void:
	block_mesh = path

func get_block_mesh() -> BlockMesh:
	return get_node(block_mesh)

func set_actor(_actor : Actor) -> void:
	actor = _actor

func get_actor() -> Actor:
	return actor

func set_controller(_controller : Controller) -> void:
	controller = _controller

func get_controller() -> Controller:
	return controller

func _physics_process(delta: float) -> void:
	input.update_all(delta)

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		input.mouse_motion_event(event)
	elif event is InputEventMouseButton:
		var e : InputEventMouseButton = event
		if e.button_index in WHEELS:
			input.mouse_wheel_event(event)
