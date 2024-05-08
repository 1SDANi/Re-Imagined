class_name Actor
extends Prop

var state : int
var statenames : Array[String]
var states : Array[MoveState]

func locomote(vector : Vector3):
	if pos_inertia.length() < states[state].speed:
		var diff : float = states[state].speed - pos_inertia.length()
		var rem : float = min(states[state].force, diff)
		pos_inertia += vector.normalized() * rem

func turn_right():
	if rot_inertia.length() < states[state].turn_speed:
		if turn_snap == false: turn_snap = true
		rot_inertia.y -= states[state].turn_force

func turn_left():
	if rot_inertia.length() < states[state].turn_speed:
		if turn_snap == false: turn_snap = true
		rot_inertia.y += states[state].turn_force
