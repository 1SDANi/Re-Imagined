extends TextEdit

@export var target : String
@export var subtarget : String
@export var setter : String
@export var getter : String

var _set : Callable
var _get : Callable

func _ready() -> void:
	if subtarget:
		_set = Callable(get_node(target).get(subtarget) as Object, setter)
		_get = Callable(get_node(target).get(subtarget) as Object, getter)
	else:
		_set = Callable(get_node(target), setter)
		_get = Callable(get_node(target), getter)

	if not text_changed.connect(_text_changed) == OK:
		print("failed to connect")

	set_text(_get.call() as String)

func _text_changed() -> void:
	_set.call(get_text())
