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

var editor : EditorMenu

const c : InputAxis.AxisType = InputAxis.AxisType.CANCEL
const p : InputAxis.BiasType = InputAxis.BiasType.POS

func _ready() -> void:
	game.input.set_input_mode(InputHandler.InputMode.KBM)
	if game.input.add_mouse_dir(InputHandler.MOUSE_DIR.UP, "Look Up"):
		pass
	if game.input.add_mouse_dir(InputHandler.MOUSE_DIR.DOWN, "Look Down"):
		pass
	if not game.input.add_input("RY-", "Look Up"):
		pass
	if not game.input.add_input("RY+", "Look Down"):
		pass
	if game.input.add_axis("Look Vertical", c, p):
		pass
	if not game.input.set_deadzone("Look Up", 0.5):
		pass
	if not game.input.set_deadzone("Look Down", 0.5):
		pass
	if not game.input.bind_axis("Look Down", "Look Vertical", false):
		pass
	if not game.input.bind_axis("Look Up", "Look Vertical", true):
		pass
	if game.input.add_mouse_dir(InputHandler.MOUSE_DIR.LEFT, "Look Left"):
		pass
	if game.input.add_mouse_dir(InputHandler.MOUSE_DIR.RIGHT, "Look Right"):
		pass
	if not game.input.set_deadzone("Look Left", 0.5):
		pass
	if not game.input.set_deadzone("Look Right", 0.5):
		pass
	if not game.input.add_input("RX-", "Look Left"):
		pass
	if not game.input.add_input("RX+", "Look Right"):
		pass
	if game.input.add_axis("Look Horizontal", c, p):
		pass
	if not game.input.bind_axis("Look Left", "Look Horizontal", false):
		pass
	if not game.input.bind_axis("Look Right", "Look Horizontal", true):
		pass
	if not game.input.add_mouse_button(MouseButton.MOUSE_BUTTON_LEFT, "Use Command"):
		pass
	if not game.input.add_key(Key.KEY_Q, "Close Menu"):
		pass
	if not game.input.add_key(Key.KEY_E, "Open Menu"):
		pass
	if not game.input.add_input("LL", "Close Menu"):
		pass
	if not game.input.add_input("LR", "Open Menu"):
		pass
	if not game.input.add_axis("Menu", c, p):
		pass
	if not game.input.bind_axis("Open Menu", "Menu", true):
		pass
	if not game.input.bind_axis("Close Menu", "Menu", false):
		pass
	if not game.input.add_key(Key.KEY_F, "Command Down"):
		pass
	if not game.input.add_key(Key.KEY_R, "Command Up"):
		pass
	if not game.input.add_input("LD", "Command Down"):
		pass
	if not game.input.add_input("LU", "Command Up"):
		pass
	if not game.input.add_axis("Command", c, p):
		pass
	if not game.input.bind_axis("Command Down", "Command", true):
		pass
	if not game.input.bind_axis("Command Up", "Command", false):
		pass
	if not game.input.add_key(Key.KEY_W, "Move Front"):
		pass
	if not game.input.add_key(Key.KEY_S, "Move Back"):
		pass
	if not game.input.add_input("LY-", "Move Front"):
		pass
	if not game.input.add_input("LY+", "Move Back"):
		pass
	if not game.input.add_axis("Move Vertical", c, p):
		pass
	if not game.input.bind_axis("Move Back", "Move Vertical", false):
		pass
	if not game.input.bind_axis("Move Front", "Move Vertical", true):
		pass
	if not game.input.add_key(Key.KEY_A, "Move Left"):
		pass
	if not game.input.add_key(Key.KEY_D, "Move Right"):
		pass
	if not game.input.add_input("LX-", "Move Left"):
		pass
	if not game.input.add_input("LX+", "Move Right"):
		pass
	if not game.input.add_axis("Move Horizontal", c, p):
		pass
	if not game.input.bind_axis("Move Left", "Move Horizontal", true):
		pass
	if not game.input.bind_axis("Move Right", "Move Horizontal", false):
		pass
	if not game.input.add_key(Key.KEY_ESCAPE, "Pause"):
		pass
	if not game.input.add_input("RC", "Pause"):
		pass
	if not game.input.add_key(Key.KEY_SPACE, "Rise"):
		pass
	if not game.input.add_input("RD", "Rise"):
		pass
	if not game.input.add_key(Key.KEY_SHIFT, "Fall"):
		pass
	if not game.input.add_input("RL", "Fall"):
		pass
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
	(get_parent() as Actor).set_command_menu(_wheel)

	game.input.set_action_mode(InputHandler.ACTION_MODE.WORLD)

	update_target()

	if not game.InputsReady.connect(inputs_ready) != OK:
		pass

