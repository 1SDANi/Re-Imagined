extends Button

@export var target : String
@export var subtarget : String
@export var caller : String

var _call : Callable

func _ready() -> void:
	if subtarget:
		_call = Callable(get_node(target).get(subtarget) as Object, caller)
	else:
		_call = Callable(get_node(target) as Object, caller)

func _pressed() -> void:
	_call.call()

