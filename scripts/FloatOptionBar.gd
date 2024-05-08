extends HScrollBar

@export var Value : NodePath
@export var target : String
@export var subtarget : String
@export var setter : String
@export var getter : String

var _label : Label
var _set : Callable
var _get : Callable

func _ready() -> void:
	_label = get_node(Value)

	if subtarget:
		_set = Callable(get_node(target).get(subtarget), setter)
		_get = Callable(get_node(target).get(subtarget), getter)
	else:
		_set = Callable(get_node(target), setter)
		_set = Callable(get_node(target), getter)

	set_value(_get.call())

func _value_changed(_value : float) -> void:
	_label.set_text(str(_value))
	_set.call(_value)