func inputs_ready(delta : float) -> void:
	handle_pausing()

	if game.input.is_mouse_free(): return
	if game.input.action_mode != InputHandler.ACTION_MODE.WORLD: return

	handle_looking(delta)
	handle_movement(delta)
	handle_placing(delta)

func handle_pausing() -> void:
	var pause : InputState = game.input.get_state("Pause")

	if _pause_lock:
		if is_zero_approx(pause.value):
			_pause_lock = false
	elif not is_zero_approx(pause.value):
		game.input.toggle_mouse_capture()
		_pause_lock = true

func handle_looking(delta : float) -> void:
	var look_x : InputState = game.input.get_axis_state("Look Horizontal")
	var look_y : InputState = game.input.get_axis_state("Look Vertical")

	if not is_zero_approx(look_x.value):
		_cam.orbiting.yaw += look_x.value * game.input.get_cam_speed_x() * delta

	if not is_zero_approx(look_y.value):
		_cam.orbiting.pitch += look_y.value * game.input.get_cam_speed_y() * delta
		_cam.orbiting.pitch = clamp(_cam.orbiting.pitch, -TAU/64 * 3, TAU/64 * 15)

func handle_movement(delta: float) -> void:
	var move_y : InputState = game.input.get_axis_state("Move Vertical")
	var move_x : InputState = game.input.get_axis_state("Move Horizontal")
	var parent : ThirdPersonActor = get_parent()

	var move : Vector3 = Vector3(move_x.value, 0, move_y.value).normalized()

	var rise : InputState = game.input.get_state("Rise")

	var fall : InputState = game.input.get_state("Fall")

	if not move.is_zero_approx():
		var v : Vector3 = move.rotated(Vector3.UP, -_cam.orbiting.yaw)
		parent.fix_angle(atan2(v.x, v.z))
		parent.move(Vector2(v.x, v.z), delta)
	else:
		parent.move(Vector2.ZERO, delta)

	var ymove : bool = false

	if _ymove_lock:
		if is_zero_approx(rise.value) and is_zero_approx(fall.value):
			_ymove_lock = false
	elif not is_zero_approx(rise.value) or not is_zero_approx(fall.value):
		_ymove_lock = true
		ymove = true

	if ymove:
		var _mesh : SlopeMesh = game.get_slope_mesh()
		var off : Vector3 = Vector3(0, 1, 0)
		if is_zero_approx(rise.value) and not is_zero_approx(fall.value):
			off = Vector3(0, -1, 0)
		parent.position += off
		parent.position.y = floor(parent.position.y)

func handle_placing(_delta: float) -> void:
	var command : InputState = game.input.get_axis_state("Command")

	var menu : InputState = game.input.get_axis_state("Menu")

	var use : InputState = game.input.get_state("Use Command")

	update_target()

	if commanding:
		if use.is_zero:
			(get_parent() as Actor).command_use_release(use)
			commanding = false
		else:
			(get_parent() as Actor).command_use_holding(use)

	if _command_lock:
		if is_zero_approx(command.value) and is_zero_approx(menu.value):
			_command_lock = false
	elif not is_zero_approx(command.value) or not is_zero_approx(menu.value) or \
		not is_zero_approx(use.value):
		_command_lock = true
		if command.value > 0:
			(get_parent() as Actor).command_up()
		elif command.value < 0:
			(get_parent() as Actor).command_down()
		if menu.value > 0:
			(get_parent() as Actor).command_open()
		elif menu.value < 0:
			(get_parent() as Actor).command_close()
		if not is_zero_approx(use.value) and not commanding:
			commanding = true
			if (get_parent() as Actor).is_selecting():
				(get_parent() as Actor).command_select(use)
			else:
				(get_parent() as Actor).command_use(use)

func update_target() -> void:
	var mesh : VoxelMesh = game.get_mode_mesh(editor.get_mode())
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
