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
	var mainset : Object = get_node(target)
	var mainget : Object = get_node(target)
	var subset : Object = mainset.get(subtarget)
	var subget : Object = mainget.get(subtarget)

	_label = get_node(Value)

	if subtarget:
		_set = Callable(subset, setter)
		_get = Callable(subget, getter)
	else:
		_set = Callable(mainset, setter)
		_get = Callable(mainget, getter)

	var val : float = _get.call()

	set_value(val)

func _value_changed(_val : float) -> void:
	_label.set_text(str(_val))
	_set.call(_val)
