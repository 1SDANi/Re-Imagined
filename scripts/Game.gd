extends Node

var slope_mesh : NodePath
var smooth_mesh : NodePath
var model_mesh : NodePath
var block_mesh : NodePath

var input : InputHandler
var map : MapHandler
var targeti : Vector3i
var mode : MapHandler.MODE

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
	input.set_default_hold_threshold(1.0)
	input.set_default_buffer_length(5)

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

func get_target_terrain() -> String:
	match(mode):
		MapHandler.MODE.SMOOTH:
			return get_smooth_target_terrain()
		MapHandler.MODE.SLOPE:
			return get_slope_target_terrain()
		MapHandler.MODE.MODEL:
			return get_slope_target_terrain()
		_:
			return get_slope_target_terrain()

func get_slope_target_geo() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
	return str(roundf(mesh.tool.get_voxel_f(targeti)))

func get_slope_target_terrain() -> String:
	var mesh : SlopeMesh = get_slope_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : int = VoxelTool.u16_indices_to_vec4i(indices).x
	return str(mesh.texture_names[i])

func get_smooth_target_geo() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
	return str(roundf(mesh.tool.get_voxel_f(targeti)))

func get_smooth_target_terrain() -> String:
	var mesh : SmoothMesh = get_smooth_mesh()
	mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
	var indices : int = mesh.tool.get_voxel(targeti)
	var i : int = VoxelTool.u16_indices_to_vec4i(indices).x
	return str(mesh.texture_names[i])

func get_tile_pos() -> String:
	return get_tile_x() + "X, " + get_tile_y() + "Y, " + get_tile_z() + "Z"

func get_tile_x() -> String:
	return str(floori(float(targeti.x) / float(map.map.tile_size.z)))

func get_tile_y() -> String:
	return str(floori(float(targeti.y) / float(map.map.tile_size.y)))

func get_tile_z() -> String:
	return str(floori(float(targeti.z) / float(map.map.tile_size.z)))

func get_mode_mesh() -> VoxelMesh:
	match(mode):
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

func _physics_process(delta: float) -> void:
	input.update_all(delta)

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		input.mouse_motion_event(event)
	elif event is InputEventMouseButton:
		var e : InputEventMouseButton = event
		if e.button_index in WHEELS:
			input.mouse_wheel_event(event)
