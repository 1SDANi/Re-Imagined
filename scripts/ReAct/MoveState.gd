extends RefCounted
class_name MoveState

var static_friction : float
var friction : float
var speed : float
var force : float
var turn_static_friction : float
var turn_friction : float
var turn_speed : float
var turn_force : float
var turn_deadzone : float

func _init(sf : float, f : float, \
				s : float, v : float, \
				tsf : float, tf : float, \
				ts : float, tv : float, \
				td : float) -> void:
	static_friction = sf
	friction = f
	speed = s
	force = v
	turn_static_friction = tsf
	turn_friction = tf
	turn_speed = ts
	turn_force = tv
	turn_deadzone = td
