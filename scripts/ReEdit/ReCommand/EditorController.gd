class_name EditorController
extends Controller

@export var cam_speed_x : float
@export var cam_speed_y : float

@export var cam : NodePath
@export var start_highlight : NodePath
@export var end_highlight : NodePath
@export var debug_highlight : NodePath
@export var grid_highlight : NodePath

@export var initial_rot : int
@export var initial_model : String

@export var initial_texture_1 : String
@export var initial_texture_2 : String
@export var initial_texture_3 : String
@export var initial_texture_4 : String

@export var initial_weight_r : float
@export var initial_weight_g : float
@export var initial_weight_b : float
@export var initial_weight_a : float

@export var initial_smooth_value : float
@export var initial_slope_value : float

@export var initial_mode : MapHandler.MODE

var _cam : VirtualCamera3D
var _start_highlight : Node3D
var _end_highlight : Node3D
var _debug_highlight : Node3D
var _grid_highlight : Node3D

var _pause_lock : bool
var _place_lock : bool
var _ymove_lock : bool
var _command_lock : bool

var start_pos : bool
var end_pos : bool
var commanding : bool
var opening : bool

func _ready() -> void:
	var action : InputAction

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
	if not game.input.add_mouse_button(MouseButton.MOUSE_BUTTON_LEFT, "Use Command"):
		print("failed to add input")
	if not game.input.add_input("RR", "Use Command GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_TAB, "Mode"):
		print("failed to add input")
	if not game.input.add_input("LC", "Mode GMP"):
		print("failed to add input")
	if not game.input.add_mouse_button(MouseButton.MOUSE_BUTTON_RIGHT, "Tool"):
		print("failed to add input")
	if not game.input.add_input("RU", "Tool GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_Q, "Close Menu"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_E, "Open Menu"):
		print("failed to add input")
	if not game.input.add_input("LL", "Close Menu GMP"):
		print("failed to add input")
	if not game.input.add_input("LR", "Open Right GMP"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_F, "Command Down"):
		print("failed to add input")
	if not game.input.add_key(Key.KEY_R, "Command Up"):
		print("failed to add input")
	if not game.input.add_input("LD", "Command Down GMP"):
		print("failed to add input")
	if not game.input.add_input("LU", "Command Up GMP"):
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
	_start_highlight = get_node(start_highlight)
	_end_highlight = get_node(end_highlight)
	_debug_highlight = get_node(debug_highlight)
	_grid_highlight = get_node(grid_highlight)
	_pause_lock = false
	_place_lock = false

	game.set_actor((get_parent() as Actor))
	game.set_controller(self)

	await owner.ready

	var _wheel : EditorWheel = EditorWheel.new(get_parent() as Actor, self)

	update_target()

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

	var command : float = 0.0
	command += game.input.get_action_value("Command Down")
	command -= game.input.get_action_value("Command Up")
	command += game.input.get_action_value("Command Up GMP")
	command -= game.input.get_action_value("Command Down GMP")
	var menu : float = 0.0
	menu += game.input.get_action_value("Open Menu")
	menu -= game.input.get_action_value("Close Menu")
	menu += game.input.get_action_value("Open Menu GMP")
	menu -= game.input.get_action_value("Close Menu GMP")
	var use : float = 0.0
	menu += game.input.get_action_value("Use Command")
	menu += game.input.get_action_value("Use Command GMP")
	var use_held : int = 0
	use_held += 1 if game.input.was_action_held("Use Command") else 0
	use_held += 1 if game.input.was_action_held("Use Command GMP") else 0
	if use_held > 0: print("opened")

	var use_tapped : int = 0
	use_tapped += 1 if game.input.was_action_tapped("Use Command") else 0
	use_tapped += 1 if game.input.was_action_tapped("Use Command GMP") else 0

	var open_held : int = 0
	open_held += 1 if game.input.was_action_held("Open Menu") else 0
	open_held += 1 if game.input.was_action_held("Open Menu GMP") else 0
	if open_held > 0: print("opened")

	var open_tapped : int = 0
	open_tapped += 1 if game.input.was_action_tapped("Open Menu") else 0
	open_tapped += 1 if game.input.was_action_tapped("Open Menu GMP") else 0

	update_target()

	if commanding:
		if use_held > 0:
			(get_parent() as Actor).command_use_release_hold()
		elif use_tapped > 0:
			(get_parent() as Actor).command_use_release_tap()
			commanding = false

	if opening:
		if use_held > 0:
			(get_parent() as Actor).command_open_release_hold()
		elif use_tapped > 0:
			(get_parent() as Actor).command_open_release_tap()
			opening = false

	if _command_lock:
		if is_zero_approx(command) and is_zero_approx(menu):
			_command_lock = false
	elif not is_zero_approx(command) or not is_zero_approx(menu) or \
		not is_zero_approx(use):
		_command_lock = true
		if command > 0:
			(get_parent() as Actor).command_up()
		elif command < 0:
			(get_parent() as Actor).command_down()
		if menu > 0:
			(get_parent() as Actor).command_open()
			opening = true
		elif menu < 0:
			(get_parent() as Actor).command_close()
		if not is_zero_approx(use):
			(get_parent() as Actor).command_use()
			commanding = true

	elif not is_zero_approx(place) or not is_zero_approx(copy) or \
		not is_zero_approx(paste) or not is_zero_approx(reskin):
		_place_lock = true

func update_target() -> void:
	var mesh : VoxelMesh = game.get_mode_mesh()
	var parent_pos : Vector3 = (get_parent() as ThirdPersonActor).position
	var pos : Vector3 = mesh.to_local(parent_pos) + Vector3.DOWN / 2
	var target : Vector3 = pos
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	game.targeti = target + Vector3.DOWN / 2

	if _debug_highlight != null:
		_debug_highlight.position = pos
	if _grid_highlight != null:
		_grid_highlight.position = Vector3(Vector3i(target + Vector3.DOWN / 2))

func select_start(pos : Vector3i) -> void:
		if not _start_highlight.visible: _start_highlight.visible = true
		_start_highlight.position = Vector3(pos)

func select_end(pos : Vector3i) -> void:
		if not _end_highlight.visible: _end_highlight.visible = true
		_end_highlight.position = Vector3(pos)

func deselect() -> void:
		_end_highlight.visible = false
		_start_highlight.visible = false
