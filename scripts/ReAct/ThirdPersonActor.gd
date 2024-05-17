extends Actor
class_name ThirdPersonActor

@export var walk_turn_force : float
@export var run_turn_force : float

@export var walk_turn_speed : float
@export var run_turn_speed : float

@export var walk_turn_deadzone : float
@export var run_turn_deadzone : float

@export var walk_turn_friction : float
@export var run_turn_friction : float

@export var walk_turn_static_friction : float
@export var run_turn_static_friction : float

@export var walk_force : float
@export var run_force : float

@export var walk_speed : float
@export var run_speed : float

@export var walk_friction : float
@export var run_friction : float

@export var walk_static_friction : float
@export var run_static_friction : float

func _ready() -> void:
	states.append(
		MoveState.new(
			walk_static_friction, \
			walk_friction, \
			walk_speed, \
			walk_force, \
			deg_to_rad(walk_turn_static_friction), \
			deg_to_rad(walk_turn_friction), \
			deg_to_rad(walk_turn_speed), \
			deg_to_rad(walk_turn_force), \
			deg_to_rad(walk_turn_deadzone)))
	statenames.append("Standing")
	states.append(
		MoveState.new(\
			walk_static_friction, \
			walk_friction, \
			walk_speed, \
			walk_force, \
			deg_to_rad(walk_turn_static_friction), \
			deg_to_rad(walk_turn_friction), \
			deg_to_rad(walk_turn_speed), \
			deg_to_rad(walk_turn_force), \
			deg_to_rad(walk_turn_deadzone)))
	statenames.append("Walking")
	states.append(
		MoveState.new(\
			run_static_friction, \
			run_friction, \
			run_speed, \
			run_force, \
			deg_to_rad(run_turn_static_friction), \
			deg_to_rad(run_turn_friction), \
			deg_to_rad(run_turn_speed), \
			deg_to_rad(run_turn_force), \
			deg_to_rad(run_turn_deadzone)))
	statenames.append("Running")
	state = statenames.find("Standing")
	pos_friction = states[state]["friction"]
	pos_static_friction = states[state]["static_friction"]
	rot_friction = states[state]["turn_friction"]
	rot_static_friction = states[state]["turn_static_friction"]
	turn_deadzone = states[state]["turn_deadzone"]

func move(vector : Vector2):
	var v : Vector3 = Vector3(vector.x, 0, vector.y)

	if not is_zero_approx(v.length()):
		var cross : Vector3 = v.cross(basis.z)
		var dot : float = (v.dot(basis.z) + 1) / 2
		var diff : float = v.angle_to(Vector3(basis.z.x, 0, basis.z.z))

		if diff > turn_deadzone * 2:
			turn_goal = vector
			if cross.y > 0.0:
				turn_right()
			else:
				turn_left()
		else:
			fix_angle(atan2(vector.x, vector.y))

		if not is_zero_approx(dot):
			locomote(-basis.z * dot)
	else:
		stop_turning()
