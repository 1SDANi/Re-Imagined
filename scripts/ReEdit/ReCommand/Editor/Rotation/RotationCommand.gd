class_name RotationCommand
extends Command

var rot : int

func _init(_last : DetailMenu, _rot : int) -> void:
	rot = _rot
	category = str(_rot)
	super(str(_rot), _last)
