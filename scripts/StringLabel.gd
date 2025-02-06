extends Label

@export var target : String
@export var subtarget : String
@export var getter : String

var _get : Callable

func _ready() -> void:
	var mainget : Object = get_node(target)
	var subget : Object = mainget.get(subtarget)

	if subtarget:
		_get = Callable(subget, getter)
	else:
		_get = Callable(mainget, getter)

func _process(_delta : float) -> void:
	var val : String = _get.call()
	set_text(val)
