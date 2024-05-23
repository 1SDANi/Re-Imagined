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

func _ready() -> void:
	game.input.add_mouse_dir(InputHandler.MOUSE_DIR.UP, "Look Up")
	game.input.add_mouse_dir(InputHandler.MOUSE_DIR.DOWN, "Look Down")
	game.input.add_mouse_dir(InputHandler.MOUSE_DIR.LEFT, "Look Left")
	game.input.add_mouse_dir(InputHandler.MOUSE_DIR.RIGHT, "Look Right")
	game.input.add_mouse_button(MouseButton.MOUSE_BUTTON_LEFT, "Place")
	game.input.add_key(Key.KEY_W, "Move Front")
	game.input.add_key(Key.KEY_S, "Move Back")
	game.input.add_key(Key.KEY_A, "Move Left")
	game.input.add_key(Key.KEY_D, "Move Right")
	game.input.add_key(Key.KEY_ESCAPE, "Pause")
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

	if _pause_lock:
		if pause == 0:
			_pause_lock = false
	elif pause > 0:
		game.input.toggle_mouse_capture()
		_pause_lock = true

func handle_looking(delta : float) -> void:
	var look_x : float = game.input.get_axis_value_total("Look Right", "Look Left", true)
	var look_y : float = game.input.get_axis_value_total("Look Up", "Look Down", true)

	if not is_zero_approx(look_x):
		_cam.orbiting.yaw += look_x * game.input.get_cam_speed_x() * delta

	if not is_zero_approx(look_y):
		_cam.orbiting.pitch += look_y * game.input.get_cam_speed_y() * delta
		_cam.orbiting.pitch = clamp(_cam.orbiting.pitch, -TAU/4 + 1.2, TAU/4 - 0.1)

func handle_movement(delta: float) -> void:
	var move_y : float = game.input.get_axis_value_spacey("Move Front", "Move Back", true)
	var move_x : float = game.input.get_axis_value_spacey("Move Left", "Move Right", true)

	var move : Vector3 = Vector3(move_x, 0, move_y).normalized()

	if not move.is_zero_approx():
		var v : Vector3 = move.rotated(Vector3.UP, -_cam.orbiting.yaw)
		get_parent().move(Vector2(v.x, v.z), delta)
	else:
		get_parent().move(Vector2.ZERO, delta)

func handle_placing() -> void:
	var place : float = game.input.get_action_value("Place")

	var mesh : SlopeMesh = game.get_slope_mesh()
	var pos : Vector3 = mesh.to_local(get_parent().position)
	var forward : Vector3 = -get_parent().basis.z.normalized()
	var reach : float = get_parent().reach
	var target : Vector3 = pos + forward * reach
	if target.x < 0.0: target.x -= 1.0
	if target.y < 0.0: target.y -= 1.0
	if target.z < 0.0: target.z -= 1.0
	var targeti : Vector3i = target
	var grid : Vector3 = Vector3.UP * 0.5 + Vector3.RIGHT * 0.5 + Vector3.BACK * 0.5

	var raycast : VoxelRaycastResult = mesh.tool.raycast(pos, forward, reach)
	if raycast:
		targeti = raycast.position

	if _debug_highlight != null:
		_debug_highlight.position = pos + forward * reach
	_highlight.position = Vector3(targeti) + grid


	if _place_lock:
		if place == 0:
			_place_lock = false
	elif place > 0:
		_place_lock = true

		mesh.place(target)

