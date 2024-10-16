class_name ModeCommand
extends Command

var mode : MapHandler.MODE

func _init(_name : String, _last : ModeMenu, _mode : MapHandler.MODE) -> void:
	category = _name
	super(_name, _last)
	mode = _mode

func command_use(_user : Actor, _state : InputState) -> void:
	last.menu_select(_user)

func command_select(_user : Actor, _state : InputState) -> void:
	command_use(_user, _state)
