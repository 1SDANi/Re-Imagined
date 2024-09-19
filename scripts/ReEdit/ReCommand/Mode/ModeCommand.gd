class_name ModeCommand
extends Command

var last : ModeMenu
var mode : MapHandler.MODE

func _init(_name : String, _last : ModeMenu, _mode : MapHandler.MODE) -> void:
	super(_name)
	last = _last
	mode = _mode

func command_use(_user : Actor) -> void:
	(last.last as EditorMenu).set_mode(mode)
