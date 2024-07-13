class_name EditorController
extends Controller

@export var cam_speed_x : float
@export var cam_speed_y : float

@export var tool_scale : float

@export var cam : NodePath
@export var start_highlight : NodePath
@export var end_highlight : NodePath
@export var debug_highlight : NodePath

@export var terrain_label : NodePath
@export var mode_label : NodePath
@export var tool_label : NodePath

@export var initial_rot : int
@export var initial_model : String
@export var initial_terrain : String
@export var initial_mode : MapHandler.MODE
@export var initial_tool : MapHandler.TOOL

var _terrain_label : Label
var _mode_label : Label
var _tool_label : Label

var _cam : VirtualCamera3D
var _start_highlight : Node3D
var _end_highlight : Node3D
var _debug_highlight : Node3D

var _pause_lock : bool
var _place_lock : bool
var _ymove_lock : bool
var _mode_lock : bool
var _tool_lock : bool
var _terrain_lock : bool

var model : String
var rot : int
var terrain : String
var mode : MapHandler.MODE
var tool : MapHandler.TOOL
var start_pos : Vector3i
var dragging : bool

func _ready() -> void:
	var action : InputAction

	rot = initial_rot
	model = initial_model
	terrain = initial_terrain
	mode = initial_mode
	tool = initial_tool

	if not game.input.add_mouse_dir(InputHandler.MOUSE_DIR.UP, "Look Up"):
		print("failed to add input")
	if not game.input.add_input("RY+", "Look Up GMP"):
		print("failed to add input")
	if not game.input.add_mouse_dir(InputHandler.MOUSE_DIR.DOWN, "Look Down"):
		print("failed to add input")
	if not game.input.add_input("RY-", "Look Down GMP"):
		print("failed to add input")
	if not game.input.add_mouse_dir(InputHandler.MOUSE_DIR.LEFT, "Look Left"):
		print("failed to add input")
	if not game.input.add_input("RX-", "Look Left GMP"):
		print("failed to add input")
	if not game.input.add_mouse_dir(InputHandler.MOUSE_DIR.RIGHT, "Look Right"):
		print("failed to add input")
	if not game.input.add_input("RX+", "Look Right GMP"):
		print("failed to add input")
	if not game.input.add_mouse_button(MouseButton.MOUSE_BUTTON_LEFT, "Place"):
		print("failed to add input")
	if not game.input.add_input("RR", "Place GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_TAB, "Mode"):
		print("failed to add input")
	if not game.input.add_input("LC", "Mode GMP"):
		print("failed to add input")
	if not game.input.add_mouse_button(MouseButton.MOUSE_BUTTON_RIGHT, "Tool"):
		print("failed to add input")
	if not game.input.add_input("RU", "Tool GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_Q, "Last Primary"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_E, "Next Primary"):
		print("failed to add input")
	if not game.input.add_input("LL", "Last Primary GMP"):
		print("failed to add input")
	if not game.input.add_input("LR", "Next Primary GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_F, "Last Secondary"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_R, "Next Secondary"):
		print("failed to add input")
	if not game.input.add_input("LD", "Last Secondary GMP"):
		print("failed to add input")
	if not game.input.add_input("LU", "Next Secondary GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_C, "Copy"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_V, "Paste"):
		print("failed to add input")
	if not game.input.add_input("LZ", "Copy GMP"):
		print("failed to add input")
	if not game.input.add_input("RZ", "Paste GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_CTRL, "Reskin"):
		print("failed to add input")
	if not game.input.add_input("RF", "Reskin GMP"):
		print("failed to add input")
	if not game.input.add_mouse_button(MouseButton.MOUSE_BUTTON_WHEEL_DOWN, "Last Texture"):
		print("failed to add input")
	if not game.input.add_mouse_button(MouseButton.MOUSE_BUTTON_WHEEL_UP, "Next Texture"):
		print("failed to add input")
	action = game.input.actions["Last Texture"]
	action.update(0.0, 1.0)
	action = game.input.actions["Next Texture"]
	action.update(0.0, 1.0)
	if not game.input.add_input("LB", "Last Texture GMP"):
		print("failed to add input")
	if not game.input.add_input("RB", "Next Texture GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_W, "Move Front"):
		print("failed to add input")
	if not game.input.add_input("LY-", "Move Front GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_S, "Move Back"):
		print("failed to add input")
	if not game.input.add_input("LY+", "Move Back GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_A, "Move Left"):
		print("failed to add input")
	if not game.input.add_input("LX-", "Move Left GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_D, "Move Right"):
		print("failed to add input")
	if not game.input.add_input("LX+", "Move Right GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_ESCAPE, "Pause"):
		print("failed to add input")
	if not game.input.add_input("RC", "Pause GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_SPACE, "Rise"):
		print("failed to add input")
	if not game.input.add_input("RD", "Rise GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_SHIFT, "Fall"):
		print("failed to add input")
	if not game.input.add_input("RL", "Fall GMP"):
		print("failed to add input")
	game.input.set_cam_speed_x(cam_speed_x)
	game.input.set_cam_speed_y(cam_speed_y)
	_cam = get_node(cam)
	_terrain_label = get_node(terrain_label)
	_mode_label = get_node(mode_label)
	_tool_label = get_node(tool_label)
	_start_highlight = get_node(start_highlight)
	_end_highlight = get_node(end_highlight)
	_debug_highlight = get_node(debug_highlight)
	_pause_lock = false
	_place_lock = false
	dragging = false
	_mode_label.set_text(MapHandler.MODE_NAMES[mode])
	_tool_label.set_text(MapHandler.TOOL_NAMES[tool])

func _physics_process(delta : float) -> void:
	handle_pausing()

	if game.input.is_mouse_free(): return

	handle_looking(delta)
	handle_movement(delta)
	handle_placing(delta)

func handle_pausing() -> void:
	var pause : float = game.input.get_action_value("Pause")
	pause = max(pause, game.input.get_action_value("Pause GMP"))

	if _pause_lock:
		if is_zero_approx(pause):
			_pause_lock = false
	elif not is_zero_approx(pause):
		game.input.toggle_mouse_capture()
		_pause_lock = true

func handle_looking(delta : float) -> void:
	var look_x : float = game.input.get_axis_value_total("Look Right", "Look Left", true)
	look_x += game.input.get_axis_value_total("Look Right GMP", "Look Left GMP", true)
	var look_y : float = game.input.get_axis_value_total("Look Up", "Look Down", true)
	look_y += game.input.get_axis_value_total("Look Up GMP", "Look Down GMP", true)

	if not is_zero_approx(look_x):
		_cam.orbiting.yaw += look_x * game.input.get_cam_speed_x() * delta

	if not is_zero_approx(look_y):
		_cam.orbiting.pitch += look_y * game.input.get_cam_speed_y() * delta
		_cam.orbiting.pitch = clamp(_cam.orbiting.pitch, -TAU/64 * 3, TAU/64 * 15)

func handle_movement(delta: float) -> void:
	var move_y : float = game.input.get_axis_value_spacey("Move Front", "Move Back", true)
	move_y += game.input.get_axis_value_spacey("Move Front GMP", "Move Back GMP", true)
	var move_x : float = game.input.get_axis_value_spacey("Move Left", "Move Right", true)
	move_x += game.input.get_axis_value_spacey("Move Left GMP", "Move Right GMP", true)
	var parent : ThirdPersonActor = get_parent()

	var move : Vector3 = Vector3(move_x, 0, move_y).normalized()

	var rise : float = game.input.get_action_value("Rise")
	rise = max(rise, game.input.get_action_value("Rise GMP"))

	var fall : float = game.input.get_action_value("Fall")
	fall = max(fall, game.input.get_action_value("Fall GMP"))

	if not move.is_zero_approx():
		var v : Vector3 = move.rotated(Vector3.UP, -_cam.orbiting.yaw)
		parent.fix_angle(atan2(v.x, v.z))
		parent.move(Vector2(v.x, v.z), delta)
	else:
		parent.move(Vector2.ZERO, delta)

	var ymove : bool = false

	if _ymove_lock:
		if is_zero_approx(rise) and is_zero_approx(fall):
			_ymove_lock = false
	elif not is_zero_approx(rise) or not is_zero_approx(fall):
		_ymove_lock = true
		ymove = true

	if ymove:
		var _mesh : SlopeMesh = game.get_slope_mesh()
		var off : Vector3 = Vector3(0, 1, 0)
		if is_zero_approx(rise) and not is_zero_approx(fall):
			off = Vector3(0, -1, 0)
		parent.position += off
		parent.position.y = floor(parent.position.y)

func handle_placing(delta: float) -> void:
	var action: InputAction
	var place : float = game.input.get_action_value("Place")
	place = max(place, game.input.get_action_value("Place GMP"))
	var mode_toggle : float = game.input.get_action_value("Mode")
	mode_toggle = max(mode_toggle, game.input.get_action_value("Mode GMP"))
	var tool_toggle : float = game.input.get_action_value("Tool")
	tool_toggle = max(tool_toggle, game.input.get_action_value("Tool GMP"))
	var copy : float = game.input.get_action_value("Copy")
	copy = max(copy, game.input.get_action_value("Copy GMP"))
	var paste : float = game.input.get_action_value("Paste")
	paste = max(paste, game.input.get_action_value("Paste GMP"))
	var reskin : float = game.input.get_action_value("Reskin")
	reskin = max(reskin, game.input.get_action_value("Reskin GMP"))
	var next : float = game.input.get_action_value("Next Texture")
	next = max(next, game.input.get_action_value("Next Texture GMP"))
	var last : float = game.input.get_action_value("Last Texture")
	last = max(last, game.input.get_action_value("Last Texture GMP"))
	action = game.input.actions["Last Texture"]
	action.update(0.0, delta)
	action = game.input.actions["Next Texture"]
	action.update(0.0, delta)
	var primary : float = 0.0
	primary -= game.input.get_action_value("Last Primary")
	primary += game.input.get_action_value("Next Primary")
	primary -= game.input.get_action_value("Last Primary GMP")
	primary += game.input.get_action_value("Next Primary GMP")
	var secondary : float = 0.0
	secondary -= game.input.get_action_value("Last Secondary")
	secondary += game.input.get_action_value("Next Secondary")
	secondary -= game.input.get_action_value("Last Secondary GMP")
	secondary += game.input.get_action_value("Next Secondary GMP")

	var mesh : VoxelMesh = game.get_mode_mesh()
	var parent_pos : Vector3 = (get_parent() as ThirdPersonActor).position
	var pos : Vector3 = mesh.to_local(parent_pos) + Vector3.DOWN / 2
	var target : Vector3 = pos
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	game.targeti = target + Vector3.DOWN / 2
	var grid : Vector3 = Vector3.UP * 0.5 + Vector3.RIGHT * 0.5 + Vector3.BACK * 0.5

	if _debug_highlight != null:
		_debug_highlight.position = pos
	_start_highlight.position = Vector3(game.targeti) + grid
	if not dragging:
		_end_highlight.position = Vector3(game.targeti) + grid

	if _terrain_lock:
		if is_zero_approx(next) and is_zero_approx(last) and \
			is_zero_approx(primary) and is_zero_approx(secondary):
			_terrain_lock = false
		else:
			next = 0
			last = 0
			primary = 0
			secondary = 0
	elif not is_zero_approx(next) or not is_zero_approx(last) or \
		not is_zero_approx(primary) or not is_zero_approx(secondary):
		_terrain_lock = true

	var index : int
	if primary > 0.0:
		index = game.map.primaries.find(game.map.primary)
		if index == game.map.primaries.size() - 1:
			game.map.primary = game.map.primaries[0]
		else:
			game.map.primary = game.map.primaries[index + 1]
		next = 0.0
	elif primary < 0.0:
		index = game.map.primaries.find(game.map.primary)
		if index == 0:
			game.map.primary = game.map.primaries[game.map.primaries.size() - 1]
		else:
			game.map.primary = game.map.primaries[index - 1]
		next = 0.0
	elif secondary > 0.0:
		index = game.map.secondaries.find(game.map.secondary)
		if index == game.map.secondaries.size() - 1:
			game.map.secondary = game.map.secondaries[0]
		else:
			game.map.secondary = game.map.secondaries[index + 1]
		next = 0.0
	elif secondary < 0.0:
		index = game.map.secondaries.find(game.map.secondary)
		if index == 0:
			game.map.secondary = game.map.secondaries[game.map.secondaries.size() - 1]
		else:
			game.map.secondary = game.map.secondaries[index - 1]
		next = 0.0

	var m : int = mesh.texture_names.find(terrain)
	if next:
		if m >= mesh.texture_names.size() - 1: terrain = mesh.texture_names[0]
		else: terrain = mesh.texture_names[m + 1]
	elif last:
		if m <= 0: terrain = mesh.texture_names[mesh.texture_names.size() - 1]
		else: terrain = mesh.texture_names[m - 1]
	_terrain_label.set_text(terrain)

	if _mode_lock:
		if is_zero_approx(mode_toggle):
			_mode_lock = false
	elif not is_zero_approx(mode_toggle):
		_mode_lock = true
		match(mode):
			MapHandler.MODE.MODEL:
				mode = MapHandler.MODE.SLOPE
				game.mode = MapHandler.MODE.SLOPE
			MapHandler.MODE.SLOPE:
				mode = MapHandler.MODE.SMOOTH
				game.mode = MapHandler.MODE.SMOOTH
			MapHandler.MODE.SMOOTH:
				mode = MapHandler.MODE.MODEL
				game.mode = MapHandler.MODE.MODEL

		_mode_label.set_text(MapHandler.MODE_NAMES[mode])

	if _tool_lock:
		if is_zero_approx(tool_toggle):
			_tool_lock = false
	elif not is_zero_approx(tool_toggle):
		_tool_lock = true
		match(tool):
			MapHandler.TOOL.PLACE:
				tool = MapHandler.TOOL.MAX
			MapHandler.TOOL.MAX:
				tool = MapHandler.TOOL.REMOVE
			MapHandler.TOOL.REMOVE:
				tool = MapHandler.TOOL.GROW
			MapHandler.TOOL.GROW:
				tool = MapHandler.TOOL.SHRINK
			MapHandler.TOOL.SHRINK:
				tool = MapHandler.TOOL.PLACE

		_tool_label.set_text(MapHandler.TOOL_NAMES[tool])

	if _place_lock:
		if is_zero_approx(place) and is_zero_approx(copy) and \
			is_zero_approx(paste) and is_zero_approx(reskin):
			_place_lock = false
			if not dragging: return
			var r : int = 1
			var s : int = 1
			var t : int = 1
			var i : int = game.targeti.x - start_pos.x
			var j : int = game.targeti.y - start_pos.y
			var k : int = game.targeti.z - start_pos.z
			if i < 0:
				i = -i
				r = -r
			if j < 0:
				j = -j
				s = -s
			if k < 0:
				k = -k
				t = -t
			var a : int
			var b : int
			var c : int
			for x : int in range(i + 1):
				for y : int in range(j + 1):
					for z : int in range(k + 1):
						a = start_pos.x + x * r
						b = start_pos.y + y * s
						c = start_pos.z + z * t
						var at : Vector3i = Vector3i(a, b, c)
						if mode in MapHandler.SOFT_MODES:
							(mesh as SoftMesh).set_blend(at, Color(1.0, 0.0, 0.0, 0.0))
							(mesh as SoftMesh).set_tex(at, terrain)
							match(tool):
								MapHandler.TOOL.PLACE:
									(mesh as SoftMesh).place_geo(at)
								MapHandler.TOOL.MAX:
									(mesh as SoftMesh).max_geo(at)
								MapHandler.TOOL.REMOVE:
									(mesh as SoftMesh).remove_geo(at)
								MapHandler.TOOL.GROW:
									(mesh as SoftMesh).change_geo(at, -tool_scale)
								MapHandler.TOOL.SHRINK:
									(mesh as SoftMesh).change_geo(at, tool_scale)
						elif mode == MapHandler.MODE.MODEL:
							var voxel : int = (mesh as ModelMesh).get_model(model, rot, terrain)
							match(tool):
								MapHandler.TOOL.PLACE:
									(mesh as ModelMesh).place_voxel(at, voxel)
								MapHandler.TOOL.MAX:
									(mesh as ModelMesh).place_voxel(at, voxel)
								MapHandler.TOOL.REMOVE:
									(mesh as ModelMesh).remove_voxel(at)
								MapHandler.TOOL.GROW:
									(mesh as ModelMesh).place_voxel(at, voxel)
								MapHandler.TOOL.SHRINK:
									(mesh as ModelMesh).remove_voxel(at)
			dragging = false
	elif not is_zero_approx(place) or not is_zero_approx(copy) or \
		not is_zero_approx(paste) or not is_zero_approx(reskin):
		_place_lock = true

		if not is_zero_approx(place):
			start_pos = game.targeti
			_end_highlight.position = Vector3(game.targeti) + grid
			dragging = true
		elif not is_zero_approx(copy):
			game.map.save_tile()
		elif not is_zero_approx(paste):
			game.map.set_tile()
		elif not is_zero_approx(reskin):
			game.map.reskin(mode, game.targeti, terrain, )

