class_name Prop
extends Asset

var rot_inertia : Vector3
var pos_inertia : Vector3

var pos_friction : float
var rot_friction : float

var pos_static_friction : float
var rot_static_friction : float

var mass : float

var turn_deadzone : float
var turn_goal : Vector2
var turn_snap : bool = false
var static_friction : bool = true

func _ready() -> void:
	motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED

func _physics_process(delta: float) -> void:
	apply_friction(delta)
	apply_inertia(delta)

func apply_pos_force(angle : Vector3, force : float):
	pos_inertia += angle.normalized() * force

func apply_inertia(delta : float):
	apply_rot_inertia(delta)
	apply_pos_inertia(delta)

func apply_rot_inertia(delta : float):
	if rot_inertia.length() > rot_static_friction:
		if turn_snap:
			var cur : Vector3 = Vector3(basis.z.x, 0, basis.z.z)
			var des : Vector3 = Vector3(turn_goal.x, 0, turn_goal.y)
			var diff : float = cur.angle_to(des)
			if diff < turn_deadzone:
				fix_angle(atan2(turn_goal.x, turn_goal.y))
				return

		rotation += rot_inertia * delta

func apply_pos_inertia(delta : float):
	if pos_inertia.length() > pos_static_friction or not static_friction:
		velocity = pos_inertia * delta
	else:
		velocity = Vector3.ZERO
	move_and_slide()

func apply_friction(delta : float):
	#apply_pos_friction(delta)
	apply_rot_friction(delta)

func apply_pos_friction(delta : float):
	if pos_inertia.length() > pos_static_friction or not static_friction:
		pos_inertia -= pos_inertia.normalized() * pos_friction * delta
	else:
		stop()

func apply_rot_friction(delta : float):
	if rot_inertia.length() > rot_static_friction:
		rot_inertia -= rot_inertia.normalized() * rot_friction * delta
	else:
		fix_angle(rotation.y)

func stop():
	pos_inertia = Vector3.ZERO

func fix_angle(angle : float):
	if turn_snap == true: turn_snap = false
	rotation.y = angle
	rot_inertia = Vector3.ZERO

