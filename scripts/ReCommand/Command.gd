class_name Command
extends RefCounted

var name : String

func _init(_name : String) -> void:
	rename(_name)

func command_open(_user : Actor) -> void:
	command_use(_user)

func command_use(_user : Actor) -> void:
	pass

func command_open_release_hold(_user : Actor) -> void:
	command_use_release_hold(_user)

func command_open_release_tap(_user : Actor) -> void:
	command_use_release_tap(_user)

func command_use_release_hold(_user : Actor) -> void:
	pass

func command_use_release_tap(_user : Actor) -> void:
	pass

func tick(_delta : float) -> void:
	pass

func update_commands() -> void:
	pass

func rename(_name : String) -> void:
	name = _name
