extends Label

@export var target : String
@export var subtarget : String
@export var getter : String

var _get : Callable

func _ready() -> void:
	if subtarget:
		_get = Callable(get_node(target).get(subtarget) as Object, getter)
	else:
		_get = Callable(get_node(target) as Object, getter)

func _process(_delta : float) -> void:
	set_text(_get.call() as String)
