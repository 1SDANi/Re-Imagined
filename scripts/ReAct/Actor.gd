class_name Actor
extends Prop

var command_menu : CommandMenu

var state : int
var statenames : Array[String]
var states : Array[MoveState]

var acceleration : float
var deceleration : float
var max_speed : float

@export var reach : float

func _ready() -> void:
	super()

func _process(delta : float) -> void:
	command_menu.tick_commands(delta)

func set_command_menu(c : CommandMenu) -> void:
	command_menu = c

func command_use() -> void:
	command_menu.command_use(self)

func command_use_release_hold() -> void:
	print("held")
	command_menu.command_use_release_hold(self)

func command_use_release_tap() -> void:
	print("held")
	command_menu.command_use_release_tap(self)

func command_open_release_hold() -> void:
	command_menu.command_open_release_hold(self)

func command_open_release_tap() -> void:
	command_menu.command_open_release_tap(self)

func command_open() -> void:
	command_menu.command_open(self)

func command_close() -> void:
	command_menu.command_close(self)

func command_up() -> void:
	command_menu.command_up()

func command_down() -> void:
	command_menu.command_down()

func locomote(vector : Vector3, target : float, mod : float) -> void:
	var dec : float = min(pos_inertia.length(), deceleration)
	var difference : float = target * max_speed - pos_inertia.length() + dec
	var acc : float = max(0, min(difference, acceleration)) * mod
	pos_inertia += vector.normalized() * acc - pos_inertia.normalized() * dec
	static_friction = false if acc > 0 else true

func turn_right(mod : float) -> void:
	if rot_inertia.y > -states[state].turn_speed:
		if turn_snap == false: turn_snap = true
		rot_inertia.y -= states[state].turn_force * mod
		if absf(rot_inertia.y) < states[state].turn_static_friction:
			rot_inertia.y = -states[state].turn_static_friction

func turn_left(mod : float) -> void:
	if rot_inertia.y < states[state].turn_speed:
		if turn_snap == false: turn_snap = true
		rot_inertia.y += states[state].turn_force * mod
		if absf(rot_inertia.y) < states[state].turn_static_friction:
			rot_inertia.y = states[state].turn_static_friction

func stop_turning(mod : float) -> void:
	var friction : float = states[state].turn_friction
	friction +=  + states[state].turn_static_friction
	if rot_inertia.y < (-states[state].turn_force + friction) * mod:
		turn_left(mod)
	elif rot_inertia.y > (states[state].turn_force + friction) * mod:
		turn_right(mod)
	else:
		fix_angle(rotation.y)

