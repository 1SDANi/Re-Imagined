class_name Command
extends RefCounted

var name : String
var category: String
var last : CommandMenu

func _init(_name : String, _last : CommandMenu) -> void:
	rename(_name)
	last = _last

func command_open(_user : Actor) -> void:
	pass

func command_use(_user : Actor, _state : InputState) -> void:
	command_open(_user)

func command_select(_user : Actor, _state : InputState) -> void:
	last.menu_select(_user)

func command_use_release(_user : Actor, _state : InputState) -> void:
	pass

func command_use_holding(_user : Actor, _state : InputState) -> void:
	pass

func tick(_delta : float) -> void:
	pass

func update_commands() -> void:
	pass

func rename(_name : String) -> void:
	name = _name
