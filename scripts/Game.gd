extends Node

var slope_mesh : NodePath
var smooth_mesh : NodePath
var model_mesh : NodePath
var block_mesh : NodePath
var ui_controller : NodePath

var input : InputHandler
var map : MapHandler
var targeti : Vector3i
var actor : Actor
var controller : Controller

signal InputsReady(delta : float)
signal CommandUpdate
signal AtlasUpdate

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
	input.set_default_tap_threshold(1.125)
	input.set_default_axis_tap_threshold(1.125)
	input.set_default_doubletap_threshold(1.25)
	input.set_default_axis_doubletap_threshold(1.25)
	input.set_default_high_threshold(0.5)
	input.set_default_hold_threshold(1.5)
	input.set_default_buffer_length(5)
	input.set_default_axis_buffer_length(5)

func get_target_pos() -> String:
	return get_target_x() +"X, " +get_target_y() +"Y, " +get_target_z() +"Z"

func get_target_x() -> String:
	return str(targeti.x)

func get_target_y() -> String:
	return str(targeti.y)

func get_target_z() -> String:
	return str(targeti.z)

func get_tile_pos() -> String:
	return get_tile_x() + "X, " + get_tile_y() + "Y, " + get_tile_z() + "Z"

func get_tile_x() -> String:
	return str(floori(float(targeti.x) / float(map.map.tile_palette.tile_size.x)))

func get_tile_y() -> String:
	return str(floori(float(targeti.y) / float(map.map.tile_palette.tile_size.y)))

func get_tile_z() -> String:
	return str(floori(float(targeti.z) / float(map.map.tile_palette.tile_size.z)))

func get_mode_mesh(m : MapHandler.MODE) -> VoxelMesh:
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

func inputs_ready(delta : float) -> void:
	InputsReady.emit(delta)

func set_ui(path : NodePath) -> void:
	ui_controller = path

func get_ui() -> UIController:
	return get_node(ui_controller)

func command_update() -> void:
	CommandUpdate.emit()

func atlas_update() -> void:
	AtlasUpdate.emit()

func _physics_process(delta: float) -> void:
	input.update_actions(delta)
	inputs_ready(delta)

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		input.mouse_motion_event(event)
	elif event is InputEventMouseButton:
		var e : InputEventMouseButton = event
		if e.button_index in WHEELS:
			input.mouse_wheel_event(event)
