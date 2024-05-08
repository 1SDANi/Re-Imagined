class_name ThirdPersonPlayerController
extends Controller

@export var cam_speed_x : float
@export var cam_speed_y : float

@export var cam : NodePath

var _cam : VirtualCamera3D

var _pause_lock : bool

func _ready() -> void:
	game.inputHandler.add_mouse_movement(InputHandler.MOUSE_DIRECTION.UP, "Look Up")
	game.inputHandler.add_mouse_movement(InputHandler.MOUSE_DIRECTION.DOWN, "Look Down")
	game.inputHandler.add_mouse_movement(InputHandler.MOUSE_DIRECTION.LEFT, "Look Left")
	game.inputHandler.add_mouse_movement(InputHandler.MOUSE_DIRECTION.RIGHT, "Look Right")
	game.inputHandler.add_key(Key.KEY_W, "Move Front")
	game.inputHandler.add_key(Key.KEY_S, "Move Back")
	game.inputHandler.add_key(Key.KEY_A, "Move Left")
	game.inputHandler.add_key(Key.KEY_D, "Move Right")
	game.inputHandler.add_key(Key.KEY_ESCAPE, "Pause")
	game.inputHandler.set_cam_speed_x(cam_speed_x)
	game.inputHandler.set_cam_speed_y(cam_speed_y)
	_cam = get_node(cam)
	_pause_lock = false

func _physics_process(delta) -> void:
	var look_x : float = game.inputHandler.get_axis_value_total("Look Right", "Look Left", true)
	var look_y : float = game.inputHandler.get_axis_value_total("Look Up", "Look Down", true)

	var move_y : float = game.inputHandler.get_axis_value_spacey("Move Front", "Move Back", true)
	var move_x : float = game.inputHandler.get_axis_value_spacey("Move Left", "Move Right", true)

	var pause : float = game.inputHandler.get_action_value("Pause")

	var move : Vector3 = Vector3(move_x, 0, move_y).normalized()

	if _pause_lock:
		if pause == 0:
			_pause_lock = false
	elif pause > 0:
		game.inputHandler.toggle_mouse_capture()
		_pause_lock = true

	if not is_zero_approx(look_x):
		_cam.orbiting.yaw += look_x * game.inputHandler.get_cam_speed_x() * delta

	if not is_zero_approx(look_y):
		_cam.orbiting.pitch += look_y * game.inputHandler.get_cam_speed_y() * delta
		_cam.orbiting.pitch = clamp(_cam.orbiting.pitch, -TAU/4 + 1.2, TAU/4 - 0.1)

	if not move.is_zero_approx():
		var v : Vector3 = move.rotated(Vector3.UP, -_cam.orbiting.yaw)
		get_parent().move(Vector2(v.x, v.z))
