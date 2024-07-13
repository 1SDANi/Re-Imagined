extends Actor
class_name ThirdPersonActor

@export var walk_turn_force : float
@export var run_turn_force : float

@export var walk_turn_speed : float
@export var run_turn_speed : float

@export var walk_turn_peak_time : float
@export var run_turn_peak_time : float

@export var walk_turn_deadzone : float
@export var run_turn_deadzone : float

@export var walk_turn_friction : float
@export var run_turn_friction : float

@export var walk_turn_static_friction : float
@export var run_turn_static_friction : float

@export var walk_max_speed : float
@export var run_max_speed : float

@export var walk_acceleration : float
@export var run_acceleration : float

@export var walk_deceleration : float
@export var run_deceleration : float

@export var walk_peak_time : float
@export var run_peak_time : float

@export var walk_friction : float
@export var run_friction : float

@export var walk_static_friction : float
@export var run_static_friction : float

var turn_time : float
var move_time : float
var turn_peak_time : float
var move_peak_time : float

func _ready() -> void:
	var walking_state : MoveState = MoveState.new(\
		walk_static_friction, \
		walk_friction, \
		walk_acceleration, \
		walk_deceleration, \
		walk_max_speed, \
		walk_peak_time, \
		deg_to_rad(walk_turn_static_friction), \
		deg_to_rad(walk_turn_friction), \
		deg_to_rad(walk_turn_speed), \
		deg_to_rad(walk_turn_force), \
		walk_turn_peak_time, \
		deg_to_rad(walk_turn_deadzone))
	append_state("Standing", walking_state)
	append_state("Walking", walking_state)

	var running_state : MoveState = MoveState.new(\
		run_static_friction, \
		run_friction, \
		walk_acceleration, \
		walk_deceleration, \
		run_max_speed, \
		run_peak_time, \
		deg_to_rad(run_turn_static_friction), \
		deg_to_rad(run_turn_friction), \
		deg_to_rad(run_turn_speed), \
		deg_to_rad(run_turn_force), \
		run_turn_peak_time, \
		deg_to_rad(run_turn_deadzone))
	append_state("Running", running_state)
	statenames.append("Running")
	set_state("Standing")

func append_state(key : String, value : MoveState) -> void:
	statenames.append(key)
	states.append(value)

func set_state(key : String) -> void:
	state = statenames.find(key)
	max_speed = states[state].max_speed
	acceleration = states[state].acceleration
	deceleration = states[state].deceleration
	pos_friction = states[state].friction
	pos_static_friction = states[state].static_friction
	rot_friction = states[state].turn_friction
	rot_static_friction = states[state].turn_static_friction
	turn_deadzone = states[state].turn_deadzone
	turn_peak_time = states[state].turn_peak_time
	move_peak_time = states[state].peak_time

func move(vector : Vector2, delta : float) -> void:
	var v : Vector3 = Vector3(vector.x, 0, vector.y)

	if not is_zero_approx(v.length()):
		var cross : Vector3 = v.cross(basis.z)
		var dot : float = (v.dot(basis.z) + 1) / 2
		var diff : float = v.angle_to(Vector3(basis.z.x, 0, basis.z.z))

		if diff > turn_deadzone * 2:
			turn_goal = vector
			turn_time += delta
			if cross.y > 0.0:
				turn_right(1.0)
			else:
				turn_left(1.0)
		else:
			turn_time = 0.0
			fix_angle(atan2(vector.x, vector.y))

		move_time += delta
		locomote(-basis.z, vector.length(), minf(move_time / move_peak_time, dot))
	else:
		turn_time = 0.0
		move_time = 0.0
		locomote(-basis.z, vector.length(), 1.0)
		stop_turning(1.0)
