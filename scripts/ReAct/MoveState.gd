extends RefCounted
class_name MoveState

var static_friction : float
var friction : float
var acceleration : float
var deceleration : float
var max_speed : float
var peak_time : float
var turn_static_friction : float
var turn_friction : float
var turn_speed : float
var turn_force : float
var turn_peak_time : float
var turn_deadzone : float

func _init(sf : float, f : float, \
				ac : float, dc : float,
				ms : float, pt : float, \
				tsf : float, tf : float, \
				ts : float, tv : float, \
				tpt : float, td : float) -> void:
	static_friction = sf
	friction = f
	acceleration = ac
	deceleration = dc
	max_speed = ms
	peak_time = pt
	turn_static_friction = tsf
	turn_friction = tf
	turn_speed = ts
	turn_force = tv
	turn_peak_time = tpt
	turn_deadzone = td
