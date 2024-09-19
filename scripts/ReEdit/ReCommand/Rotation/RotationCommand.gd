class_name RotationCommand
extends Command

var rot : int
var last : RotationMenu

func _init(_last : RotationMenu, _rot : int) -> void:
	rot = _rot
	super(str(_rot))

func command_use(_user : Actor) -> void:
	(last.last as EditorMenu).set_rot(rot)
