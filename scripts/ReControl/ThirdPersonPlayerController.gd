class_name ThirdPersonPlayerController
extends Controller

@export var cam_speed_x : float
@export var cam_speed_y : float

@export var cam : NodePath
@export var highlight : NodePath
@export var debug_highlight : NodePath

var _cam : VirtualCamera3D
var _highlight : Node3D
var _debug_highlight : Node3D

var _pause_lock : bool
var _place_lock : bool
var _ymove_lock : bool

func _ready() -> void:
	game.input.add_mouse_dir(InputHandler.MOUSE_DIR.UP, "Look Up")
	game.input.add_input("RY+", "Look Up GMP")
	game.input.add_mouse_dir(InputHandler.MOUSE_DIR.DOWN, "Look Down")
	game.input.add_input("RY-", "Look Down GMP")
	game.input.add_mouse_dir(InputHandler.MOUSE_DIR.LEFT, "Look Left")
	game.input.add_input("RX-", "Look Left GMP")
	game.input.add_mouse_dir(InputHandler.MOUSE_DIR.RIGHT, "Look Right")
	game.input.add_input("RX+", "Look Right GMP")
	game.input.add_mouse_button(MouseButton.MOUSE_BUTTON_LEFT, "Place")
	game.input.add_input("RR", "Place GMP")
	game.input.add_key(Key.KEY_W, "Move Front")
	game.input.add_input("LY-", "Move Front GMP")
	game.input.add_key(Key.KEY_S, "Move Back")
	game.input.add_input("LY+", "Move Back GMP")
	game.input.add_key(Key.KEY_A, "Move Left")
	game.input.add_input("LX-", "Move Left GMP")
	game.input.add_key(Key.KEY_D, "Move Right")
	game.input.add_input("LX+", "Move Right GMP")
	game.input.add_key(Key.KEY_ESCAPE, "Pause")
	game.input.add_input("RC", "Pause GMP")
	game.input.add_key(Key.KEY_SPACE, "Rise")
	game.input.add_input("RD", "Rise GMP")
	game.input.add_key(Key.KEY_SHIFT, "Fall")
	game.input.add_input("RL", "Fall GMP")
	game.input.set_cam_speed_x(cam_speed_x)
	game.input.set_cam_speed_y(cam_speed_y)
	_cam = get_node(cam)
	_highlight = get_node(highlight)
	_debug_highlight = get_node(debug_highlight)
	_pause_lock = false
	_place_lock = false

func _physics_process(delta : float) -> void:
	handle_pausing()

	if game.input.is_mouse_free(): return

	handle_looking(delta)
	handle_movement(delta)
	handle_placing()

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

	var move : Vector3 = Vector3(move_x, 0, move_y).normalized()

	var rise : float = game.input.get_action_value("Rise")
	rise = max(rise, game.input.get_action_value("Rise GMP"))

	var fall : float = game.input.get_action_value("Fall")
	fall = max(fall, game.input.get_action_value("Fall GMP"))

	if not move.is_zero_approx():
		var v : Vector3 = move.rotated(Vector3.UP, -_cam.orbiting.yaw)
		get_parent().move(Vector2(v.x, v.z), delta)
	else:
		get_parent().move(Vector2.ZERO, delta)

	var ymove : bool = false

	if _ymove_lock:
		if is_zero_approx(rise) and is_zero_approx(fall):
			_ymove_lock = false
	elif not is_zero_approx(rise) or not is_zero_approx(fall):
		_ymove_lock = true
		ymove = true

	if ymove:
		var mesh : SlopeMesh = game.get_slope_mesh()
		var pos : Vector3 = mesh.to_local(get_parent().position)
		if pos.x < 0.0: pos.x -= 1.0
		if pos.y < 0.0: pos.y -= 1.0
		if pos.z < 0.0: pos.z -= 1.0
		var posi : Vector3i = pos
		var off : Vector3 = Vector3(0, 1, 0)
		var offi : Vector3i = Vector3i(0, 1, 0)
		if is_zero_approx(rise) and not is_zero_approx(fall):
			off = Vector3(0, -1, 0)
			offi = Vector3i(0, -1, 0)
		if mesh.get_voxel_tool().get_voxel(posi + offi) > 0:
			return
		if mesh.get_voxel_tool().get_voxel(posi + offi * 2) > 0:
			return
		get_parent().position += off
		get_parent().position.y = floor(get_parent().position.y)

func handle_placing() -> void:
	var place : float = game.input.get_action_value("Place")
	place = max(place, game.input.get_action_value("Place GMP"))

	var mesh : SlopeMesh = game.get_slope_mesh()
	var pos : Vector3 = mesh.to_local(get_parent().position) + Vector3.DOWN / 2
	var forward : Vector3 = -get_parent().basis.z.normalized()
	var reach : float = get_parent().reach
	var target : Vector3 = pos + forward * reach
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target + Vector3.DOWN / 2
	var grid : Vector3 = Vector3.UP * 0.5 + Vector3.RIGHT * 0.5 + Vector3.BACK * 0.5

	var raycast : VoxelRaycastResult = mesh.tool.raycast(pos, forward, reach)
	if raycast:
		targeti = raycast.position

	if _debug_highlight != null:
		_debug_highlight.position = pos + forward * reach
	_highlight.position = Vector3(targeti) + grid


	if _place_lock:
		if is_zero_approx(place):
			_place_lock = false
	elif not is_zero_approx(place):
		_place_lock = true

		mesh.place(target)

