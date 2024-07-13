class_name ThirdPersonPlayerController
extends Controller

@export var cam_speed_x : float
@export var cam_speed_y : float

@export var cam : NodePath
@export var highlight : NodePath
@export var debug_highlight : NodePath

@export var terrain_label : NodePath
@export var solid_label : NodePath

var _terrain_label : Label
var _solid_label : Label

var _cam : VirtualCamera3D
var _highlight : Node3D
var _debug_highlight : Node3D

var _pause_lock : bool
var _place_lock : bool
var _ymove_lock : bool
var _solid_lock : bool

var terrain : String = "grassland"
var solid : bool = true
var start_pos : Vector3i
var end_pos : Vector3i

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
	game.input.add_key(Key.KEY_Q, "Solid")
	game.input.add_input("LB", "Solid GMP")
	game.input.add_key(Key.KEY_1, "Arctic")
	game.input.add_key(Key.KEY_2, "Tundra")
	game.input.add_key(Key.KEY_3, "Steppe")
	game.input.add_key(Key.KEY_4, "Prarie")
	game.input.add_key(Key.KEY_5, "Grassland")
	game.input.add_key(Key.KEY_6, "Semidesert")
	game.input.add_key(Key.KEY_7, "Desert")
	game.input.add_key(Key.KEY_8, "Badland")
	game.input.add_key(Key.KEY_9, "Water")
	game.input.add_key(Key.KEY_C, "Copy")
	game.input.add_key(Key.KEY_V, "Paste")
	game.input.add_input("LU", "Fertile GMP")
	game.input.add_input("LL", "Rugged GMP")
	game.input.add_input("LR", "Harsh GMP")
	game.input.add_input("LD", "Deadly GMP")
	game.input.add_input("LC", "Tropical GMP")
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
	_terrain_label = get_node(terrain_label)
	_solid_label = get_node(solid_label)
	_highlight = get_node(highlight)
	_debug_highlight = get_node(debug_highlight)
	_pause_lock = false
	_place_lock = false
	start_pos = Vector3i.ZERO
	end_pos = Vector3i.ZERO

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
	var solid_toggle : float = game.input.get_action_value("Solid")
	solid_toggle = max(solid_toggle, game.input.get_action_value("Solid GMP"))
	var arctic : float = game.input.get_action_value("Arctic")
	var tundra : float = game.input.get_action_value("Tundra")
	var steppe : float = game.input.get_action_value("Steppe")
	var prarie : float = game.input.get_action_value("Prarie")
	var grassland : float = game.input.get_action_value("Grassland")
	var semidesert : float = game.input.get_action_value("Semidesert")
	var desert : float = game.input.get_action_value("Desert")
	var badland : float = game.input.get_action_value("Badland")
	var water : float = game.input.get_action_value("Water")
	var copy : float = game.input.get_action_value("Copy")
	var paste : float = game.input.get_action_value("Paste")
	var fertile : float = game.input.get_action_value("Fertile GMP")
	var rugged : float = game.input.get_action_value("Rugged GMP")
	var harsh : float = game.input.get_action_value("Harsh GMP")
	var deadly : float = game.input.get_action_value("Deadly GMP")
	var tropical : float = game.input.get_action_value("Tropical GMP")


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

	if arctic: terrain = set_terrain("arctic")
	elif tundra: terrain = set_terrain("tundra")
	elif steppe: terrain = set_terrain("steppe")
	elif prarie: terrain = set_terrain("prarie")
	elif grassland: terrain = set_terrain("grassland")
	elif semidesert: terrain = set_terrain("semidesert")
	elif desert: terrain = set_terrain("desert")
	elif badland: terrain = set_terrain("badland")
	elif water: terrain = set_terrain("water")
	elif not tropical:
		if deadly: terrain = set_terrain("arctic")
		elif harsh: terrain = set_terrain("tundra")
		elif rugged: terrain = set_terrain("steppe")
		elif fertile: terrain = set_terrain("prarie")
	else:
		if fertile: terrain = set_terrain("grassland")
		elif harsh: terrain = set_terrain("semidesert")
		elif rugged: set_terrain("desert")
		elif deadly: set_terrain("badland")
	_terrain_label.set_text(terrain)

	if _solid_lock:
		if is_zero_approx(solid_toggle):
			_solid_lock = false
	elif not is_zero_approx(solid_toggle):
		_solid_lock = true
		solid = not solid
		_solid_label.set_text("yes" if solid else "no")

	if _place_lock:
		if is_zero_approx(place) and is_zero_approx(copy) and is_zero_approx(place):
			_place_lock = false
			if is_zero_approx(place):
				end_pos = target
	elif not is_zero_approx(place):
		_place_lock = true

		start_pos = target
		mesh.place(target, terrain, solid)

func set_terrain(t : String): terrain = ("air" if terrain == t else t)
